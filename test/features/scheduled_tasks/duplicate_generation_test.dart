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
import 'package:goal_tracker/data/repositories/one_time_task_repository.dart';
import 'package:goal_tracker/data/repositories/scheduled_task_repository.dart';
import 'package:goal_tracker/data/repositories/productivity_data_repository.dart';
import 'package:goal_tracker/data/repositories/user_profile_repository.dart';
import 'package:goal_tracker/data/repositories/habit_metrics_repository.dart';
import 'package:goal_tracker/data/repositories/daily_activity_log_repository.dart';
import 'package:goal_tracker/features/scheduled_tasks/presentation/providers/scheduled_task_providers.dart';

void main() {
  late Isar isar;
  late GoalRepository goalRepository;
  late OneTimeTaskRepository oneTimeTaskRepository;
  late ScheduledTaskRepository scheduledTaskRepository;
  late ProductivityDataRepository productivityDataRepository;
  late UserProfileRepository userProfileRepository;
  late HabitMetricsRepository habitMetricsRepository;
  late DailyActivityLogRepository dailyActivityLogRepository;

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
    oneTimeTaskRepository = OneTimeTaskRepository(isar);
    scheduledTaskRepository = ScheduledTaskRepository(isar);
    productivityDataRepository = ProductivityDataRepository(isar);
    userProfileRepository = UserProfileRepository(isar);
    habitMetricsRepository = HabitMetricsRepository(isar);
    dailyActivityLogRepository = DailyActivityLogRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  Future<Goal> createGoal({
    required String title,
    required List<int> frequency,
  }) async {
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

  /// Create a properly configured ProviderContainer with all required overrides
  ProviderContainer createTestContainer() {
    return ProviderContainer(
      overrides: [
        isarProvider.overrideWithValue(isar),
        goalRepositoryProvider.overrideWithValue(goalRepository),
        oneTimeTaskRepositoryProvider.overrideWithValue(oneTimeTaskRepository),
        scheduledTaskRepositoryProvider.overrideWithValue(
          scheduledTaskRepository,
        ),
        productivityDataRepositoryProvider.overrideWithValue(
          productivityDataRepository,
        ),
        userProfileRepositoryProvider.overrideWithValue(userProfileRepository),
        habitMetricsRepositoryProvider.overrideWithValue(
          habitMetricsRepository,
        ),
        dailyActivityLogRepositoryProvider.overrideWithValue(
          dailyActivityLogRepository,
        ),
      ],
    );
  }

  test('concurrent schedule generation does not create duplicates', () async {
    final date = DateTime(2024, 1, 15);

    // Create one goal active on that day (Monday=0)
    final goal = await createGoal(
      title: 'Concurrent Goal',
      frequency: [date.weekday - 1],
    );

    // Create two ProviderContainers to simulate two app instances
    final container1 = createTestContainer();
    final container2 = createTestContainer();

    try {
      // Start both generators concurrently for the same normalized date
      final normalized = DateTime(date.year, date.month, date.day);

      final f1 = container1.read(generateScheduleProvider(normalized).future);
      final f2 = container2.read(generateScheduleProvider(normalized).future);

      // Wait for both to finish - one may throw IsarError due to unique constraint
      // This is expected behavior - the duplicate prevention is working
      await Future.wait([
        f1.catchError(
          (e) => <ScheduledTask>[],
        ), // Catch unique constraint errors
        f2.catchError((e) => <ScheduledTask>[]),
      ]);

      // Query repository directly to see how many tasks were created
      final tasks = await scheduledTaskRepository.getScheduledTasksForDate(
        normalized,
      );

      // Expect only one scheduled task for the single goal (no duplicates)
      final tasksForGoal = tasks.where((t) => t.goalId == goal.id).toList();
      expect(
        tasksForGoal.length,
        1,
        reason: 'Duplicate scheduled tasks were created for the same goal/date',
      );
    } finally {
      container1.dispose();
      container2.dispose();
    }
  });
}
