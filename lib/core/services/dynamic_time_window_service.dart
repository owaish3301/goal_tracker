import 'package:flutter/foundation.dart';
import '../../data/repositories/daily_activity_log_repository.dart';
import '../../data/repositories/productivity_data_repository.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../data/models/user_profile.dart';
import 'daily_activity_service.dart';

/// Service for calculating dynamic time windows based on user behavior
/// Learns from successful completions and adapts over time
/// Smart v2: Uses UserProfile as immediate baseline and learns daily
class DynamicTimeWindowService {
  final DailyActivityLogRepository _activityRepo;
  final ProductivityDataRepository _productivityRepo;
  final UserProfileRepository _profileRepo;
  // ignore: unused_field - Reserved for future activity-based learning
  final DailyActivityService _activityService;

  /// Minimum productivity score to consider a task "successful"
  static const double successThreshold = 3.5;

  /// Weight for learned data vs profile data (0.0 - 1.0)
  /// Increases as we get more data points
  static const double learningRate = 0.1;

  DynamicTimeWindowService({
    required DailyActivityLogRepository activityRepo,
    required ProductivityDataRepository productivityRepo,
    required UserProfileRepository profileRepo,
    required DailyActivityService activityService,
  }) : _activityRepo = activityRepo,
       _productivityRepo = productivityRepo,
       _profileRepo = profileRepo,
       _activityService = activityService;

  /// Get the effective time window for a date
  /// Combines learned patterns with profile defaults
  Future<DynamicTimeWindow> getTimeWindowForDate(DateTime date) async {
    final isWeekend = date.weekday >= 6;

    // Get profile defaults (The "Day 1" Baseline)
    final profile = await _profileRepo.getProfile();
    var defaultWake = profile?.wakeUpHour ?? (isWeekend ? 8 : 7);
    var defaultSleep = profile?.sleepHour ?? 23;

    // SAFETY CHECK: Ensure minimum window of 4 hours
    // Handle both normal (wake < sleep) and past-midnight (wake > sleep) scenarios
    const minWindowHours = 4;
    final activeHours = _calculateActiveHours(defaultWake, defaultSleep);
    if (activeHours < minWindowHours || activeHours > 20) {
      debugPrint(
        'WARNING: User profile has invalid time window (wake=$defaultWake, sleep=$defaultSleep, hours=$activeHours). Using defaults.',
      );
      defaultWake = isWeekend ? 8 : 7;
      defaultSleep = 23;
    }

    // Get learned patterns from activity
    final patterns = await _activityRepo.getActivityPatterns();

    // Calculate effective window using weighted average if patterns exist
    int effectiveWake = defaultWake;
    int effectiveSleep = defaultSleep;
    bool isLearned = false;

    if (isWeekend) {
      if (patterns.weekendWakeHour != null) {
        effectiveWake = _calculateWeightedHour(
          defaultWake,
          patterns.weekendWakeHour!.toDouble(),
          patterns.weekendDataPoints,
        );
        isLearned = true;
      }
      if (patterns.weekendSleepHour != null) {
        effectiveSleep = _calculateWeightedHour(
          defaultSleep,
          patterns.weekendSleepHour!.toDouble(),
          patterns.weekendDataPoints,
        );
        isLearned = true;
      }
    } else {
      if (patterns.weekdayWakeHour != null) {
        effectiveWake = _calculateWeightedHour(
          defaultWake,
          patterns.weekdayWakeHour!.toDouble(),
          patterns.weekdayDataPoints,
        );
        isLearned = true;
      }
      if (patterns.weekdaySleepHour != null) {
        effectiveSleep = _calculateWeightedHour(
          defaultSleep,
          patterns.weekdaySleepHour!.toDouble(),
          patterns.weekdaySleepHour!,
        );
        isLearned = true;
      }
    }

    // FINAL SAFETY CHECK: Ensure effective window is valid after learning adjustments
    final effectiveActiveHours = _calculateActiveHours(
      effectiveWake,
      effectiveSleep,
    );
    if (effectiveActiveHours < minWindowHours || effectiveActiveHours > 20) {
      debugPrint(
        'WARNING: Effective window invalid after learning (wake=$effectiveWake, sleep=$effectiveSleep, hours=$effectiveActiveHours). Using profile defaults.',
      );
      effectiveWake = defaultWake;
      effectiveSleep = defaultSleep;
    }

    // Get successful hours from productivity data for optimization
    final successfulHours = await _getSuccessfulHours(isWeekend: isWeekend);

    // Calculate optimal window based on successful completions
    final (optimalStart, optimalEnd) = _calculateOptimalWindow(
      successfulHours: successfulHours,
      baseWake: effectiveWake,
      baseSleep: effectiveSleep,
      profile: profile,
    );

    return DynamicTimeWindow(
      date: date,
      wakeHour: effectiveWake,
      sleepHour: effectiveSleep,
      optimalStartHour: optimalStart,
      optimalEndHour: optimalEnd,
      isLearned: isLearned,
      successfulHours: successfulHours,
    );
  }

  /// Calculate weighted hour between profile default and learned average
  int _calculateWeightedHour(
    int profileHour,
    double learnedHour,
    int dataPoints,
  ) {
    // Confidence grows with data points, capped at 0.9 (90% learned, 10% profile anchor)
    final confidence = (dataPoints * learningRate).clamp(0.0, 0.9);

    // Weighted average
    final weighted =
        (profileHour * (1 - confidence)) + (learnedHour * confidence);
    return weighted.round();
  }

  /// Calculate active hours handling both normal and past-midnight scenarios
  /// Normal: wake=7, sleep=23 -> 16 hours
  /// Past-midnight: wake=7, sleep=1 -> 18 hours (7->midnight + midnight->1)
  int _calculateActiveHours(int wakeHour, int sleepHour) {
    if (sleepHour > wakeHour) {
      // Normal case: e.g., wake 7, sleep 23 = 16 hours
      return sleepHour - wakeHour;
    } else {
      // Past-midnight case: e.g., wake 7, sleep 1 = (24-7) + 1 = 18 hours
      return (24 - wakeHour) + sleepHour;
    }
  }

  /// Get hours where tasks were completed successfully
  Future<List<SuccessfulHour>> _getSuccessfulHours({
    required bool isWeekend,
  }) async {
    // Get recent productivity data (limit to last 100 entries)
    final allData = await _productivityRepo.getRecentData(limit: 100);

    // Filter by weekend/weekday and success threshold
    final relevantData = allData.where((d) {
      final dataIsWeekend = d.dayOfWeek >= 5; // 0=Mon, 5=Sat, 6=Sun
      return dataIsWeekend == isWeekend &&
          d.wasCompleted &&
          d.productivityScore >= successThreshold;
    }).toList();

    if (relevantData.isEmpty) {
      return [];
    }

    // Group by hour and calculate stats
    final hourStats = <int, List<double>>{};
    for (final data in relevantData) {
      hourStats.putIfAbsent(data.hourOfDay, () => []);
      hourStats[data.hourOfDay]!.add(data.productivityScore);
    }

    // Convert to SuccessfulHour objects
    return hourStats.entries.map((entry) {
      final scores = entry.value;
      final avgScore = scores.reduce((a, b) => a + b) / scores.length;
      return SuccessfulHour(
        hour: entry.key,
        completionCount: scores.length,
        averageScore: avgScore,
      );
    }).toList()..sort((a, b) => b.averageScore.compareTo(a.averageScore));
  }

  /// Calculate optimal start and end hours based on successful completions
  /// Falls back to Profile Chronotype if no data
  (int, int) _calculateOptimalWindow({
    required List<SuccessfulHour> successfulHours,
    required int baseWake,
    required int baseSleep,
    UserProfile? profile,
  }) {
    // 1. If we have data, use it
    if (successfulHours.length >= 3) {
      // Lowered threshold for faster learning
      final hours = successfulHours.map((h) => h.hour).toList()..sort();
      final startIndex = (hours.length * 0.1).floor();
      final endIndex = (hours.length * 0.9).floor();

      var optimalStart = hours[startIndex];
      var optimalEnd = hours[endIndex];

      // Ensure within base window
      if (optimalStart < baseWake) optimalStart = baseWake;
      if (optimalEnd > baseSleep) optimalEnd = baseSleep;

      if (optimalEnd > optimalStart) {
        return (optimalStart, optimalEnd);
      }
    }

    // 2. Fallback to Profile Chronotype (Smart Default)
    if (profile != null) {
      final windows = profile.getChronoTypeWindows();
      final high = windows['high']!;
      // Use the high energy window as optimal
      return (high.$1, high.$2);
    }

    // 3. Generic Fallback
    return (baseWake + 2, baseSleep - 2);
  }

  /// Get goal-specific time window based on historical success
  Future<GoalTimeWindow?> getGoalTimeWindow(int goalId) async {
    // Get all successful completions for this goal
    final goalData = await _productivityRepo.getDataForGoal(goalId);

    final successfulData = goalData
        .where((d) => d.wasCompleted && d.productivityScore >= successThreshold)
        .toList();

    if (successfulData.length < 3) {
      // Lowered threshold
      return null;
    }

    // Calculate hour distribution
    final hourStats = <int, List<double>>{};
    for (final data in successfulData) {
      hourStats.putIfAbsent(data.hourOfDay, () => []);
      hourStats[data.hourOfDay]!.add(data.productivityScore);
    }

    // Find best hour
    int bestHour = 9; // Default
    double bestScore = 0.0;

    for (final entry in hourStats.entries) {
      final avgScore = entry.value.reduce((a, b) => a + b) / entry.value.length;
      if (avgScore > bestScore) {
        bestScore = avgScore;
        bestHour = entry.key;
      }
    }

    // Calculate time range where goal performs well
    final goodHours =
        hourStats.entries
            .where(
              (e) =>
                  e.value.reduce((a, b) => a + b) / e.value.length >=
                  successThreshold,
            )
            .map((e) => e.key)
            .toList()
          ..sort();

    if (goodHours.isEmpty) {
      return null;
    }

    return GoalTimeWindow(
      goalId: goalId,
      bestHour: bestHour,
      bestScore: bestScore,
      goodHoursStart: goodHours.first,
      goodHoursEnd: goodHours.last,
      dataPoints: successfulData.length,
    );
  }

  /// Check if we have enough data to provide learned windows
  Future<bool> hasLearnedWindows() async {
    final patterns = await _activityRepo.getActivityPatterns();
    return patterns.hasAnyPattern;
  }
}

/// Represents a dynamic time window for a date
class DynamicTimeWindow {
  final DateTime date;
  final int wakeHour;
  final int sleepHour;
  final int optimalStartHour;
  final int optimalEndHour;
  final bool isLearned;
  final List<SuccessfulHour> successfulHours;

  DynamicTimeWindow({
    required this.date,
    required this.wakeHour,
    required this.sleepHour,
    required this.optimalStartHour,
    required this.optimalEndHour,
    required this.isLearned,
    required this.successfulHours,
  });

  /// Get total active window in hours
  int get totalWindowHours {
    if (sleepHour > wakeHour) {
      return sleepHour - wakeHour;
    }
    return (24 - wakeHour) + sleepHour;
  }

  /// Get optimal window duration
  int get optimalWindowHours => optimalEndHour - optimalStartHour;

  /// Check if an hour is within the active window
  bool isActiveHour(int hour) {
    if (sleepHour > wakeHour) {
      return hour >= wakeHour && hour < sleepHour;
    }
    return hour >= wakeHour || hour < sleepHour;
  }

  /// Check if an hour is within the optimal window
  bool isOptimalHour(int hour) {
    return hour >= optimalStartHour && hour < optimalEndHour;
  }

  /// Get a score (0-1) for how good an hour is
  double getHourScore(int hour) {
    if (!isActiveHour(hour)) return 0.0;

    if (isOptimalHour(hour)) {
      // Find if this hour has success data
      final successHour = successfulHours.cast<SuccessfulHour?>().firstWhere(
        (h) => h?.hour == hour,
        orElse: () => null,
      );

      if (successHour != null) {
        // Normalize productivity score to 0-1 (assuming 1-5 scale)
        return ((successHour.averageScore - 1) / 4).clamp(0.5, 1.0);
      }

      return 0.8; // Good but no specific data
    }

    // Within active but not optimal
    return 0.4;
  }

  @override
  String toString() =>
      'DynamicTimeWindow($wakeHour:00-$sleepHour:00, optimal: $optimalStartHour:00-$optimalEndHour:00, learned: $isLearned)';
}

/// Represents an hour with successful completions
class SuccessfulHour {
  final int hour;
  final int completionCount;
  final double averageScore;

  SuccessfulHour({
    required this.hour,
    required this.completionCount,
    required this.averageScore,
  });
}

/// Represents goal-specific time preferences
class GoalTimeWindow {
  final int goalId;
  final int bestHour;
  final double bestScore;
  final int goodHoursStart;
  final int goodHoursEnd;
  final int dataPoints;

  GoalTimeWindow({
    required this.goalId,
    required this.bestHour,
    required this.bestScore,
    required this.goodHoursStart,
    required this.goodHoursEnd,
    required this.dataPoints,
  });

  /// Check if an hour is within the good hours range
  bool isGoodHour(int hour) {
    return hour >= goodHoursStart && hour <= goodHoursEnd;
  }
}
