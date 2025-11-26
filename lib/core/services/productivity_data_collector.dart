import 'package:isar/isar.dart';
import '../../data/models/scheduled_task.dart';
import '../../data/models/productivity_data.dart';
import '../../data/repositories/scheduled_task_repository.dart';
import '../../data/repositories/productivity_data_repository.dart';
import '../../data/repositories/habit_metrics_repository.dart';
import 'habit_formation_service.dart';
import 'daily_activity_service.dart';

/// Service to collect productivity data for ML training
class ProductivityDataCollector {
  final Isar isar;
  final ScheduledTaskRepository scheduledTaskRepository;
  final ProductivityDataRepository productivityDataRepository;
  final HabitFormationService? habitFormationService;
  final DailyActivityService? dailyActivityService;
  final HabitMetricsRepository? habitMetricsRepository;

  // Track consecutive completions for momentum
  int _consecutiveCompletions = 0;
  DateTime? _lastCompletionTime;

  ProductivityDataCollector({
    required this.isar,
    required this.scheduledTaskRepository,
    required this.productivityDataRepository,
    this.habitFormationService,
    this.dailyActivityService,
    this.habitMetricsRepository,
  });

  /// Record task completion with productivity feedback
  Future<void> recordTaskCompletion({
    required int taskId,
    required DateTime actualStartTime,
    required int actualDurationMinutes,
    required double productivityRating, // 1.0 - 5.0
    String? notes,
  }) async {
    // Get the scheduled task
    final task = await scheduledTaskRepository.getScheduledTask(taskId);
    if (task == null) {
      print('⚠️  Task $taskId not found');
      return;
    }

    print('📊 Recording completion for: ${task.title}');

    // Mark task as completed
    await scheduledTaskRepository.markAsCompleted(
      taskId,
      actualStartTime: actualStartTime,
      actualDuration: actualDurationMinutes,
      productivityRating: productivityRating.round(),
      notes: notes,
    );

    // Create productivity data for ML training
    await _createProductivityData(
      task: task,
      actualStartTime: actualStartTime,
      actualDurationMinutes: actualDurationMinutes,
      productivityRating: productivityRating,
    );

    // Update habit formation metrics
    if (habitFormationService != null) {
      await habitFormationService!.updateMetricsOnCompletion(
        goalId: task.goalId,
        completedAt: actualStartTime,
        actualDuration: actualDurationMinutes,
        productivityRating: productivityRating.round(),
      );
      print('🔥 Habit metrics updated');
    }

    print('✅ Productivity data recorded');
  }

  /// Create ProductivityData record for ML training
  Future<void> _createProductivityData({
    required ScheduledTask task,
    required DateTime actualStartTime,
    required int actualDurationMinutes,
    required double productivityRating,
  }) async {
    final scheduledTime = task.scheduledStartTime;
    final dayOfWeek = scheduledTime.weekday - 1; // 0=Monday
    final hourOfDay = scheduledTime.hour;

    // Calculate time slot type
    final timeSlotType = ProductivityData.calculateTimeSlotType(hourOfDay);

    // Calculate deviation from schedule
    final minutesFromScheduled = actualStartTime
        .difference(scheduledTime)
        .inMinutes;

    // Get week of year
    final weekOfYear = _getWeekOfYear(scheduledTime);

    // Check if weekend
    final isWeekend = dayOfWeek == 5 || dayOfWeek == 6; // Saturday or Sunday

    // Check if there were adjacent tasks (simplified for now)
    final hadPriorTask = false;
    final hadFollowingTask = false;

    // === Phase 8: Capture contextual features ===
    
    // Get context from DailyActivityService
    TaskCompletionContext? context;
    double relativeTimeInDay = 0.5;
    int minutesSinceFirstActivity = 0;
    double previousTaskRating = 0.0;
    
    if (dailyActivityService != null) {
      context = await dailyActivityService!.getTodayContext(actualStartTime);
      relativeTimeInDay = await dailyActivityService!.calculateRelativeTimeInDay(actualStartTime);
      minutesSinceFirstActivity = await dailyActivityService!.getMinutesSinceFirstActivity(actualStartTime);
      previousTaskRating = await dailyActivityService!.getPreviousTaskRating(actualStartTime);
      
      // Record this activity
      await dailyActivityService!.recordTaskCompletion(
        completionTime: actualStartTime,
        productivityRating: productivityRating,
      );
    }
    
    // Get habit metrics for the goal
    int currentStreak = 0;
    double goalConsistencyScore = 0.0;
    
    if (habitMetricsRepository != null) {
      final metrics = await habitMetricsRepository!.getMetricsForGoal(task.goalId);
      if (metrics != null) {
        currentStreak = metrics.currentStreak;
        goalConsistencyScore = metrics.consistencyScore;
      }
    }
    
    // Calculate momentum features
    _consecutiveCompletions++;
    final minutesSinceLastCompletion = _lastCompletionTime != null
        ? actualStartTime.difference(_lastCompletionTime!).inMinutes.abs()
        : 0;
    _lastCompletionTime = actualStartTime;

    // Create the productivity data record
    final productivityData = ProductivityData()
      ..goalId = task.goalId
      ..hourOfDay = hourOfDay
      ..dayOfWeek = dayOfWeek
      ..duration = task.duration
      ..timeSlotType = timeSlotType
      ..hadPriorTask = hadPriorTask
      ..hadFollowingTask = hadFollowingTask
      ..weekOfYear = weekOfYear
      ..isWeekend = isWeekend
      ..productivityScore = productivityRating
      ..wasRescheduled = task.wasRescheduled
      ..wasCompleted = true
      ..actualDurationMinutes = actualDurationMinutes
      ..minutesFromScheduled = minutesFromScheduled
      ..scheduledTaskId = task.id
      ..recordedAt = DateTime.now()
      // Phase 8 contextual features
      ..taskOrderInDay = context?.taskOrderInDay ?? 1
      ..totalTasksScheduledToday = context?.totalTasksScheduledToday ?? 1
      ..tasksCompletedBeforeThis = context?.tasksCompletedBeforeThis ?? 0
      ..relativeTimeInDay = relativeTimeInDay
      ..minutesSinceFirstActivity = minutesSinceFirstActivity
      ..previousTaskRating = previousTaskRating
      ..completionRateLast7Days = context?.completionRateLast7Days ?? 0.0
      ..currentStreakAtCompletion = currentStreak
      ..goalConsistencyScore = goalConsistencyScore
      ..consecutiveTasksCompleted = _consecutiveCompletions
      ..minutesSinceLastCompletion = minutesSinceLastCompletion;

    // If ML was used, store prediction info
    if (task.schedulingMethod == 'ml-based' && task.mlConfidence != null) {
      productivityData.predictedScore = productivityRating; // Placeholder
      productivityData.predictionError = 0.0; // Will be calculated later
    }

    await productivityDataRepository.createProductivityData(productivityData);

    print(
      '   📈 ML Data: goal=${task.goalId}, hour=$hourOfDay, day=$dayOfWeek, score=$productivityRating',
    );
    print(
      '   📊 Context: order=${context?.taskOrderInDay}, streak=$currentStreak, momentum=${_consecutiveCompletions}',
    );
  }

  /// Record task reschedule (important ML signal!)
  Future<void> recordTaskReschedule({
    required int taskId,
    required DateTime newStartTime,
  }) async {
    final task = await scheduledTaskRepository.getScheduledTask(taskId);
    if (task == null) {
      print('⚠️  Task $taskId not found');
      return;
    }

    print('🔄 Recording reschedule for: ${task.title}');
    print(
      '   From: ${task.scheduledStartTime.hour}:${task.scheduledStartTime.minute.toString().padLeft(2, '0')}',
    );
    print(
      '   To: ${newStartTime.hour}:${newStartTime.minute.toString().padLeft(2, '0')}',
    );

    // Record the reschedule
    await scheduledTaskRepository.recordReschedule(taskId, newStartTime);

    print('✅ Reschedule recorded (ML will learn from this!)');
  }

  /// Mark task as skipped (not completed)
  Future<void> recordTaskSkipped({required int taskId, String? reason}) async {
    final task = await scheduledTaskRepository.getScheduledTask(taskId);
    if (task == null) {
      print('⚠️  Task $taskId not found');
      return;
    }

    print('⏭️  Recording skip for: ${task.title}');

    // Create productivity data with low score and wasCompleted = false
    final now = DateTime.now();
    final scheduledTime = task.scheduledStartTime;
    final dayOfWeek = scheduledTime.weekday - 1;
    final hourOfDay = scheduledTime.hour;
    final timeSlotType = ProductivityData.calculateTimeSlotType(hourOfDay);
    final weekOfYear = _getWeekOfYear(scheduledTime);
    final isWeekend = dayOfWeek == 5 || dayOfWeek == 6;

    // === Phase 8: Capture contextual features for skips too ===
    TaskCompletionContext? context;
    double relativeTimeInDay = 0.5;
    int minutesSinceFirstActivity = 0;
    double previousTaskRating = 0.0;
    
    if (dailyActivityService != null) {
      context = await dailyActivityService!.getTodayContext(now);
      relativeTimeInDay = await dailyActivityService!.calculateRelativeTimeInDay(now);
      minutesSinceFirstActivity = await dailyActivityService!.getMinutesSinceFirstActivity(now);
      previousTaskRating = await dailyActivityService!.getPreviousTaskRating(now);
    }
    
    // Get habit metrics for the goal
    int currentStreak = 0;
    double goalConsistencyScore = 0.0;
    
    if (habitMetricsRepository != null) {
      final metrics = await habitMetricsRepository!.getMetricsForGoal(task.goalId);
      if (metrics != null) {
        currentStreak = metrics.currentStreak;
        goalConsistencyScore = metrics.consistencyScore;
      }
    }
    
    // Reset momentum on skip
    final previousConsecutive = _consecutiveCompletions;
    _consecutiveCompletions = 0;
    final minutesSinceLastCompletion = _lastCompletionTime != null
        ? now.difference(_lastCompletionTime!).inMinutes.abs()
        : 0;

    final productivityData = ProductivityData()
      ..goalId = task.goalId
      ..hourOfDay = hourOfDay
      ..dayOfWeek = dayOfWeek
      ..duration = task.duration
      ..timeSlotType = timeSlotType
      ..hadPriorTask = false
      ..hadFollowingTask = false
      ..weekOfYear = weekOfYear
      ..isWeekend = isWeekend
      ..productivityScore =
          0.0 // Skipped = 0 score
      ..wasRescheduled = task.wasRescheduled
      ..wasCompleted =
          false // Important signal!
      ..actualDurationMinutes = 0
      ..minutesFromScheduled = 0
      ..scheduledTaskId = task.id
      ..recordedAt = now
      // Phase 8 contextual features
      ..taskOrderInDay = context?.taskOrderInDay ?? 1
      ..totalTasksScheduledToday = context?.totalTasksScheduledToday ?? 1
      ..tasksCompletedBeforeThis = context?.tasksCompletedBeforeThis ?? 0
      ..relativeTimeInDay = relativeTimeInDay
      ..minutesSinceFirstActivity = minutesSinceFirstActivity
      ..previousTaskRating = previousTaskRating
      ..completionRateLast7Days = context?.completionRateLast7Days ?? 0.0
      ..currentStreakAtCompletion = currentStreak
      ..goalConsistencyScore = goalConsistencyScore
      ..consecutiveTasksCompleted = previousConsecutive  // Record the streak that was broken
      ..minutesSinceLastCompletion = minutesSinceLastCompletion;

    await productivityDataRepository.createProductivityData(productivityData);
    
    print('   📈 Skip context: momentum=$previousConsecutive→0, streak=$currentStreak');

    // Update habit formation metrics (streak break)
    if (habitFormationService != null) {
      await habitFormationService!.updateMetricsOnSkip(task.goalId);
      print('⚠️  Streak may be affected');
    }

    print('✅ Skip recorded (ML will learn to avoid this time!)');
  }

  /// Get week of year (1-52)
  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil() + 1;
  }

  /// Get productivity statistics for a goal
  Future<Map<String, dynamic>> getProductivityStats(int goalId) async {
    final data = await productivityDataRepository.getDataForGoal(goalId);

    if (data.isEmpty) {
      return {'has_data': false, 'total_completions': 0};
    }

    final completions = data.where((d) => d.wasCompleted).length;
    final skips = data.where((d) => !d.wasCompleted).length;
    final reschedules = data.where((d) => d.wasRescheduled).length;

    final avgProductivity =
        data
            .where((d) => d.wasCompleted)
            .map((d) => d.productivityScore)
            .fold(0.0, (sum, score) => sum + score) /
        (completions > 0 ? completions : 1);

    final bestTime = await productivityDataRepository.getBestTimeForGoal(
      goalId,
    );

    return {
      'has_data': true,
      'total_completions': completions,
      'total_skips': skips,
      'total_reschedules': reschedules,
      'avg_productivity': avgProductivity,
      'best_time': bestTime,
      'completion_rate': data.isEmpty ? 0.0 : completions / data.length,
    };
  }
}
