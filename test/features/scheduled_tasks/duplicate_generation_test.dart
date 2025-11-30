import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/core/services/database_service.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/data/models/task.dart';
import 'package:goal_tracker/data/models/one_time_task.dart';
import 'package:goal_tracker/data/models/scheduled_task.dart';
import 'package:goal_tracker/data/models/productivity_data.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/data/models/habit_metrics.dart';
import 'package:goal_tracker/data/models/daily_activity_log.dart';
import 'package:goal_tracker/data/repositories/goal_repository.dart';
import 'package:goal_tracker/data/repositories/scheduled_task_repository.dart';
import 'package:goal_tracker/features/scheduled_tasks/presentation/providers/scheduled_task_providers.dart';

void main() {
  late Isar isar;
  late GoalRepository goalRepository;
  late ScheduledTaskRepository scheduledTaskRepository;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [
        GoalSchema,
        MilestoneSchema,
        TaskSchema,
        OneTimeTaskSchema,
        ScheduledTaskSchema,
        ProductivityDataSchema,
        UserProfileSchema,
        HabitMetricsSchema,
        DailyActivityLogSchema,
      ],
      directory: '',
      name: 'test_dup_${DateTime.now().millisecondsSinceEpoch}',
    );

    goalRepository = GoalRepository(isar);
    scheduledTaskRepository = ScheduledTaskRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  Future<Goal> createGoal({required String title, required List<int> frequency}) async {
    final goal = Goal()
      ..title = title
      ..frequency = frequency
      ..targetDuration = 30
      ..priorityIndex = 0
      ..isActive = true
      ..createdAt = DateTime(2024, 1, 1)
      ..colorHex = '#FF0000'
      ..iconName = 'fitness_center';

    await goalRepository.createGoal(goal);
    return goal;
  }

  test('concurrent schedule generation does not create duplicates', () async {
    final date = DateTime(2024, 1, 15);

    // Create one goal active on that day (Tuesday=1 -> use day index accordingly)
    final goal = await createGoal(title: 'Concurrent Goal', frequency: [date.weekday - 1]);

    // Create two ProviderContainers to simulate two app instances
    final container1 = ProviderContainer(overrides: [
      isarProvider.overrideWithValue(isar),
    ]);
    final container2 = ProviderContainer(overrides: [
      isarProvider.overrideWithValue(isar),
    ]);

    try {
      // Start both generators concurrently for the same normalized date
      final normalized = DateTime(date.year, date.month, date.day);

      final f1 = container1.read(generateScheduleProvider(normalized).future);
      final f2 = container2.read(generateScheduleProvider(normalized).future);

      // Wait for both to finish
      await Future.wait([f1, f2]);

      // Query repository directly to see how many tasks were created
      final tasks = await scheduledTaskRepository.getScheduledTasksForDate(normalized);

      // Expect only one scheduled task for the single goal (no duplicates)
      final tasksForGoal = tasks.where((t) => t.goalId == goal.id).toList();
      expect(tasksForGoal.length, 1, reason: 'Duplicate scheduled tasks were created for the same goal/date');
    } finally {
      container1.dispose();
      container2.dispose();
    }
  });
}
