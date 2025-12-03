import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/core/services/hybrid_scheduler.dart';
import 'package:goal_tracker/core/services/rule_based_scheduler.dart';
import 'package:goal_tracker/core/services/pattern_based_ml_service.dart';
import 'package:goal_tracker/core/services/profile_based_scheduler.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/one_time_task.dart';
import 'package:goal_tracker/data/models/scheduled_task.dart';
import 'package:goal_tracker/data/models/productivity_data.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/data/models/habit_metrics.dart';
import 'package:goal_tracker/data/models/daily_activity_log.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/data/models/task.dart';
import 'package:goal_tracker/data/repositories/goal_repository.dart';
import 'package:goal_tracker/data/repositories/one_time_task_repository.dart';
import 'package:goal_tracker/data/repositories/scheduled_task_repository.dart';
import 'package:goal_tracker/data/repositories/productivity_data_repository.dart';
import 'package:goal_tracker/data/repositories/user_profile_repository.dart';

void main() {
  late Isar isar;
  late GoalRepository goalRepository;
  late OneTimeTaskRepository oneTimeTaskRepository;
  late ScheduledTaskRepository scheduledTaskRepository;
  late ProductivityDataRepository productivityDataRepository;
  late UserProfileRepository userProfileRepository;
  late RuleBasedScheduler ruleBasedScheduler;
  late PatternBasedMLService mlPredictor;
  late ProfileBasedScheduler profileBasedScheduler;
  late HybridScheduler hybridScheduler;

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
      name: 'test_reproduce_${DateTime.now().millisecondsSinceEpoch}',
    );

    goalRepository = GoalRepository(isar);
    oneTimeTaskRepository = OneTimeTaskRepository(isar);
    scheduledTaskRepository = ScheduledTaskRepository(isar);
    productivityDataRepository = ProductivityDataRepository(isar);
    userProfileRepository = UserProfileRepository(isar);

    ruleBasedScheduler = RuleBasedScheduler(
      isar: isar,
      goalRepository: goalRepository,
      oneTimeTaskRepository: oneTimeTaskRepository,
      scheduledTaskRepository: scheduledTaskRepository,
    );

    mlPredictor = PatternBasedMLService(
      isar: isar,
      productivityDataRepository: productivityDataRepository,
    );

    profileBasedScheduler = ProfileBasedScheduler(userProfileRepository);

    hybridScheduler = HybridScheduler(
      isar: isar,
      goalRepository: goalRepository,
      oneTimeTaskRepository: oneTimeTaskRepository,
      scheduledTaskRepository: scheduledTaskRepository,
      ruleBasedScheduler: ruleBasedScheduler,
      mlPredictor: mlPredictor,
      profileBasedScheduler: profileBasedScheduler,
      userProfileRepository: userProfileRepository,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  test(
    'Fix Verification: Two 2h goals SHOULD schedule in a 4h window using Buffer Squeeze',
    () async {
      final date = DateTime(2024, 1, 15); // Monday

      // 0. Create User Profile (Required for Smart Scheduler)
      final profile = UserProfile.createDefault()
        ..onboardingCompleted = true; // Enable profile-based scheduling
      await userProfileRepository.saveProfile(profile);

      // 1. Create two 2-hour goals
      final goal1 = Goal()
        ..title = 'Goal 1'
        ..frequency =
            [0] // Monday
        ..targetDuration =
            120 // 2 hours
        ..priorityIndex = 0
        ..colorHex = '#FF0000'
        ..iconName = 'test'
        ..isActive = true
        ..createdAt = DateTime(2024, 1, 1);
      await goalRepository.createGoal(goal1);

      final goal2 = Goal()
        ..title = 'Goal 2'
        ..frequency =
            [0] // Monday
        ..targetDuration =
            120 // 2 hours
        ..priorityIndex = 1
        ..colorHex = '#00FF00'
        ..iconName = 'test'
        ..isActive = true
        ..createdAt = DateTime(2024, 1, 1);
      await goalRepository.createGoal(goal2);

      // 2. Create blockers to constrain the day
      // Day is 6 AM - 11 PM (default)

      // Blocker 1: 7 AM - 5 PM (10 hours)
      final blocker1 = OneTimeTask()
        ..title = 'Work'
        ..scheduledDate = date
        ..scheduledStartTime = DateTime(date.year, date.month, date.day, 7, 0)
        ..duration =
            600 // 10 hours
        ..isCompleted = false
        ..createdAt = DateTime.now();
      await oneTimeTaskRepository.createOneTimeTask(blocker1);

      // Blocker 2: 9 PM - 11 PM (2 hours) - To simulate end of day at 9 PM
      final blocker2 = OneTimeTask()
        ..title = 'Evening Routine'
        ..scheduledDate = date
        ..scheduledStartTime = DateTime(date.year, date.month, date.day, 21, 0)
        ..duration =
            120 // 2 hours
        ..isCompleted = false
        ..createdAt = DateTime.now();
      await oneTimeTaskRepository.createOneTimeTask(blocker2);

      // Available windows:
      // 6 AM - 7 AM (1 hour) -> Too small for 2h goal
      // 5 PM - 9 PM (4 hours) -> Exactly 4 hours

      // 3. Run scheduler
      final tasks = await hybridScheduler.scheduleForDate(date);

      // Expectation: BOTH goals should be scheduled now because of Buffer Squeeze
      expect(tasks, hasLength(2));
      expect(tasks[0].title, 'Goal 1');
      expect(tasks[1].title, 'Goal 2');

      // Verify scheduling method indicates smart/squeezed
      expect(tasks.any((t) => t.schedulingMethod.contains('squeezed')), isTrue);
    },
  );
}
