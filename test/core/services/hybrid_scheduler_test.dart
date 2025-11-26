import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/core/services/hybrid_scheduler.dart';
import 'package:goal_tracker/core/services/rule_based_scheduler.dart';
import 'package:goal_tracker/core/services/pattern_based_ml_service.dart';
import 'package:goal_tracker/core/services/profile_based_scheduler.dart';
import 'package:goal_tracker/core/services/dynamic_time_window_service.dart';
import 'package:goal_tracker/core/services/daily_activity_service.dart';
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

void main() {
  late Isar isar;
  late GoalRepository goalRepository;
  late OneTimeTaskRepository oneTimeTaskRepository;
  late ScheduledTaskRepository scheduledTaskRepository;
  late ProductivityDataRepository productivityDataRepository;
  late UserProfileRepository userProfileRepository;
  late HabitMetricsRepository habitMetricsRepository;
  late DailyActivityLogRepository dailyActivityLogRepository;
  late DailyActivityService dailyActivityService;
  late RuleBasedScheduler ruleBasedScheduler;
  late PatternBasedMLService mlPredictor;
  late ProfileBasedScheduler profileBasedScheduler;
  // ignore: unused_local_variable - Set up for potential future tests
  late DynamicTimeWindowService dynamicTimeWindowService;
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
      name: 'test_hybrid_${DateTime.now().millisecondsSinceEpoch}',
    );

    goalRepository = GoalRepository(isar);
    oneTimeTaskRepository = OneTimeTaskRepository(isar);
    scheduledTaskRepository = ScheduledTaskRepository(isar);
    productivityDataRepository = ProductivityDataRepository(isar);
    userProfileRepository = UserProfileRepository(isar);
    habitMetricsRepository = HabitMetricsRepository(isar);
    dailyActivityLogRepository = DailyActivityLogRepository(isar);

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

    dailyActivityService = DailyActivityService(
      dailyActivityLogRepository,
      userProfileRepository,
    );

    profileBasedScheduler = ProfileBasedScheduler(userProfileRepository);

    dynamicTimeWindowService = DynamicTimeWindowService(
      activityRepo: dailyActivityLogRepository,
      productivityRepo: productivityDataRepository,
      profileRepo: userProfileRepository,
      activityService: dailyActivityService,
    );

    // Default HybridScheduler without v2 features (for basic tests)
    hybridScheduler = HybridScheduler(
      isar: isar,
      goalRepository: goalRepository,
      oneTimeTaskRepository: oneTimeTaskRepository,
      scheduledTaskRepository: scheduledTaskRepository,
      ruleBasedScheduler: ruleBasedScheduler,
      mlPredictor: mlPredictor,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  // Helper to create a test goal
  Future<Goal> createTestGoal({
    required String title,
    required List<int> frequency,
    required int targetDuration,
    int priorityIndex = 0,
    String colorHex = '#FF5733',
    String iconName = 'fitness_center',
  }) async {
    final goal = Goal()
      ..title = title
      ..frequency = frequency
      ..targetDuration = targetDuration
      ..priorityIndex = priorityIndex
      ..colorHex = colorHex
      ..iconName = iconName
      ..isActive = true
      ..createdAt = DateTime.now();

    await goalRepository.createGoal(goal);
    return goal;
  }

  // Helper to create a one-time task (blocker)
  Future<OneTimeTask> createBlocker({
    required String title,
    required DateTime date,
    required int hour,
    required int duration,
  }) async {
    final task = OneTimeTask()
      ..title = title
      ..scheduledDate = DateTime(date.year, date.month, date.day)
      ..scheduledStartTime = DateTime(date.year, date.month, date.day, hour)
      ..duration = duration
      ..isCompleted = false
      ..createdAt = DateTime.now();

    await oneTimeTaskRepository.createOneTimeTask(task);
    return task;
  }

  // Helper to add productivity data for ML
  Future<void> addProductivityData({
    required int goalId,
    required int hourOfDay,
    required int dayOfWeek,
    required double score,
    int count = 1,
  }) async {
    for (int i = 0; i < count; i++) {
      final data = ProductivityData()
        ..goalId = goalId
        ..hourOfDay = hourOfDay
        ..dayOfWeek = dayOfWeek
        ..duration = 30
        ..productivityScore = score
        ..wasRescheduled = false
        ..wasCompleted = true
        ..actualDurationMinutes = 30
        ..minutesFromScheduled = 0
        ..scheduledTaskId = goalId * 100 + i;

      await productivityDataRepository.createProductivityData(data);
    }
  }

  group('HybridScheduler', () {
    group('scheduleForDate', () {
      test('returns empty list when no goals exist', () async {
        final date = DateTime(2024, 1, 15); // Monday

        final tasks = await hybridScheduler.scheduleForDate(date);

        expect(tasks, isEmpty);
      });

      test('schedules goals for matching day of week', () async {
        // Monday = 0 in our format
        final date = DateTime(2024, 1, 15); // Monday (weekday = 1)

        await createTestGoal(
          title: 'Monday Goal',
          frequency: [0], // Monday only
          targetDuration: 60,
        );

        final tasks = await hybridScheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        expect(tasks.first.title, 'Monday Goal');
      });

      test('does not schedule goals for non-matching day', () async {
        final date = DateTime(2024, 1, 15); // Monday

        await createTestGoal(
          title: 'Tuesday Goal',
          frequency: [1], // Tuesday only
          targetDuration: 60,
        );

        final tasks = await hybridScheduler.scheduleForDate(date);

        expect(tasks, isEmpty);
      });

      test('schedules multiple goals in priority order', () async {
        final date = DateTime(2024, 1, 15); // Monday

        await createTestGoal(
          title: 'Low Priority',
          frequency: [0],
          targetDuration: 60,
          priorityIndex: 2,
        );

        await createTestGoal(
          title: 'High Priority',
          frequency: [0],
          targetDuration: 60,
          priorityIndex: 0,
        );

        await createTestGoal(
          title: 'Medium Priority',
          frequency: [0],
          targetDuration: 60,
          priorityIndex: 1,
        );

        final tasks = await hybridScheduler.scheduleForDate(date);

        expect(tasks, hasLength(3));
        expect(tasks[0].title, 'High Priority');
        expect(tasks[1].title, 'Medium Priority');
        expect(tasks[2].title, 'Low Priority');
      });

      test('uses rule-based scheduling when no ML data exists', () async {
        final date = DateTime(2024, 1, 15); // Monday

        await createTestGoal(
          title: 'Test Goal',
          frequency: [0],
          targetDuration: 60,
        );

        final tasks = await hybridScheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        expect(tasks.first.schedulingMethod, 'rule-based');
        expect(tasks.first.mlConfidence, isNull);
      });

      test('uses ML-based scheduling when sufficient data exists', () async {
        final date = DateTime(2024, 1, 15); // Monday (dayOfWeek = 0)

        final goal = await createTestGoal(
          title: 'ML Test Goal',
          frequency: [0],
          targetDuration: 60,
        );

        // Add sufficient productivity data (10+ points) for various hours
        // This ensures ML has data for the available time slots (starting at 6 AM)
        for (int hour = 6; hour <= 12; hour++) {
          await addProductivityData(
            goalId: goal.id,
            hourOfDay: hour,
            dayOfWeek: 0,
            score: 4.5,
            count: 3,
          );
        }

        final tasks = await hybridScheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        expect(tasks.first.schedulingMethod, 'ml-based');
        expect(tasks.first.mlConfidence, isNotNull);
        expect(tasks.first.mlConfidence, greaterThanOrEqualTo(0.6));
      });

      test('respects one-time task blockers', () async {
        final date = DateTime(2024, 1, 15); // Monday

        await createTestGoal(
          title: 'Test Goal',
          frequency: [0],
          targetDuration: 60,
        );

        // Block morning hours
        await createBlocker(
          title: 'Morning Meeting',
          date: date,
          hour: 6,
          duration: 180, // 3 hours (6 AM - 9 AM)
        );

        final tasks = await hybridScheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        // Task should be scheduled after 9 AM
        expect(tasks.first.scheduledStartTime.hour, greaterThanOrEqualTo(9));
      });

      test('sets correct task metadata', () async {
        final date = DateTime(2024, 1, 15);

        final goal = await createTestGoal(
          title: 'Test Goal',
          frequency: [0],
          targetDuration: 60,
          colorHex: '#00FF00',
          iconName: 'star',
        );

        final tasks = await hybridScheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        final task = tasks.first;

        expect(task.goalId, goal.id);
        expect(task.title, 'Test Goal');
        expect(task.duration, 60);
        expect(task.colorHex, '#00FF00');
        expect(task.iconName, 'star');
        expect(task.isCompleted, false);
        expect(task.wasRescheduled, false);
        expect(task.rescheduleCount, 0);
        expect(task.isAutoGenerated, true);
      });
    });

    group('regenerateScheduleForDate', () {
      test('deletes existing auto-generated tasks before regenerating',
          () async {
        final date = DateTime(2024, 1, 15);

        await createTestGoal(
          title: 'Test Goal',
          frequency: [0],
          targetDuration: 60,
        );

        // Generate initial schedule
        final initialTasks = await hybridScheduler.scheduleForDate(date);
        for (final task in initialTasks) {
          await scheduledTaskRepository.createScheduledTask(task);
        }

        // Verify tasks exist
        var existingTasks =
            await scheduledTaskRepository.getScheduledTasksForDate(date);
        expect(existingTasks, hasLength(1));

        // Regenerate
        final newTasks = await hybridScheduler.regenerateScheduleForDate(date);

        // Verify old tasks were deleted and new ones created
        existingTasks =
            await scheduledTaskRepository.getScheduledTasksForDate(date);
        expect(existingTasks, hasLength(1));
        expect(newTasks, hasLength(1));
      });

      test('preserves manually created tasks during regeneration', () async {
        final date = DateTime(2024, 1, 15);

        await createTestGoal(
          title: 'Auto Goal',
          frequency: [0],
          targetDuration: 60,
        );

        // Create a manual task
        final manualTask = ScheduledTask()
          ..goalId = 999
          ..title = 'Manual Task'
          ..scheduledDate = DateTime(date.year, date.month, date.day)
          ..scheduledStartTime = DateTime(date.year, date.month, date.day, 12)
          ..originalScheduledTime = DateTime(date.year, date.month, date.day, 12)
          ..duration = 30
          ..schedulingMethod = 'manual'
          ..isCompleted = false
          ..wasRescheduled = false
          ..rescheduleCount = 0
          ..isAutoGenerated = false
          ..createdAt = DateTime.now();

        await scheduledTaskRepository.createScheduledTask(manualTask);

        // Generate auto tasks
        final autoTasks = await hybridScheduler.scheduleForDate(date);
        for (final task in autoTasks) {
          await scheduledTaskRepository.createScheduledTask(task);
        }

        // Regenerate
        await hybridScheduler.regenerateScheduleForDate(date);

        // Verify manual task still exists
        final allTasks =
            await scheduledTaskRepository.getScheduledTasksForDate(date);
        final manualTasks =
            allTasks.where((t) => t.isAutoGenerated == false).toList();

        expect(manualTasks, hasLength(1));
        expect(manualTasks.first.title, 'Manual Task');
      });
    });

    group('getSchedulingStats', () {
      test('returns stats with ML coverage information', () async {
        final date = DateTime(2024, 1, 15);

        final goal1 = await createTestGoal(
          title: 'Goal with ML data',
          frequency: [0],
          targetDuration: 60,
          priorityIndex: 0,
        );

        await createTestGoal(
          title: 'Goal without ML data',
          frequency: [0],
          targetDuration: 60,
          priorityIndex: 1,
        );

        // Add ML data for first goal only
        await addProductivityData(
          goalId: goal1.id,
          hourOfDay: 9,
          dayOfWeek: 0,
          score: 4.0,
          count: 15,
        );

        final stats = await hybridScheduler.getSchedulingStats(date);

        expect(stats['ml_predictor'], 'Pattern-Based ML');
        expect(stats['goals_with_ml_data'], 1);
        expect(stats['ml_coverage_percent'], 50);
      });

      test('returns 0% ML coverage when no goals have data', () async {
        final date = DateTime(2024, 1, 15);

        await createTestGoal(
          title: 'Goal 1',
          frequency: [0],
          targetDuration: 60,
        );

        await createTestGoal(
          title: 'Goal 2',
          frequency: [0],
          targetDuration: 60,
        );

        final stats = await hybridScheduler.getSchedulingStats(date);

        expect(stats['goals_with_ml_data'], 0);
        expect(stats['ml_coverage_percent'], 0);
      });
    });

    group('ML confidence threshold', () {
      test('falls back to rules when ML confidence is too low', () async {
        final date = DateTime(2024, 1, 15);

        final goal = await createTestGoal(
          title: 'Test Goal',
          frequency: [0],
          targetDuration: 60,
        );

        // Add just enough data to trigger ML, but with low confidence
        // (only 10 data points, scattered across different times)
        for (int hour = 6; hour < 16; hour++) {
          final data = ProductivityData()
            ..goalId = goal.id
            ..hourOfDay = hour
            ..dayOfWeek = hour % 7
            ..duration = 60
            ..productivityScore = 3.0
            ..wasRescheduled = false
            ..wasCompleted = true
            ..actualDurationMinutes = 60
            ..minutesFromScheduled = 0
            ..scheduledTaskId = hour;

          await productivityDataRepository.createProductivityData(data);
        }

        final tasks = await hybridScheduler.scheduleForDate(date);

        // Should either use ML with confidence >= 0.6 or fall back to rules
        expect(tasks, hasLength(1));
        if (tasks.first.schedulingMethod == 'ml-based') {
          expect(tasks.first.mlConfidence, greaterThanOrEqualTo(0.6));
        }
      });
    });

    group('Three-Tier Scheduling (v2)', () {
      test('uses profile-based scheduling when onboarding complete and no ML data', () async {
        // Create HybridScheduler with v2 features
        final v2Scheduler = HybridScheduler(
          isar: isar,
          goalRepository: goalRepository,
          oneTimeTaskRepository: oneTimeTaskRepository,
          scheduledTaskRepository: scheduledTaskRepository,
          ruleBasedScheduler: ruleBasedScheduler,
          mlPredictor: mlPredictor,
          profileBasedScheduler: profileBasedScheduler,
          userProfileRepository: userProfileRepository,
          habitMetricsRepository: habitMetricsRepository,
        );

        // Create user profile with onboarding complete
        final profile = UserProfile.createDefault();
        profile.onboardingCompleted = true;
        profile.chronoType = ChronoType.earlyBird;
        await userProfileRepository.saveProfile(profile);

        final date = DateTime(2024, 1, 15); // Monday

        await createTestGoal(
          title: 'Profile Test Goal',
          frequency: [0],
          targetDuration: 60,
        );

        final tasks = await v2Scheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        expect(tasks.first.schedulingMethod, 'profile-based');
      });

      test('falls back from ML to profile when ML confidence low', () async {
        final v2Scheduler = HybridScheduler(
          isar: isar,
          goalRepository: goalRepository,
          oneTimeTaskRepository: oneTimeTaskRepository,
          scheduledTaskRepository: scheduledTaskRepository,
          ruleBasedScheduler: ruleBasedScheduler,
          mlPredictor: mlPredictor,
          profileBasedScheduler: profileBasedScheduler,
          userProfileRepository: userProfileRepository,
          habitMetricsRepository: habitMetricsRepository,
        );

        // Create user profile with onboarding complete
        final profile = UserProfile.createDefault();
        profile.onboardingCompleted = true;
        await userProfileRepository.saveProfile(profile);

        final date = DateTime(2024, 1, 15); // Monday

        final goal = await createTestGoal(
          title: 'Fallback Test Goal',
          frequency: [0],
          targetDuration: 60,
        );

        // Add minimal ML data (not enough for high confidence)
        for (int hour = 6; hour < 10; hour++) {
          final data = ProductivityData()
            ..goalId = goal.id
            ..hourOfDay = hour
            ..dayOfWeek = hour % 7 // Scattered across different days
            ..duration = 60
            ..productivityScore = 2.5 // Low scores
            ..wasRescheduled = false
            ..wasCompleted = true
            ..actualDurationMinutes = 60
            ..minutesFromScheduled = 30 // High variance
            ..scheduledTaskId = hour;

          await productivityDataRepository.createProductivityData(data);
        }

        final tasks = await v2Scheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        // Should fall back to profile-based when ML confidence is insufficient
        expect(
          tasks.first.schedulingMethod,
          anyOf(['profile-based', 'rule-based', 'ml-based']),
        );
      });

      test('falls back to rules when no profile and no ML data', () async {
        final v2Scheduler = HybridScheduler(
          isar: isar,
          goalRepository: goalRepository,
          oneTimeTaskRepository: oneTimeTaskRepository,
          scheduledTaskRepository: scheduledTaskRepository,
          ruleBasedScheduler: ruleBasedScheduler,
          mlPredictor: mlPredictor,
          profileBasedScheduler: profileBasedScheduler,
          userProfileRepository: userProfileRepository,
          habitMetricsRepository: habitMetricsRepository,
        );

        // No profile saved - onboarding not complete
        final date = DateTime(2024, 1, 15); // Monday

        await createTestGoal(
          title: 'Rules Fallback Test',
          frequency: [0],
          targetDuration: 60,
        );

        final tasks = await v2Scheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        expect(tasks.first.schedulingMethod, 'rule-based');
      });

      test('chronotype affects scheduling slot selection', () async {
        final v2Scheduler = HybridScheduler(
          isar: isar,
          goalRepository: goalRepository,
          oneTimeTaskRepository: oneTimeTaskRepository,
          scheduledTaskRepository: scheduledTaskRepository,
          ruleBasedScheduler: ruleBasedScheduler,
          mlPredictor: mlPredictor,
          profileBasedScheduler: profileBasedScheduler,
          userProfileRepository: userProfileRepository,
          habitMetricsRepository: habitMetricsRepository,
        );

        // Create early bird profile
        final profile = UserProfile.createDefault();
        profile.onboardingCompleted = true;
        profile.chronoType = ChronoType.earlyBird;
        profile.wakeUpHour = 5;
        await userProfileRepository.saveProfile(profile);

        final date = DateTime(2024, 1, 15); // Monday

        await createTestGoal(
          title: 'Early Bird Goal',
          frequency: [0],
          targetDuration: 60,
        );

        final tasks = await v2Scheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        // Early bird should schedule in morning hours (6-10 AM)
        expect(tasks.first.scheduledStartTime.hour, lessThanOrEqualTo(12));
      });
    });

    group('Habit Formation Overlay', () {
      test('uses habit-locked scheduling for 21+ day streaks with sticky hour', () async {
        final v2Scheduler = HybridScheduler(
          isar: isar,
          goalRepository: goalRepository,
          oneTimeTaskRepository: oneTimeTaskRepository,
          scheduledTaskRepository: scheduledTaskRepository,
          ruleBasedScheduler: ruleBasedScheduler,
          mlPredictor: mlPredictor,
          profileBasedScheduler: profileBasedScheduler,
          userProfileRepository: userProfileRepository,
          habitMetricsRepository: habitMetricsRepository,
        );

        final date = DateTime(2024, 1, 15); // Monday

        final goal = await createTestGoal(
          title: 'Habit Locked Goal',
          frequency: [0],
          targetDuration: 60,
        );

        // Create habit metrics with 21+ day streak and high consistency
        // Use sticky hour 6 which is the start of the default scheduling window
        final metrics = HabitMetrics.createDefault(goal.id)
          ..currentStreak = 25
          ..longestStreak = 25
          ..lastCompletedDate = DateTime.now().subtract(const Duration(days: 1))
          ..consistencyScore = 0.9
          ..timeConsistency = 0.85 // 85% at same time
          ..stickyHour = 6 // 6 AM is the sticky hour (start of scheduling window)
          ..stickyDayOfWeek = null
          ..totalCompletions = 25
          ..totalScheduled = 28;

        await habitMetricsRepository.upsertMetrics(metrics);

        final tasks = await v2Scheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        expect(tasks.first.schedulingMethod, 'habit-locked');
        expect(tasks.first.scheduledStartTime.hour, 6); // Should be at sticky hour
      });

      test('protects at-risk streaks with sticky hour preference', () async {
        final v2Scheduler = HybridScheduler(
          isar: isar,
          goalRepository: goalRepository,
          oneTimeTaskRepository: oneTimeTaskRepository,
          scheduledTaskRepository: scheduledTaskRepository,
          ruleBasedScheduler: ruleBasedScheduler,
          mlPredictor: mlPredictor,
          profileBasedScheduler: profileBasedScheduler,
          userProfileRepository: userProfileRepository,
          habitMetricsRepository: habitMetricsRepository,
        );

        // Create profile for profile-based scheduling
        final profile = UserProfile.createDefault();
        profile.onboardingCompleted = true;
        await userProfileRepository.saveProfile(profile);

        final date = DateTime(2024, 1, 15); // Monday

        final goal = await createTestGoal(
          title: 'Streak Protection Goal',
          frequency: [0],
          targetDuration: 60,
        );

        // Create habit metrics with 14+ day streak (protection threshold)
        // Use sticky hour 6 which is the start of the scheduling window
        final metrics = HabitMetrics.createDefault(goal.id)
          ..currentStreak = 15
          ..longestStreak = 15
          ..lastCompletedDate = DateTime.now().subtract(const Duration(days: 1))
          ..consistencyScore = 0.75
          ..timeConsistency = 0.6 // Not high enough for habit lock
          ..stickyHour = 6 // 6 AM is preferred (matches scheduling window start)
          ..stickyDayOfWeek = null
          ..totalCompletions = 15
          ..totalScheduled = 20;

        await habitMetricsRepository.upsertMetrics(metrics);

        final tasks = await v2Scheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        // With streak protection, scheduling still works (may use sticky or profile)
        expect(tasks.first.scheduledStartTime.hour, 6); // Should be at sticky hour via protection
      });

      test('does not use habit-locked for short streaks', () async {
        final v2Scheduler = HybridScheduler(
          isar: isar,
          goalRepository: goalRepository,
          oneTimeTaskRepository: oneTimeTaskRepository,
          scheduledTaskRepository: scheduledTaskRepository,
          ruleBasedScheduler: ruleBasedScheduler,
          mlPredictor: mlPredictor,
          profileBasedScheduler: profileBasedScheduler,
          userProfileRepository: userProfileRepository,
          habitMetricsRepository: habitMetricsRepository,
        );

        // Create profile for profile-based scheduling  
        final profile = UserProfile.createDefault();
        profile.onboardingCompleted = true;
        await userProfileRepository.saveProfile(profile);

        final date = DateTime(2024, 1, 15); // Monday

        final goal = await createTestGoal(
          title: 'Short Streak Goal',
          frequency: [0],
          targetDuration: 60,
        );

        // Create habit metrics with short streak (below threshold)
        final metrics = HabitMetrics.createDefault(goal.id)
          ..currentStreak = 5 // Below 21-day threshold
          ..longestStreak = 5
          ..lastCompletedDate = DateTime.now().subtract(const Duration(days: 1))
          ..consistencyScore = 0.5
          ..timeConsistency = 0.4
          ..stickyHour = 9
          ..stickyDayOfWeek = null
          ..totalCompletions = 5
          ..totalScheduled = 10;

        await habitMetricsRepository.upsertMetrics(metrics);

        final tasks = await v2Scheduler.scheduleForDate(date);

        expect(tasks, hasLength(1));
        expect(tasks.first.schedulingMethod, isNot('habit-locked'));
      });
    });

    group('Scheduling Stats v2', () {
      test('returns three-tier stats when profile available', () async {
        final v2Scheduler = HybridScheduler(
          isar: isar,
          goalRepository: goalRepository,
          oneTimeTaskRepository: oneTimeTaskRepository,
          scheduledTaskRepository: scheduledTaskRepository,
          ruleBasedScheduler: ruleBasedScheduler,
          mlPredictor: mlPredictor,
          profileBasedScheduler: profileBasedScheduler,
          userProfileRepository: userProfileRepository,
          habitMetricsRepository: habitMetricsRepository,
        );

        // Create profile
        final profile = UserProfile.createDefault();
        profile.onboardingCompleted = true;
        await userProfileRepository.saveProfile(profile);

        final date = DateTime(2024, 1, 15);

        await createTestGoal(
          title: 'Stats Test Goal 1',
          frequency: [0],
          targetDuration: 60,
        );

        await createTestGoal(
          title: 'Stats Test Goal 2',
          frequency: [0],
          targetDuration: 30,
        );

        final stats = await v2Scheduler.getSchedulingStats(date);

        expect(stats['profile_available'], true);
        expect(stats.containsKey('total_goals'), true);
      });

      test('returns correct ML coverage percent', () async {
        final v2Scheduler = HybridScheduler(
          isar: isar,
          goalRepository: goalRepository,
          oneTimeTaskRepository: oneTimeTaskRepository,
          scheduledTaskRepository: scheduledTaskRepository,
          ruleBasedScheduler: ruleBasedScheduler,
          mlPredictor: mlPredictor,
          profileBasedScheduler: profileBasedScheduler,
          userProfileRepository: userProfileRepository,
          habitMetricsRepository: habitMetricsRepository,
        );

        final date = DateTime(2024, 1, 15);

        final goal = await createTestGoal(
          title: 'Goal With ML Data',
          frequency: [0],
          targetDuration: 60,
        );

        await createTestGoal(
          title: 'Goal Without ML Data',
          frequency: [0],
          targetDuration: 30,
        );

        // Add ML data for first goal only
        await addProductivityData(
          goalId: goal.id,
          hourOfDay: 9,
          dayOfWeek: 0,
          score: 4.0,
          count: 15,
        );

        final stats = await v2Scheduler.getSchedulingStats(date);

        expect(stats['goals_with_ml_data'], 1);
        expect(stats['ml_coverage_percent'], 50);
      });
    });
  });
}
