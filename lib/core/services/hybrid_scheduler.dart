import 'package:isar/isar.dart';
import '../../data/models/goal.dart';
import '../../data/models/one_time_task.dart';
import '../../data/models/scheduled_task.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/one_time_task_repository.dart';
import '../../data/repositories/scheduled_task_repository.dart';
import 'rule_based_scheduler.dart';
import 'ml_predictor.dart';

/// Hybrid scheduler that combines rule-based and ML-based scheduling
/// Uses ML predictions when available, falls back to rules otherwise
class HybridScheduler {
  final Isar isar;
  final GoalRepository goalRepository;
  final OneTimeTaskRepository oneTimeTaskRepository;
  final ScheduledTaskRepository scheduledTaskRepository;
  final RuleBasedScheduler ruleBasedScheduler;
  final MLPredictor mlPredictor;

  // Confidence threshold for using ML predictions
  static const double minMLConfidence = 0.6;

  HybridScheduler({
    required this.isar,
    required this.goalRepository,
    required this.oneTimeTaskRepository,
    required this.scheduledTaskRepository,
    required this.ruleBasedScheduler,
    required this.mlPredictor,
  });

  /// Main scheduling method - intelligently uses ML or rules
  Future<List<ScheduledTask>> scheduleForDate(DateTime date) async {
    print(
      '\n🧠 Hybrid Scheduler: Generating schedule for ${date.toIso8601String().split('T')[0]}',
    );
    print('   Using: ${mlPredictor.predictorName}');

    // Get goals for this date
    final goals = await _getActiveGoalsForDate(date);
    print('   📋 Found ${goals.length} goals');

    if (goals.isEmpty) {
      print('   ✅ No goals to schedule');
      return [];
    }

    // Get blockers
    final blockers = await _getBlockersForDate(date);
    print('   🚫 Found ${blockers.length} blockers');

    // Calculate available slots
    final availableSlots = ruleBasedScheduler.calculateAvailableSlots(
      date,
      blockers,
    );
    print('   ⏰ Available slots: ${availableSlots.length}');

    // Schedule each goal using hybrid approach
    final scheduledTasks = <ScheduledTask>[];
    final usedSlots = <TimeSlot>[];

    for (final goal in goals) {
      print('\n   🎯 Scheduling: ${goal.title}');

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
        print(
          '      ✅ Scheduled at ${task.scheduledStartTime.hour}:${task.scheduledStartTime.minute.toString().padLeft(2, '0')} (${task.schedulingMethod})',
        );
      } else {
        print('      ❌ Could not fit in schedule');
      }
    }

    print(
      '\n   ✨ Successfully scheduled ${scheduledTasks.length}/${goals.length} goals',
    );
    print(
      '   📊 ML: ${scheduledTasks.where((t) => t.schedulingMethod == 'ml-based').length}, Rules: ${scheduledTasks.where((t) => t.schedulingMethod == 'rule-based').length}\n',
    );

    return scheduledTasks;
  }

  /// Schedule a goal using hybrid approach (ML + rules)
  Future<ScheduledTask?> _scheduleGoalHybrid({
    required Goal goal,
    required DateTime date,
    required List<TimeSlot> availableSlots,
    required List<TimeSlot> usedSlots,
  }) async {
    // Check if ML has enough data for this goal
    final hasMLData = await mlPredictor.hasEnoughData(goal.id);

    if (hasMLData) {
      print('      🧠 Trying ML-based scheduling...');
      final mlTask = await _scheduleWithML(
        goal: goal,
        date: date,
        availableSlots: availableSlots,
        usedSlots: usedSlots,
      );

      if (mlTask != null) {
        return mlTask;
      }
      print('      ⚠️  ML failed, falling back to rules');
    } else {
      print(
        '      📊 Insufficient data (need ${mlPredictor.minDataPoints}+), using rules',
      );
    }

    // Fall back to rule-based scheduling
    return _scheduleWithRules(
      goal: goal,
      date: date,
      availableSlots: availableSlots,
      usedSlots: usedSlots,
    );
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

    print(
      '      📈 ML Prediction: score=${bestPrediction.score.toStringAsFixed(2)}, confidence=${bestPrediction.confidence.toStringAsFixed(2)}',
    );

    // Create scheduled task with ML metadata
    return ScheduledTask()
      ..goalId = goal.id
      ..title = goal.title
      ..scheduledDate = DateTime(date.year, date.month, date.day)
      ..scheduledStartTime = bestSlot.start
      ..originalScheduledTime = bestSlot.start
      ..duration = goal.targetDuration
      ..colorHex = goal.colorHex
      ..iconName = goal.iconName
      ..schedulingMethod = 'ml-based'
      ..mlConfidence = bestPrediction.confidence
      ..isCompleted = false
      ..wasRescheduled = false
      ..rescheduleCount = 0
      ..isAutoGenerated = true
      ..createdAt = DateTime.now();
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

    return ScheduledTask()
      ..goalId = goal.id
      ..title = goal.title
      ..scheduledDate = DateTime(date.year, date.month, date.day)
      ..scheduledStartTime = bestSlot.start
      ..originalScheduledTime = bestSlot.start
      ..duration = goal.targetDuration
      ..colorHex = goal.colorHex
      ..iconName = goal.iconName
      ..schedulingMethod = 'rule-based'
      ..mlConfidence = null
      ..isCompleted = false
      ..wasRescheduled = false
      ..rescheduleCount = 0
      ..isAutoGenerated = true
      ..createdAt = DateTime.now();
  }

  /// Get active goals for a date
  Future<List<Goal>> _getActiveGoalsForDate(DateTime date) async {
    final allGoals = await goalRepository.getAllGoals();

    final goalsForDate = allGoals.where((goal) {
      if (goal.frequency.isEmpty) return false;
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

  /// Regenerate schedule for a date
  Future<List<ScheduledTask>> regenerateScheduleForDate(DateTime date) async {
    print('🔄 Regenerating schedule (Hybrid)...');

    // Delete existing auto-generated tasks
    final deleted = await scheduledTaskRepository
        .deleteAutoGeneratedTasksForDate(date);
    print('   🗑️  Deleted $deleted auto-generated tasks');

    // Generate new schedule
    final newTasks = await scheduleForDate(date);

    // Save to database
    for (final task in newTasks) {
      await scheduledTaskRepository.createScheduledTask(task);
    }

    print('   ✅ Regeneration complete: ${newTasks.length} tasks created\n');
    return newTasks;
  }

  /// Get scheduling statistics with ML insights
  Future<Map<String, dynamic>> getSchedulingStats(DateTime date) async {
    final goals = await _getActiveGoalsForDate(date);

    // Count how many goals have ML data
    int goalsWithMLData = 0;
    for (final goal in goals) {
      if (await mlPredictor.hasEnoughData(goal.id)) {
        goalsWithMLData++;
      }
    }

    final baseStats = await ruleBasedScheduler.getSchedulingStats(date);

    return {
      ...baseStats,
      'ml_predictor': mlPredictor.predictorName,
      'goals_with_ml_data': goalsWithMLData,
      'ml_coverage_percent': goals.isEmpty
          ? 0
          : (goalsWithMLData / goals.length * 100).round(),
    };
  }
}
