import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../data/models/goal.dart';
import '../../data/models/goal_category.dart';
import '../../data/models/one_time_task.dart';
import '../../data/models/scheduled_task.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/one_time_task_repository.dart';
import '../../data/repositories/scheduled_task_repository.dart';
import '../../data/repositories/habit_metrics_repository.dart';
import '../../data/repositories/user_profile_repository.dart';
import 'rule_based_scheduler.dart';
import 'ml_predictor.dart';
import 'profile_based_scheduler.dart';
import 'dynamic_time_window_service.dart';
import 'habit_formation_service.dart';

/// Three-tier hybrid scheduler with habit formation overlay
/// Smart v2: Uses "Score & Pick" architecture
/// 1. Get all valid time slots
/// 2. Score them (Profile + ML Boost)
/// 3. Pick the winner
/// 4. Apply "Buffer Squeeze" if needed
class HybridScheduler {
  final Isar isar;
  final GoalRepository goalRepository;
  final OneTimeTaskRepository oneTimeTaskRepository;
  final ScheduledTaskRepository scheduledTaskRepository;
  final RuleBasedScheduler ruleBasedScheduler;
  final MLPredictor mlPredictor;

  // New for v2
  final ProfileBasedScheduler? profileBasedScheduler;
  final DynamicTimeWindowService? dynamicTimeWindowService;
  final HabitMetricsRepository? habitMetricsRepository;
  final UserProfileRepository? userProfileRepository;
  final HabitFormationService? habitFormationService;

  // Confidence threshold for using ML predictions
  static const double minMLConfidence = 0.6;

  // Streak thresholds for habit protection
  static const int streakProtectionThreshold = 14; // Protect streaks 14+ days
  static const int habitLockThreshold = 21; // Lock in time after 21 days
  static const double highConsistencyThreshold = 0.7; // 70% consistency

  HybridScheduler({
    required this.isar,
    required this.goalRepository,
    required this.oneTimeTaskRepository,
    required this.scheduledTaskRepository,
    required this.ruleBasedScheduler,
    required this.mlPredictor,
    this.profileBasedScheduler,
    this.dynamicTimeWindowService,
    this.habitMetricsRepository,
    this.userProfileRepository,
    this.habitFormationService,
  });

  /// Check if profile-based scheduling is available
  Future<bool> _isProfileAvailable() async {
    if (profileBasedScheduler == null || userProfileRepository == null) {
      return false;
    }
    final profile = await userProfileRepository!.getProfile();
    return profile?.onboardingCompleted ?? false;
  }

  /// Main scheduling method - intelligently uses ML or rules
  Future<List<ScheduledTask>> scheduleForDate(DateTime date) async {
    debugPrint('scheduleForDate: Starting for date: $date');

    // Get goals for this date
    final goals = await _getActiveGoalsForDate(date);
    debugPrint('scheduleForDate: Got ${goals.length} goals');

    if (goals.isEmpty) {
      debugPrint('scheduleForDate: No goals, returning empty list');
      return [];
    }

    // Get blockers
    final blockers = await _getBlockersForDate(date);
    debugPrint('scheduleForDate: Got ${blockers.length} blockers');

    // Calculate available slots using dynamic wake/sleep times
    List<TimeSlot> availableSlots;
    if (dynamicTimeWindowService != null) {
      debugPrint('scheduleForDate: Using dynamicTimeWindowService');
      final window = await dynamicTimeWindowService!.getTimeWindowForDate(date);
      debugPrint(
        'scheduleForDate: Window: wake=${window.wakeHour}, sleep=${window.sleepHour}',
      );

      // Subtract blockers from this window using RuleBasedScheduler
      availableSlots = ruleBasedScheduler.calculateAvailableSlots(
        date,
        blockers,
        startHour: window.wakeHour,
        endHour: window.sleepHour,
      );
    } else {
      debugPrint('scheduleForDate: Using ruleBasedScheduler fallback');
      // Fallback to rule-based default
      availableSlots = await ruleBasedScheduler.calculateAvailableSlotsAsync(
        date,
        blockers,
      );
    }

    debugPrint('scheduleForDate: ${availableSlots.length} available slots');
    for (int i = 0; i < availableSlots.length; i++) {
      debugPrint(
        '  Slot $i: ${availableSlots[i].start} - ${availableSlots[i].end}',
      );
    }

    // Schedule each goal using hybrid approach
    final scheduledTasks = <ScheduledTask>[];
    final usedSlots = <TimeSlot>[];

    for (final goal in goals) {
      debugPrint(
        'scheduleForDate: Scheduling goal "${goal.title}" (duration=${goal.targetDuration}min)',
      );
      // Use Smart Scheduling (Score & Pick)
      final task = await _scheduleGoalSmart(
        goal: goal,
        date: date,
        availableSlots: availableSlots,
        usedSlots: usedSlots,
      );

      if (task != null) {
        debugPrint(
          'scheduleForDate: Task created at ${task.scheduledStartTime}',
        );
        scheduledTasks.add(task);
        // Track that this goal was scheduled for analytics
        if (habitFormationService != null) {
          await habitFormationService!.markGoalScheduled(goal.id);
        }
        // Store EXACT duration in usedSlots (no buffer baked in)
        // This allows the next task to decide whether to squeeze or not
        usedSlots.add(
          TimeSlot(
            task.scheduledStartTime,
            task.scheduledStartTime.add(Duration(minutes: task.duration)),
          ),
        );
      } else {
        debugPrint('scheduleForDate: FAILED to schedule goal "${goal.title}"');
      }
    }

    debugPrint(
      'scheduleForDate: Complete! ${scheduledTasks.length} tasks scheduled',
    );
    return scheduledTasks;
  }

  /// Schedule a goal using "Score & Pick" logic
  /// 1. Score all slots (Profile + ML)
  /// 2. Pick best
  /// 3. If no fit, try Buffer Squeeze
  Future<ScheduledTask?> _scheduleGoalSmart({
    required Goal goal,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
  }) async {
    // 0. Check habit formation overlay first (Locked times)
    final habitTask = await _tryHabitLockedScheduling(
      goal: goal,
      date: date,
      availableSlots: availableSlots,
      usedSlots: usedSlots,
    );
    if (habitTask != null) {
      return habitTask;
    }

    // 1. Get Scores from ProfileBasedScheduler (The Base Truth)
    List<TimeSlotScore> scores = [];
    if (await _isProfileAvailable()) {
      scores = await profileBasedScheduler!.scoreAllSlots(
        goal: goal,
        date: date,
        availableSlots: availableSlots,
        usedSlots: usedSlots,
      );
    }

    // 2. Apply ML Boosts (The "Smart" Layer)
    final hasMLData = await mlPredictor.hasEnoughData(goal.id);
    if (hasMLData) {
      scores = await _applyMLBoosts(scores, goal, date);
    }

    // 3. Pick the Winner
    if (scores.isNotEmpty) {
      // Sort by score descending
      scores.sort((a, b) => b.score.compareTo(a.score));
      final best = scores.first;

      // Generate reason based on factors used
      final reason = _generateSchedulingReason(
        goal: goal,
        method: hasMLData ? 'ml-boosted' : 'profile-based',
        slot: best.slot,
        factors: best.factors,
      );

      return _createScheduledTask(
        goal: goal,
        date: date,
        slot: best.slot,
        method: 'smart-v2', // Combined Profile + ML
        mlConfidence: hasMLData ? 0.8 : null, // Placeholder confidence
        schedulingReason: reason,
      );
    }

    // 4. Buffer Squeeze (The "Fix" for the 15m gap issue)
    // If we couldn't fit it normally, try squeezing the buffer
    if (await _isProfileAvailable()) {
      final squeezedScores = await profileBasedScheduler!.scoreAllSlots(
        goal: goal,
        date: date,
        availableSlots: availableSlots,
        usedSlots: usedSlots,
        squeezeBuffer: true, // Enable squeeze
      );

      if (squeezedScores.isNotEmpty) {
        squeezedScores.sort((a, b) => b.score.compareTo(a.score));
        final best = squeezedScores.first;

        return _createScheduledTask(
          goal: goal,
          date: date,
          slot: best.slot,
          method: 'smart-v2-squeezed',
          mlConfidence: null,
          schedulingReason:
              'Scheduled at an optimal time based on your profile, fitting around your other tasks.',
        );
      }
    }

    // 5. Fallback to Rule-Based (Legacy)
    // Only if profile wasn't available or somehow failed completely
    if (scores.isEmpty) {
      return _scheduleWithRules(
        goal: goal,
        date: date,
        availableSlots: availableSlots,
        usedSlots: usedSlots,
      );
    }

    return null;
  }

  /// Apply ML predictions to boost scores of existing slots
  Future<List<TimeSlotScore>> _applyMLBoosts(
    List<TimeSlotScore> scores,
    Goal goal,
    DateTime date,
  ) async {
    final dayOfWeek = date.weekday - 1;
    final boostedScores = <TimeSlotScore>[];

    for (final scoreItem in scores) {
      final prediction = await mlPredictor.predictProductivity(
        goalId: goal.id,
        hourOfDay: scoreItem.slot.start.hour,
        dayOfWeek: dayOfWeek,
        duration: goal.targetDuration,
      );

      double newScore = scoreItem.score;
      final newFactors = Map<String, double>.from(scoreItem.factors);

      if (prediction != null && prediction.confidence >= minMLConfidence) {
        // Boost score based on ML prediction (up to +0.3)
        final boost = (prediction.score * 0.3) * prediction.confidence;
        newScore += boost;
        newFactors['ml_boost'] = boost;
      }

      boostedScores.add(
        TimeSlotScore(
          slot: scoreItem.slot,
          score: newScore,
          factors: newFactors,
          method: scoreItem.method,
        ),
      );
    }

    return boostedScores;
  }

  /// Try to schedule using habit-locked time (for established habits)
  Future<ScheduledTask?> _tryHabitLockedScheduling({
    required Goal goal,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
  }) async {
    if (habitMetricsRepository == null) return null;

    final metrics = await habitMetricsRepository!.getMetricsForGoal(goal.id);
    if (metrics == null) return null;

    // Check if this goal qualifies for habit locking
    final hasEstablishedHabit =
        metrics.currentStreak >= habitLockThreshold &&
        metrics.timeConsistency >= highConsistencyThreshold &&
        metrics.stickyHour != null;

    if (!hasEstablishedHabit) return null;

    // Try to schedule at the sticky hour
    final stickyHour = metrics.stickyHour!;
    final freeSlots = ruleBasedScheduler.getFreeSlots(
      availableSlots,
      usedSlots,
    );
    final requiredMinutes =
        goal.targetDuration + RuleBasedScheduler.minTaskGapMinutes;

    // Helper to check if a slot contains a target hour and create a slot starting at that hour
    TimeSlot? findSlotAtHour(List<TimeSlot> slots, int targetHour) {
      for (final slot in slots) {
        // Check if the target hour falls within this slot
        final targetTime = DateTime(
          date.year,
          date.month,
          date.day,
          targetHour,
          0,
        );
        final targetEnd = targetTime.add(Duration(minutes: requiredMinutes));

        if (!targetTime.isBefore(slot.start) && !targetEnd.isAfter(slot.end)) {
          // Target hour is within this slot and there's enough time
          return TimeSlot(targetTime, slot.end);
        }
      }
      return null;
    }

    // First try exact sticky hour
    final stickySlot = findSlotAtHour(freeSlots, stickyHour);
    if (stickySlot != null) {
      return _createScheduledTask(
        goal: goal,
        date: date,
        slot: stickySlot,
        method: 'habit-locked',
        mlConfidence: null,
        schedulingReason:
            'This is your usual time for "${goal.title}" based on your ${metrics.currentStreak}-day streak.',
      );
    }

    // Sticky hour not available, try adjacent hours
    for (final offset in [1, -1, 2, -2]) {
      final tryHour = stickyHour + offset;
      if (tryHour < 0 || tryHour > 23) continue;

      final adjacentSlot = findSlotAtHour(freeSlots, tryHour);
      if (adjacentSlot != null) {
        return _createScheduledTask(
          goal: goal,
          date: date,
          slot: adjacentSlot,
          method: 'habit-locked',
          mlConfidence: null,
          schedulingReason:
              'Your usual time was busy, so scheduled close to your ${metrics.currentStreak}-day habit time.',
        );
      }
    }

    return null;
  }

  /// Schedule using rule-based approach
  ScheduledTask? _scheduleWithRules({
    required Goal goal,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
  }) {
    final bestSlot = ruleBasedScheduler.findBestSlotForGoal(
      goal: goal,
      availableSlots: availableSlots,
      usedSlots: usedSlots,
    );

    if (bestSlot == null) return null;

    return _createScheduledTask(
      goal: goal,
      date: date,
      slot: bestSlot,
      method: 'rule-based',
      mlConfidence: null,
      schedulingReason:
          'Scheduled at an available time based on your priority and frequency settings.',
    );
  }

  /// Create a scheduled task with common properties
  ScheduledTask _createScheduledTask({
    required Goal goal,
    required DateTime date,
    required TimeSlot slot,
    required String method,
    required double? mlConfidence,
    String? schedulingReason,
  }) {
    return ScheduledTask()
      ..goalId = goal.id
      ..title = goal.title
      ..scheduledDate = DateTime(date.year, date.month, date.day)
      ..scheduledStartTime = slot.start
      ..originalScheduledTime = slot.start
      ..duration = goal.targetDuration
      ..colorHex = goal.colorHex
      ..iconName = goal.iconName
      ..schedulingMethod = method
      ..mlConfidence = mlConfidence
      ..isCompleted = false
      ..wasRescheduled = false
      ..rescheduleCount = 0
      ..isAutoGenerated = true
      ..createdAt = DateTime.now()
      ..schedulingReason = schedulingReason;
  }

  /// Generate a human-readable scheduling reason based on the method and factors
  String _generateSchedulingReason({
    required Goal goal,
    required String method,
    required TimeSlot slot,
    Map<String, double>? factors,
  }) {
    final hour = slot.start.hour;
    final period = hour >= 12 ? 'afternoon/evening' : 'morning';
    final categoryName = goal.category.displayName.toLowerCase();

    switch (method) {
      case 'ml-boosted':
        return 'Based on your patterns, you\'re most productive with $categoryName tasks in the $period.';
      case 'profile-based':
        // Check which factor contributed most
        if (factors != null) {
          final chronoScore = factors['chronotype'] ?? 0;
          final categoryScore = factors['category'] ?? 0;

          if (chronoScore > categoryScore) {
            return 'Scheduled based on your energy levels - this is a high-focus time for you.';
          } else {
            return 'This is an optimal time for $categoryName activities based on research.';
          }
        }
        return 'Scheduled based on your profile and optimal times for $categoryName.';
      default:
        return 'Scheduled at an available time based on your settings.';
    }
  }

  /// Get active goals for a date
  /// Only includes goals that were created on or before the date
  Future<List<Goal>> _getActiveGoalsForDate(DateTime date) async {
    final allGoals = await goalRepository.getAllGoals();
    final dateOnly = DateTime(date.year, date.month, date.day);
    final dayOfWeek = date.weekday - 1; // 0=Monday, 6=Sunday

    debugPrint('_getActiveGoalsForDate: date=$date, dayOfWeek=$dayOfWeek');
    debugPrint('_getActiveGoalsForDate: Found ${allGoals.length} total goals');

    final goalsForDate = allGoals.where((goal) {
      debugPrint(
        '_getActiveGoalsForDate: Checking goal "${goal.title}" (id=${goal.id})',
      );
      debugPrint('  - isActive: ${goal.isActive}');
      debugPrint('  - frequency: ${goal.frequency}');
      debugPrint('  - createdAt: ${goal.createdAt}');

      // Only schedule active goals
      if (!goal.isActive) {
        debugPrint('  - EXCLUDED: not active');
        return false;
      }

      if (goal.frequency.isEmpty) {
        debugPrint('  - EXCLUDED: frequency is empty');
        return false;
      }

      // Don't schedule goals created after this date
      final goalCreatedDate = DateTime(
        goal.createdAt.year,
        goal.createdAt.month,
        goal.createdAt.day,
      );
      if (goalCreatedDate.isAfter(dateOnly)) {
        debugPrint(
          '  - EXCLUDED: created after this date (created: $goalCreatedDate, scheduling for: $dateOnly)',
        );
        return false;
      }

      final containsDay = goal.frequency.contains(dayOfWeek);
      debugPrint('  - frequency.contains($dayOfWeek): $containsDay');
      if (!containsDay) {
        debugPrint('  - EXCLUDED: day $dayOfWeek not in frequency');
      } else {
        debugPrint('  - INCLUDED: goal will be scheduled');
      }
      return containsDay;
    }).toList();

    debugPrint(
      '_getActiveGoalsForDate: ${goalsForDate.length} goals passed filter',
    );
    goalsForDate.sort((a, b) => a.priorityIndex.compareTo(b.priorityIndex));
    return goalsForDate;
  }

  /// Get blockers for a date
  Future<List<OneTimeTask>> _getBlockersForDate(DateTime date) async {
    return await oneTimeTaskRepository.getOneTimeTasksForDate(date);
  }

  /// Schedule a single goal for a date (incremental update)
  /// Used when a new goal is added - finds an empty slot without touching existing tasks
  Future<ScheduledTask?> scheduleGoalForDate(
    Goal goal,
    DateTime date,
    List<ScheduledTask> existingTasks,
  ) async {
    // Get blockers (one-time tasks)
    final blockers = await _getBlockersForDate(date);

    // Calculate available slots, treating existing tasks as blockers too
    // Use dynamic window if available
    List<TimeSlot> availableSlots;
    if (dynamicTimeWindowService != null) {
      final window = await dynamicTimeWindowService!.getTimeWindowForDate(date);

      availableSlots = ruleBasedScheduler.calculateAvailableSlots(
        date,
        blockers,
        startHour: window.wakeHour,
        endHour: window.sleepHour,
      );
    } else {
      availableSlots = await ruleBasedScheduler.calculateAvailableSlotsAsync(
        date,
        blockers,
      );
    }

    // Convert existing tasks to used slots
    final usedSlots = <TimeSlot>[];
    for (final task in existingTasks) {
      final startTime = task.scheduledStartTime;
      final endTime = startTime.add(Duration(minutes: task.duration));
      usedSlots.add(TimeSlot(startTime, endTime));
    }

    // Schedule the goal
    final task = await _scheduleGoalSmart(
      goal: goal,
      date: date,
      availableSlots: availableSlots,
      usedSlots: usedSlots,
    );

    return task;
  }

  /// Regenerate schedule for a date (preserves rescheduled tasks)
  Future<List<ScheduledTask>> regenerateScheduleForDate(DateTime date) async {
    // Delete existing auto-generated tasks (but NOT rescheduled ones!)
    await scheduledTaskRepository.deleteAutoGeneratedTasksForDate(date);

    // Get rescheduled tasks to treat as blockers
    final rescheduledTasks = await scheduledTaskRepository
        .getRescheduledTasksForDate(date);

    // Generate new schedule
    final newTasks = await scheduleForDate(date);

    // Filter out goals that already have rescheduled tasks
    final rescheduledGoalIds = rescheduledTasks.map((t) => t.goalId).toSet();
    final tasksToSave = newTasks
        .where((t) => !rescheduledGoalIds.contains(t.goalId))
        .toList();

    // Save to database
    for (final task in tasksToSave) {
      await scheduledTaskRepository.createScheduledTask(
        task,
        allowDuplicates: false,
      );
    }

    return [...rescheduledTasks, ...tasksToSave];
  }

  /// Get scheduling statistics with three-tier insights
  Future<Map<String, dynamic>> getSchedulingStats(DateTime date) async {
    final goals = await _getActiveGoalsForDate(date);

    // Count how many goals have ML data
    int goalsWithMLData = 0;
    int goalsWithEstablishedHabits = 0;

    for (final goal in goals) {
      if (await mlPredictor.hasEnoughData(goal.id)) {
        goalsWithMLData++;
      }

      if (habitMetricsRepository != null) {
        final metrics = await habitMetricsRepository!.getMetricsForGoal(
          goal.id,
        );
        if (metrics != null &&
            metrics.currentStreak >= habitLockThreshold &&
            metrics.timeConsistency >= highConsistencyThreshold) {
          goalsWithEstablishedHabits++;
        }
      }
    }

    final baseStats = await ruleBasedScheduler.getSchedulingStats(date);
    final profileAvailable = await _isProfileAvailable();

    // Get dynamic window info if available
    Map<String, dynamic>? dynamicWindowInfo;
    if (dynamicTimeWindowService != null) {
      final window = await dynamicTimeWindowService!.getTimeWindowForDate(date);
      dynamicWindowInfo = {
        'wake_hour': window.wakeHour,
        'sleep_hour': window.sleepHour,
        'optimal_start': window.optimalStartHour,
        'optimal_end': window.optimalEndHour,
        'is_learned': window.isLearned,
      };
    }

    return {
      ...baseStats,
      'scheduler_version': 'v2-smart-score-pick',
      'ml_predictor': mlPredictor.predictorName,
      'goals_with_ml_data': goalsWithMLData,
      'ml_coverage_percent': goals.isEmpty
          ? 0
          : (goalsWithMLData / goals.length * 100).round(),
      'profile_available': profileAvailable,
      'goals_with_established_habits': goalsWithEstablishedHabits,
      'habit_lock_threshold_days': habitLockThreshold,
      'streak_protection_threshold_days': streakProtectionThreshold,
      'dynamic_window': dynamicWindowInfo,
    };
  }
}
