import 'package:isar/isar.dart';
import '../../data/models/goal.dart';
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

/// Three-tier hybrid scheduler with habit formation overlay
/// Tier 1: ML-based (if ≥10 data points, ≥60% confidence)
/// Tier 2: Profile-based (if onboarding completed)
/// Tier 3: Rule-based (fallback)
/// Overlay: Habit formation (sticky times, streak protection)
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
    // Get goals for this date
    final goals = await _getActiveGoalsForDate(date);

    if (goals.isEmpty) {
      return [];
    }

    // Get blockers
    final blockers = await _getBlockersForDate(date);

    // Calculate available slots using dynamic wake/sleep times
    final availableSlots = await ruleBasedScheduler
        .calculateAvailableSlotsAsync(date, blockers);

    // Schedule each goal using hybrid approach
    final scheduledTasks = <ScheduledTask>[];
    final usedSlots = <TimeSlot>[];

    for (final goal in goals) {
      // Try ML-based scheduling first
      final task = await _scheduleGoalHybrid(
        goal: goal,
        date: date,
        availableSlots: availableSlots,
        usedSlots: usedSlots,
      );

      if (task != null) {
        scheduledTasks.add(task);
        ruleBasedScheduler.markSlotAsUsed(task, usedSlots);
      }
    }

    return scheduledTasks;
  }

  /// Schedule a goal using three-tier hybrid approach with habit overlay
  /// Tier 1: ML-based (if ≥10 data, ≥60% confidence)
  /// Tier 2: Profile-based (if onboarding completed)
  /// Tier 3: Rule-based (fallback)
  /// Overlay: Habit formation (sticky times for consistent goals)
  Future<ScheduledTask?> _scheduleGoalHybrid({
    required Goal goal,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
  }) async {
    // Check habit formation overlay first (21+ day streaks get locked times)
    final habitTask = await _tryHabitLockedScheduling(
      goal: goal,
      date: date,
      availableSlots: availableSlots,
      usedSlots: usedSlots,
    );
    if (habitTask != null) {
      return habitTask;
    }

    // Tier 1: Try ML-based scheduling
    final hasMLData = await mlPredictor.hasEnoughData(goal.id);
    if (hasMLData) {
      final mlTask = await _scheduleWithML(
        goal: goal,
        date: date,
        availableSlots: availableSlots,
        usedSlots: usedSlots,
      );
      if (mlTask != null) {
        return mlTask;
      }
    }

    // Tier 2: Try Profile-based scheduling
    if (await _isProfileAvailable()) {
      final profileTask = await _scheduleWithProfile(
        goal: goal,
        date: date,
        availableSlots: availableSlots,
        usedSlots: usedSlots,
      );
      if (profileTask != null) {
        return profileTask;
      }
    }

    // Tier 3: Fall back to rule-based scheduling
    return _scheduleWithRules(
      goal: goal,
      date: date,
      availableSlots: availableSlots,
      usedSlots: usedSlots,
    );
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
        );
      }
    }

    return null;
  }

  /// Schedule using profile-based scoring
  Future<ScheduledTask?> _scheduleWithProfile({
    required Goal goal,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
  }) async {
    if (profileBasedScheduler == null) return null;

    final result = await profileBasedScheduler!.findBestSlotForGoal(
      goal: goal,
      date: date,
      availableSlots: availableSlots,
      usedSlots: usedSlots,
    );

    if (result == null) return null;

    // Apply habit protection for at-risk streaks
    final adjustedSlot = await _applyStreakProtection(
      goal: goal,
      slot: result.slot,
      date: date,
      availableSlots: availableSlots,
      usedSlots: usedSlots,
    );

    return _createScheduledTask(
      goal: goal,
      date: date,
      slot: adjustedSlot ?? result.slot,
      method: 'profile-based',
      mlConfidence: null,
    );
  }

  /// Apply streak protection - prefer times that historically worked
  Future<TimeSlot?> _applyStreakProtection({
    required Goal goal,
    required TimeSlot slot,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
  }) async {
    if (habitMetricsRepository == null) return null;

    final metrics = await habitMetricsRepository!.getMetricsForGoal(goal.id);
    if (metrics == null) return null;

    // Only apply protection for significant streaks
    if (metrics.currentStreak < streakProtectionThreshold) return null;

    // If we have a sticky hour that works, prefer it
    if (metrics.stickyHour != null) {
      final freeSlots = ruleBasedScheduler.getFreeSlots(
        availableSlots,
        usedSlots,
      );
      final stickyHour = metrics.stickyHour!;
      final requiredMinutes =
          goal.targetDuration + RuleBasedScheduler.minTaskGapMinutes;

      for (final freeSlot in freeSlots) {
        // Check if the sticky hour falls within this slot
        final targetTime = DateTime(
          date.year,
          date.month,
          date.day,
          stickyHour,
          0,
        );
        final targetEnd = targetTime.add(Duration(minutes: requiredMinutes));

        if (!targetTime.isBefore(freeSlot.start) &&
            !targetEnd.isAfter(freeSlot.end)) {
          return TimeSlot(targetTime, freeSlot.end);
        }
      }
    }

    return null;
  }

  /// Schedule using ML predictions
  Future<ScheduledTask?> _scheduleWithML({
    required Goal goal,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
  }) async {
    final dayOfWeek = date.weekday - 1; // 0=Monday
    final freeSlots = ruleBasedScheduler.getFreeSlots(
      availableSlots,
      usedSlots,
    );

    // Try to find best slot using ML predictions
    MLPrediction? bestPrediction;
    TimeSlot? bestSlot;
    double bestScore = 0.0;

    for (final slot in freeSlots) {
      if (slot.canFit(
        goal.targetDuration + RuleBasedScheduler.minTaskGapMinutes,
      )) {
        final prediction = await mlPredictor.predictProductivity(
          goalId: goal.id,
          hourOfDay: slot.start.hour,
          dayOfWeek: dayOfWeek,
          duration: goal.targetDuration,
        );

        if (prediction != null &&
            prediction.confidence >= minMLConfidence &&
            prediction.score > bestScore) {
          bestScore = prediction.score;
          bestPrediction = prediction;
          bestSlot = slot;
        }
      }
    }

    if (bestSlot == null || bestPrediction == null) {
      return null;
    }

    // Create scheduled task with ML metadata
    return _createScheduledTask(
      goal: goal,
      date: date,
      slot: bestSlot,
      method: 'ml-based',
      mlConfidence: bestPrediction.confidence,
    );
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
    );
  }

  /// Create a scheduled task with common properties
  ScheduledTask _createScheduledTask({
    required Goal goal,
    required DateTime date,
    required TimeSlot slot,
    required String method,
    required double? mlConfidence,
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
      ..createdAt = DateTime.now();
  }

  /// Get active goals for a date
  /// Only includes goals that were created on or before the date
  Future<List<Goal>> _getActiveGoalsForDate(DateTime date) async {
    final allGoals = await goalRepository.getAllGoals();
    final dateOnly = DateTime(date.year, date.month, date.day);

    final goalsForDate = allGoals.where((goal) {
      // Only schedule active goals
      if (!goal.isActive) return false;
      
      if (goal.frequency.isEmpty) return false;

      // Don't schedule goals created after this date
      final goalCreatedDate = DateTime(
        goal.createdAt.year,
        goal.createdAt.month,
        goal.createdAt.day,
      );
      if (goalCreatedDate.isAfter(dateOnly)) return false;

      final dayOfWeek = date.weekday - 1;
      return goal.frequency.contains(dayOfWeek);
    }).toList();

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
    final availableSlots = await ruleBasedScheduler
        .calculateAvailableSlotsAsync(date, blockers);

    // Convert existing tasks to used slots
    final usedSlots = <TimeSlot>[];
    for (final task in existingTasks) {
      final startTime = task.scheduledStartTime;
      final endTime = startTime.add(Duration(minutes: task.duration));
      usedSlots.add(TimeSlot(startTime, endTime));
    }

    // Schedule the goal
    final task = await _scheduleGoalHybrid(
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
      await scheduledTaskRepository.createScheduledTask(task, allowDuplicates: false);
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
      'scheduler_version': 'v2-three-tier',
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
