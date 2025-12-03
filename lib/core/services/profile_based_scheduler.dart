import '../../data/models/goal.dart';
import '../../data/models/goal_category.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/user_profile_repository.dart';
import 'rule_based_scheduler.dart';

/// Profile-based scheduler that uses user profile and goal categories
/// for smarter time slot selection (Tier 2 of three-tier system)
class ProfileBasedScheduler {
  final UserProfileRepository _profileRepo;

  ProfileBasedScheduler(this._profileRepo);

  /// Get user profile (or default if not set)
  Future<UserProfile> _getProfile() async {
    final profile = await _profileRepo.getProfile();
    return profile ?? UserProfile.createDefault();
  }

  /// Score a time slot for a goal based on profile and category
  /// Returns a score from 0.0 to 1.0
  Future<TimeSlotScore> scoreTimeSlot({
    required Goal goal,
    required TimeSlot slot,
    required DateTime date,
  }) async {
    final profile = await _getProfile();
    final category = goal.category;

    double score = 0.5; // Base score
    final factors = <String, double>{};

    // 1. Chrono-type matching (Increased to 0.35 for "Smart Day 1")
    final chronoScore = _calculateChronoScore(
      profile: profile,
      hourOfDay: slot.start.hour,
    );
    factors['chronotype'] = chronoScore;
    score += chronoScore * 0.35;

    // 2. Category optimal hours (0.25)
    final categoryScore = category.getHourScore(slot.start.hour);
    factors['category'] = categoryScore;
    score += categoryScore * 0.25;

    // 3. Work hours avoidance (Reduced to 0.2 to allow flexibility)
    final workPenalty = _calculateWorkHoursPenalty(
      profile: profile,
      hourOfDay: slot.start.hour,
      category: category,
    );
    factors['work_penalty'] = workPenalty;
    score += workPenalty; // Note: workPenalty can be negative

    // 4. Active window bonus (0.1)
    final activeBonus = _calculateActiveWindowBonus(
      profile: profile,
      hourOfDay: slot.start.hour,
    );
    factors['active_window'] = activeBonus;
    score += activeBonus;

    // 5. Session length preference alignment (0.1)
    final sessionScore = _calculateSessionLengthScore(
      profile: profile,
      goalDuration: goal.targetDuration,
    );
    factors['session_length'] = sessionScore;
    score += sessionScore * 0.1;

    return TimeSlotScore(
      slot: slot,
      score: score.clamp(0.0, 1.0),
      factors: factors,
      method: 'profile-based',
    );
  }

  /// Calculate chrono-type score for a given hour
  /// 1.0 = optimal time, 0.5 = medium, 0.0 = low energy time
  double _calculateChronoScore({
    required UserProfile profile,
    required int hourOfDay,
  }) {
    final windows = profile.getChronoTypeWindows();

    final highWindow = windows['high']!;
    final mediumWindow = windows['medium']!;
    final lowWindow = windows['low']!;

    // Check if hour falls in high priority window
    if (_isHourInWindow(hourOfDay, highWindow.$1, highWindow.$2)) {
      return 1.0;
    }

    // Check if hour falls in medium priority window
    if (_isHourInWindow(hourOfDay, mediumWindow.$1, mediumWindow.$2)) {
      return 0.6;
    }

    // Check if hour falls in low priority window
    if (_isHourInWindow(hourOfDay, lowWindow.$1, lowWindow.$2)) {
      return 0.3;
    }

    // Default (outside defined windows)
    return 0.4;
  }

  /// Check if an hour is within a time window (handles midnight wrap)
  bool _isHourInWindow(int hour, int windowStart, int windowEnd) {
    if (windowEnd > windowStart) {
      // Normal case: e.g., 9-12
      return hour >= windowStart && hour < windowEnd;
    } else if (windowEnd < windowStart) {
      // Wraps around midnight: e.g., 20-2
      return hour >= windowStart || hour < windowEnd;
    }
    return false;
  }

  /// Calculate work hours penalty
  /// Returns negative value if scheduling during work hours (for personal goals)
  double _calculateWorkHoursPenalty({
    required UserProfile profile,
    required int hourOfDay,
    required GoalCategory category,
  }) {
    // Work category goals should be scheduled during work hours
    if (category == GoalCategory.work) {
      if (profile.isDuringWorkHours(hourOfDay)) {
        return 0.15; // Bonus for work goals during work hours
      }
      return -0.1; // Small penalty for work goals outside work hours
    }

    // Other categories - avoid work hours
    if (profile.isDuringWorkHours(hourOfDay)) {
      return -0.2; // Penalty for personal goals during work hours
    }

    return 0.0;
  }

  /// Calculate bonus for scheduling within user's active window
  double _calculateActiveWindowBonus({
    required UserProfile profile,
    required int hourOfDay,
  }) {
    final (wakeHour, sleepHour) = profile.getActiveHours();

    // Check if within active hours
    if (sleepHour > wakeHour) {
      // Normal case
      if (hourOfDay >= wakeHour && hourOfDay < sleepHour) {
        // Give bonus to hours not too close to wake or sleep
        final midpoint = wakeHour + (sleepHour - wakeHour) ~/ 2;
        final distanceFromMid = (hourOfDay - midpoint).abs();
        return (1.0 - distanceFromMid / ((sleepHour - wakeHour) / 2)) * 0.1;
      }
    } else {
      // Wraps midnight
      if (hourOfDay >= wakeHour || hourOfDay < sleepHour) {
        return 0.1;
      }
    }

    // Outside active window - no bonus
    return 0.0;
  }

  /// Calculate score based on session length preference match
  double _calculateSessionLengthScore({
    required UserProfile profile,
    required int goalDuration,
  }) {
    final preferred = profile.getPreferredDurationMinutes();

    // Calculate how well the goal duration matches preference
    final difference = (goalDuration - preferred).abs();

    if (difference <= 10) {
      return 1.0; // Within 10 minutes of preference
    } else if (difference <= 20) {
      return 0.7;
    } else if (difference <= 30) {
      return 0.4;
    }
    return 0.2;
  }

  /// Score all available slots for a goal
  Future<List<TimeSlotScore>> scoreAllSlots({
    required Goal goal,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
    bool squeezeBuffer = false,
  }) async {
    final freeSlots = _getFreeSlots(
      availableSlots,
      usedSlots,
      squeezeBuffer: squeezeBuffer,
    );

    if (freeSlots.isEmpty) return [];

    final scores = <TimeSlotScore>[];

    final requiredDuration = squeezeBuffer
        ? goal.targetDuration
        : goal.targetDuration + RuleBasedScheduler.minTaskGapMinutes;

    for (final slot in freeSlots) {
      if (slot.canFit(requiredDuration)) {
        final score = await scoreTimeSlot(goal: goal, slot: slot, date: date);
        scores.add(score);
      }
    }

    // Sort by score descending
    scores.sort((a, b) => b.score.compareTo(a.score));
    return scores;
  }

  /// Find the best time slot for a goal using profile-based scoring
  Future<TimeSlotScore?> findBestSlotForGoal({
    required Goal goal,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
  }) async {
    final scores = await scoreAllSlots(
      goal: goal,
      date: date,
      availableSlots: availableSlots,
      usedSlots: usedSlots,
    );

    if (scores.isEmpty) return null;
    return scores.first;
  }

  /// Get slots that haven't been used yet
  List<TimeSlot> _getFreeSlots(
    List<TimeSlot> availableSlots,
    List<TimeSlot> usedSlots, {
    bool squeezeBuffer = false,
  }) {
    if (usedSlots.isEmpty) return availableSlots;

    final freeSlots = <TimeSlot>[];
    final gapMinutes = squeezeBuffer ? 0 : RuleBasedScheduler.minTaskGapMinutes;

    for (final slot in availableSlots) {
      var slotStart = slot.start;
      final slotEnd = slot.end;

      for (final used in usedSlots) {
        // If used slot overlaps with our slot
        if (used.start.isBefore(slotEnd) && used.end.isAfter(slotStart)) {
          // If there's usable time before the used slot
          if (slotStart.isBefore(used.start)) {
            final gapEnd = used.start.subtract(Duration(minutes: gapMinutes));
            if (gapEnd.isAfter(slotStart)) {
              freeSlots.add(TimeSlot(slotStart, gapEnd));
            }
          }
          // Move start past the used slot
          slotStart = used.end.add(Duration(minutes: gapMinutes));
        }
      }

      // Add remaining time if any
      if (slotStart.isBefore(slotEnd)) {
        freeSlots.add(TimeSlot(slotStart, slotEnd));
      }
    }

    return freeSlots;
  }

  /// Get profile-based scheduling recommendations
  Future<Map<String, dynamic>> getSchedulingRecommendations(
    Goal goal,
    DateTime date,
  ) async {
    final profile = await _getProfile();
    final category = goal.category;
    final chronoWindows = profile.getChronoTypeWindows();

    return {
      'category': category.displayName,
      'category_optimal_hours': category.optimalHours,
      'category_best_hour': category.bestHour,
      'chrono_type': profile.chronoType.name,
      'chrono_high_priority_window': chronoWindows['high'],
      'chrono_medium_priority_window': chronoWindows['medium'],
      'active_hours': profile.getActiveHours(),
      'has_work_schedule': profile.hasWorkSchedule,
      'work_hours': profile.hasWorkSchedule
          ? (profile.workStartHour, profile.workEndHour)
          : null,
      'preferred_duration': profile.getPreferredDurationMinutes(),
    };
  }
}

/// Result of scoring a time slot
class TimeSlotScore {
  final TimeSlot slot;
  final double score;
  final Map<String, double> factors;
  final String method;

  TimeSlotScore({
    required this.slot,
    required this.score,
    required this.factors,
    required this.method,
  });

  @override
  String toString() =>
      'TimeSlotScore(${slot.start.hour}:00, score=${score.toStringAsFixed(2)}, $method)';
}
