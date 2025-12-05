import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/features/goals/presentation/providers/milestone_provider.dart';
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
import 'package:goal_tracker/data/repositories/milestone_repository.dart';

void main() {
  late Isar isar;
  late GoalRepository goalRepository;
  late MilestoneRepository milestoneRepository;
  late ProviderContainer container;

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
      name: 'test_milestone_provider_${DateTime.now().millisecondsSinceEpoch}',
    );

    goalRepository = GoalRepository(isar);
    milestoneRepository = MilestoneRepository(isar);

    container = ProviderContainer(
      overrides: [
        isarProvider.overrideWithValue(isar),
        milestoneRepositoryProvider.overrideWithValue(milestoneRepository),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await isar.close(deleteFromDisk: true);
  });

  // Helper to create a test goal
  Future<Goal> createTestGoal({
    required String title,
    int priorityIndex = 0,
  }) async {
    final goal = Goal()
      ..title = title
      ..frequency = [0, 1, 2, 3, 4]
      ..targetDuration = 60
      ..priorityIndex = priorityIndex
      ..colorHex = '#FF5733'
      ..iconName = 'fitness_center'
      ..createdAt = DateTime.now()
      ..isActive = true;

    final id = await goalRepository.createGoal(goal);
    goal.id = id;
    return goal;
  }

  // Helper to create a test milestone
  Future<Milestone> createTestMilestone({
    required int goalId,
    required String title,
    int orderIndex = 0,
    bool isCompleted = false,
  }) async {
    final milestone = Milestone()
      ..title = title
      ..orderIndex = orderIndex
      ..isCompleted = isCompleted;

    final id = await milestoneRepository.createMilestone(milestone, goalId);
    milestone.id = id;
    return milestone;
  }

  group('MilestoneProvider', () {
    test('milestonesForGoalProvider returns empty list for goal with no milestones', () async {
      final goal = await createTestGoal(title: 'Test Goal');

      final milestones = await container.read(milestonesForGoalProvider(goal.id).future);

      expect(milestones, isEmpty);
    });

    test('milestonesForGoalProvider returns all milestones for a goal', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      await createTestMilestone(goalId: goal.id, title: 'Milestone 1', orderIndex: 0);
      await createTestMilestone(goalId: goal.id, title: 'Milestone 2', orderIndex: 1);
      await createTestMilestone(goalId: goal.id, title: 'Milestone 3', orderIndex: 2);

      final milestones = await container.read(milestonesForGoalProvider(goal.id).future);

      expect(milestones.length, 3);
      expect(milestones[0].title, 'Milestone 1');
      expect(milestones[1].title, 'Milestone 2');
      expect(milestones[2].title, 'Milestone 3');
    });

    test('milestonesForGoalProvider returns milestones in correct order', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      await createTestMilestone(goalId: goal.id, title: 'Third', orderIndex: 2);
      await createTestMilestone(goalId: goal.id, title: 'First', orderIndex: 0);
      await createTestMilestone(goalId: goal.id, title: 'Second', orderIndex: 1);

      final milestones = await container.read(milestonesForGoalProvider(goal.id).future);

      expect(milestones[0].title, 'First');
      expect(milestones[1].title, 'Second');
      expect(milestones[2].title, 'Third');
    });

    test('firstIncompleteMilestoneProvider returns first incomplete milestone', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      await createTestMilestone(goalId: goal.id, title: 'Completed', orderIndex: 0, isCompleted: true);
      await createTestMilestone(goalId: goal.id, title: 'First Incomplete', orderIndex: 1, isCompleted: false);
      await createTestMilestone(goalId: goal.id, title: 'Second Incomplete', orderIndex: 2, isCompleted: false);

      final firstIncomplete = await container.read(firstIncompleteMilestoneProvider(goal.id).future);

      expect(firstIncomplete, isNotNull);
      expect(firstIncomplete!.title, 'First Incomplete');
    });

    test('firstIncompleteMilestoneProvider returns null when all milestones completed', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      await createTestMilestone(goalId: goal.id, title: 'Completed 1', orderIndex: 0, isCompleted: true);
      await createTestMilestone(goalId: goal.id, title: 'Completed 2', orderIndex: 1, isCompleted: true);

      final firstIncomplete = await container.read(firstIncompleteMilestoneProvider(goal.id).future);

      expect(firstIncomplete, isNull);
    });

    test('firstIncompleteMilestoneProvider returns null when no milestones', () async {
      final goal = await createTestGoal(title: 'Test Goal');

      final firstIncomplete = await container.read(firstIncompleteMilestoneProvider(goal.id).future);

      expect(firstIncomplete, isNull);
    });

    test('completedMilestoneCountProvider returns correct count', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      await createTestMilestone(goalId: goal.id, title: 'Completed 1', orderIndex: 0, isCompleted: true);
      await createTestMilestone(goalId: goal.id, title: 'Incomplete', orderIndex: 1, isCompleted: false);
      await createTestMilestone(goalId: goal.id, title: 'Completed 2', orderIndex: 2, isCompleted: true);

      final count = await container.read(completedMilestoneCountProvider(goal.id).future);

      expect(count, 2);
    });

    test('completedMilestoneCountProvider returns 0 when no milestones', () async {
      final goal = await createTestGoal(title: 'Test Goal');

      final count = await container.read(completedMilestoneCountProvider(goal.id).future);

      expect(count, 0);
    });
  });

  group('MilestoneNotifier', () {
    test('createMilestone adds a new milestone', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      final notifier = container.read(milestoneNotifierProvider.notifier);

      final milestone = Milestone()
        ..title = 'New Milestone'
        ..orderIndex = 0
        ..isCompleted = false;

      await notifier.createMilestone(milestone, goal.id);

      final milestones = await container.read(milestonesForGoalProvider(goal.id).future);
      expect(milestones.length, 1);
      expect(milestones[0].title, 'New Milestone');
    });

    test('toggleMilestoneCompletion marks milestone as complete', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      final milestone = await createTestMilestone(
        goalId: goal.id,
        title: 'Test Milestone',
        isCompleted: false,
      );
      final notifier = container.read(milestoneNotifierProvider.notifier);

      await notifier.toggleMilestoneCompletion(milestone.id, goal.id, true);

      final updatedMilestone = await milestoneRepository.getMilestone(milestone.id);
      expect(updatedMilestone!.isCompleted, true);
      expect(updatedMilestone.completedAt, isNotNull);
    });

    test('toggleMilestoneCompletion marks milestone as incomplete', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      final milestone = await createTestMilestone(
        goalId: goal.id,
        title: 'Test Milestone',
        isCompleted: true,
      );
      final notifier = container.read(milestoneNotifierProvider.notifier);

      await notifier.toggleMilestoneCompletion(milestone.id, goal.id, false);

      final updatedMilestone = await milestoneRepository.getMilestone(milestone.id);
      expect(updatedMilestone!.isCompleted, false);
      expect(updatedMilestone.completedAt, isNull);
    });

    test('deleteMilestone removes a milestone', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      final milestone = await createTestMilestone(
        goalId: goal.id,
        title: 'Test Milestone',
      );
      final notifier = container.read(milestoneNotifierProvider.notifier);

      await notifier.deleteMilestone(milestone.id, goal.id);

      final milestones = await container.read(milestonesForGoalProvider(goal.id).future);
      expect(milestones, isEmpty);
    });

    test('reorderMilestones updates order correctly', () async {
      final goal = await createTestGoal(title: 'Test Goal');
      final m1 = await createTestMilestone(goalId: goal.id, title: 'First', orderIndex: 0);
      final m2 = await createTestMilestone(goalId: goal.id, title: 'Second', orderIndex: 1);
      final m3 = await createTestMilestone(goalId: goal.id, title: 'Third', orderIndex: 2);
      final notifier = container.read(milestoneNotifierProvider.notifier);

      // Reorder: move first to last
      await notifier.reorderMilestones([m2, m3, m1], goal.id);

      final milestones = await container.read(milestonesForGoalProvider(goal.id).future);
      expect(milestones[0].title, 'Second');
      expect(milestones[0].orderIndex, 0);
      expect(milestones[1].title, 'Third');
      expect(milestones[1].orderIndex, 1);
      expect(milestones[2].title, 'First');
      expect(milestones[2].orderIndex, 2);
    });
  });
}
