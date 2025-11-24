import 'package:isar/isar.dart';
import '../../data/models/scheduled_task.dart';
import '../../data/models/productivity_data.dart';
import '../../data/repositories/scheduled_task_repository.dart';
import '../../data/repositories/productivity_data_repository.dart';

/// Service to collect productivity data for ML training
class ProductivityDataCollector {
  final Isar isar;
  final ScheduledTaskRepository scheduledTaskRepository;
  final ProductivityDataRepository productivityDataRepository;

  ProductivityDataCollector({
    required this.isar,
    required this.scheduledTaskRepository,
    required this.productivityDataRepository,
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
    // TODO: Implement proper adjacent task detection
    final hadPriorTask = false;
    final hadFollowingTask = false;

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
      ..recordedAt = DateTime.now();

    // If ML was used, store prediction info
    if (task.schedulingMethod == 'ml-based' && task.mlConfidence != null) {
      productivityData.predictedScore = productivityRating; // Placeholder
      productivityData.predictionError = 0.0; // Will be calculated later
    }

    await productivityDataRepository.createProductivityData(productivityData);

    print(
      '   📈 ML Data: goal=${task.goalId}, hour=$hourOfDay, day=$dayOfWeek, score=$productivityRating',
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
    final scheduledTime = task.scheduledStartTime;
    final dayOfWeek = scheduledTime.weekday - 1;
    final hourOfDay = scheduledTime.hour;
    final timeSlotType = ProductivityData.calculateTimeSlotType(hourOfDay);
    final weekOfYear = _getWeekOfYear(scheduledTime);
    final isWeekend = dayOfWeek == 5 || dayOfWeek == 6;

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
      ..recordedAt = DateTime.now();

    await productivityDataRepository.createProductivityData(productivityData);

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
