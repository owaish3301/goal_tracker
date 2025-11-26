import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/productivity_data.dart';
import '../../data/repositories/habit_metrics_repository.dart';
import '../../data/repositories/productivity_data_repository.dart';
import 'database_service.dart';

/// Service for managing habit formation metrics and calculations
/// Tracks streaks, consistency, and identifies optimal times for each goal
class HabitFormationService {
  final HabitMetricsRepository _metricsRepo;
  final ProductivityDataRepository _productivityRepo;

  HabitFormationService(this._metricsRepo, this._productivityRepo);

  // === Core Metrics Updates ===

  /// Update metrics when a task is completed
  /// Call this after a scheduled task is marked as completed
  Future<void> updateMetricsOnCompletion({
    required int goalId,
    required DateTime completedAt,
    required int actualDuration,
    required int productivityRating,
  }) async {
    // Update streak
    await _metricsRepo.incrementStreak(goalId, completedAt);

    // Recalculate consistency scores based on historical data
    await _recalculateConsistency(goalId);
  }

  /// Update metrics when a scheduled task is skipped/missed
  /// Call this at end of day or when task is explicitly skipped
  Future<void> updateMetricsOnSkip(int goalId) async {
    // Check if there was a completion today before resetting
    final metrics = await _metricsRepo.getMetricsForGoal(goalId);
    if (metrics == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (metrics.lastCompletedDate != null) {
      final lastDate = DateTime(
        metrics.lastCompletedDate!.year,
        metrics.lastCompletedDate!.month,
        metrics.lastCompletedDate!.day,
      );

      // Only reset if last completion wasn't today
      if (lastDate.isBefore(today)) {
        await _metricsRepo.resetStreak(goalId);
      }
    } else {
      // No completions ever - streak stays at 0
    }

    // Increment scheduled count
    await _metricsRepo.incrementScheduled(goalId);
  }

  /// Increment scheduled count (call when a task is scheduled for a goal)
  Future<void> markGoalScheduled(int goalId) async {
    await _metricsRepo.incrementScheduled(goalId);
  }

  // === Consistency Calculations ===

  /// Calculate and update consistency scores from historical data
  Future<void> _recalculateConsistency(int goalId) async {
    final data = await _productivityRepo.getDataForGoal(goalId);
    if (data.isEmpty) return;

    // Calculate overall consistency score
    final consistencyScore = _calculateConsistencyScore(data);

    // Calculate time consistency and find sticky hour
    final timeAnalysis = _analyzeTimePatterns(data);

    await _metricsRepo.updateConsistencyScores(
      goalId,
      consistencyScore: consistencyScore,
      timeConsistency: timeAnalysis.timeConsistency,
      stickyHour: timeAnalysis.stickyHour,
      stickyDayOfWeek: timeAnalysis.stickyDayOfWeek,
    );
  }

  /// Calculate consistency score from productivity data
  /// Returns value between 0.0 and 1.0
  double _calculateConsistencyScore(List<ProductivityData> data) {
    if (data.isEmpty) return 0.0;

    // Count high-productivity completions (score 3.0+)
    final goodCompletions = data.where((d) => d.productivityScore >= 3.0).length;
    return goodCompletions / data.length;
  }

  /// Analyze time patterns to find sticky hour and time consistency
  _TimeAnalysisResult _analyzeTimePatterns(List<ProductivityData> data) {
    if (data.isEmpty) {
      return _TimeAnalysisResult(
        timeConsistency: 0.0,
        stickyHour: null,
        stickyDayOfWeek: null,
      );
    }

    // Count completions by hour
    final hourCounts = <int, int>{};
    final dayOfWeekCounts = <int, int>{};

    for (final d in data) {
      final hour = d.hourOfDay;
      final dayOfWeek = d.dayOfWeek;

      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
      dayOfWeekCounts[dayOfWeek] = (dayOfWeekCounts[dayOfWeek] ?? 0) + 1;
    }

    // Find most common hour (sticky hour)
    int? stickyHour;
    int maxHourCount = 0;
    hourCounts.forEach((hour, count) {
      if (count > maxHourCount) {
        maxHourCount = count;
        stickyHour = hour;
      }
    });

    // Find most common day of week
    int? stickyDayOfWeek;
    int maxDayCount = 0;
    dayOfWeekCounts.forEach((day, count) {
      if (count > maxDayCount) {
        maxDayCount = count;
        stickyDayOfWeek = day;
      }
    });

    // Calculate time consistency (how often user completes at sticky hour)
    final timeConsistency = stickyHour != null
        ? maxHourCount / data.length
        : 0.0;

    return _TimeAnalysisResult(
      timeConsistency: timeConsistency,
      stickyHour: stickyHour,
      stickyDayOfWeek: stickyDayOfWeek,
    );
  }

  // === Query Methods ===

  /// Get current streak status for a goal
  Future<StreakStatus> getStreakStatus(int goalId) async {
    final metrics = await _metricsRepo.getMetricsForGoal(goalId);
    if (metrics == null) {
      return StreakStatus(
        currentStreak: 0,
        longestStreak: 0,
        isAtRisk: false,
        daysUntilHabitLock: 21,
        habitStage: 'Starting',
      );
    }

    return StreakStatus(
      currentStreak: metrics.currentStreak,
      longestStreak: metrics.longestStreak,
      isAtRisk: metrics.streakAtRisk,
      daysUntilHabitLock: metrics.daysUntilHabitLock,
      habitStage: metrics.habitStage,
    );
  }

  /// Find the sticky (most successful) time for a goal
  Future<StickyTime?> findStickyTime(int goalId) async {
    final metrics = await _metricsRepo.getMetricsForGoal(goalId);
    if (metrics == null || metrics.stickyHour == null) return null;

    return StickyTime(
      hour: metrics.stickyHour!,
      dayOfWeek: metrics.stickyDayOfWeek,
      consistency: metrics.timeConsistency,
    );
  }

  /// Get all goals with their streak status, sorted by streak
  Future<List<GoalStreakInfo>> getAllGoalStreaks() async {
    final allMetrics = await _metricsRepo.getMetricsByStreak();
    return allMetrics.map((m) => GoalStreakInfo(
      goalId: m.goalId,
      currentStreak: m.currentStreak,
      longestStreak: m.longestStreak,
      consistencyScore: m.consistencyScore,
      habitStage: m.habitStage,
      isAtRisk: m.streakAtRisk,
    )).toList();
  }

  /// Get goals at risk of losing their streak today
  Future<List<int>> getGoalsAtRisk() async {
    final atRiskMetrics = await _metricsRepo.getAtRiskStreaks();
    return atRiskMetrics.map((m) => m.goalId).toList();
  }

  /// Initialize metrics from historical productivity data
  /// Call this for goals that don't have metrics yet
  Future<void> initializeFromHistory(int goalId) async {
    // Get or create metrics
    final metrics = await _metricsRepo.getOrCreateMetricsForGoal(goalId);
    
    // Get historical data
    final data = await _productivityRepo.getDataForGoal(goalId);
    if (data.isEmpty) return;

    // Calculate streaks from historical data
    final streakInfo = _calculateHistoricalStreak(data);
    
    metrics.currentStreak = streakInfo.currentStreak;
    metrics.longestStreak = streakInfo.longestStreak;
    metrics.lastCompletedDate = streakInfo.lastCompletedDate;
    metrics.totalCompletions = data.length;

    await _metricsRepo.upsertMetrics(metrics);

    // Calculate consistency
    await _recalculateConsistency(goalId);
  }

  /// Calculate streak from historical productivity data
  _HistoricalStreakInfo _calculateHistoricalStreak(List<ProductivityData> data) {
    if (data.isEmpty) {
      return _HistoricalStreakInfo(
        currentStreak: 0,
        longestStreak: 0,
        lastCompletedDate: null,
      );
    }

    // Sort by date (newest first)
    final sorted = List<ProductivityData>.from(data)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    DateTime? lastDate;
    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;

    for (int i = 0; i < sorted.length; i++) {
      final date = DateTime(
        sorted[i].recordedAt.year,
        sorted[i].recordedAt.month,
        sorted[i].recordedAt.day,
      );

      if (lastDate == null) {
        tempStreak = 1;
        lastDate = date;
      } else {
        final diff = lastDate.difference(date).inDays;
        if (diff == 1) {
          tempStreak++;
        } else if (diff > 1) {
          if (tempStreak > longestStreak) longestStreak = tempStreak;
          tempStreak = 1;
        }
        // diff == 0 means same day, don't increment
        lastDate = date;
      }
    }

    if (tempStreak > longestStreak) longestStreak = tempStreak;

    // Current streak - check if most recent is today or yesterday
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final mostRecentDate = DateTime(
      sorted.first.recordedAt.year,
      sorted.first.recordedAt.month,
      sorted.first.recordedAt.day,
    );
    final daysSinceLatest = today.difference(mostRecentDate).inDays;

    if (daysSinceLatest <= 1) {
      // Calculate current streak from most recent
      currentStreak = 1;
      for (int i = 1; i < sorted.length; i++) {
        final prevDate = DateTime(
          sorted[i - 1].recordedAt.year,
          sorted[i - 1].recordedAt.month,
          sorted[i - 1].recordedAt.day,
        );
        final currDate = DateTime(
          sorted[i].recordedAt.year,
          sorted[i].recordedAt.month,
          sorted[i].recordedAt.day,
        );
        if (prevDate.difference(currDate).inDays == 1) {
          currentStreak++;
        } else {
          break;
        }
      }
    }

    return _HistoricalStreakInfo(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastCompletedDate: sorted.first.recordedAt,
    );
  }
}

// === Data Classes ===

class _TimeAnalysisResult {
  final double timeConsistency;
  final int? stickyHour;
  final int? stickyDayOfWeek;

  _TimeAnalysisResult({
    required this.timeConsistency,
    required this.stickyHour,
    required this.stickyDayOfWeek,
  });
}

class _HistoricalStreakInfo {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;

  _HistoricalStreakInfo({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastCompletedDate,
  });
}

/// Streak status for a goal
class StreakStatus {
  final int currentStreak;
  final int longestStreak;
  final bool isAtRisk;
  final int daysUntilHabitLock;
  final String habitStage;

  StreakStatus({
    required this.currentStreak,
    required this.longestStreak,
    required this.isAtRisk,
    required this.daysUntilHabitLock,
    required this.habitStage,
  });
}

/// Sticky time information for a goal
class StickyTime {
  final int hour;
  final int? dayOfWeek;
  final double consistency;

  StickyTime({
    required this.hour,
    this.dayOfWeek,
    required this.consistency,
  });

  String get formattedHour {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour $period';
  }
}

/// Goal streak info for list displays
class GoalStreakInfo {
  final int goalId;
  final int currentStreak;
  final int longestStreak;
  final double consistencyScore;
  final String habitStage;
  final bool isAtRisk;

  GoalStreakInfo({
    required this.goalId,
    required this.currentStreak,
    required this.longestStreak,
    required this.consistencyScore,
    required this.habitStage,
    required this.isAtRisk,
  });
}

// === Provider ===

final habitFormationServiceProvider = Provider<HabitFormationService>((ref) {
  final metricsRepo = ref.watch(habitMetricsRepositoryProvider);
  final productivityRepo = ref.watch(productivityDataRepositoryProvider);
  return HabitFormationService(metricsRepo, productivityRepo);
});
