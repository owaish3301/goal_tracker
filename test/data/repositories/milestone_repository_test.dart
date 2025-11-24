import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/data/models/task.dart';
import 'package:goal_tracker/data/models/one_time_task.dart';
import 'package:goal_tracker/data/models/productivity_data.dart';
import 'package:goal_tracker/data/models/app_settings.dart';
import 'package:goal_tracker/data/repositories/milestone_repository.dart';

void main() {
  late Isar isar;
  late MilestoneRepository milestoneRepository;

  setUp(() async {
    isar = await Isar.open(
      [
        GoalSchema,
        MilestoneSchema,
        TaskSchema,
        OneTimeTaskSchema,
        ProductivityDataSchema,
        AppSettingsSchema,
      ],
      directory: '',
      name: 'test_milestone_tracker',
    );

    milestoneRepository = MilestoneRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('MilestoneRepository', () {
    test('createMilestone should create milestone linked to goal', () async {
      final goal = Goal()
        ..title = 'Learn Java'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 180
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });

      final milestone = Milestone()
        ..title = 'Chapter 1: Variables'
        ..orderIndex = 0
        ..isCompleted = false;

      final id = await milestoneRepository.createMilestone(milestone, goal.id);

      expect(id, greaterThan(0));

      final retrieved = await milestoneRepository.getMilestone(id);
      await retrieved!.goal.load();

      expect(retrieved.goal.value, isNotNull);
      expect(retrieved.goal.value!.title, 'Learn Java');
    });

    test('getMilestonesForGoal should return milestones in order', () async {
      final goal = Goal()
        ..title = 'Learn Java'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 180
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });

      final milestone1 = Milestone()
        ..title = 'Chapter 1'
        ..orderIndex = 0
        ..isCompleted = false;

      final milestone2 = Milestone()
        ..title = 'Chapter 2'
        ..orderIndex = 1
        ..isCompleted = false;

      final milestone3 = Milestone()
        ..title = 'Chapter 3'
        ..orderIndex = 2
        ..isCompleted = false;

      await milestoneRepository.createMilestone(milestone1, goal.id);
      await milestoneRepository.createMilestone(milestone2, goal.id);
      await milestoneRepository.createMilestone(milestone3, goal.id);

      final milestones = await milestoneRepository.getMilestonesForGoal(
        goal.id,
      );

      expect(milestones.length, 3);
      expect(milestones[0].title, 'Chapter 1');
      expect(milestones[1].title, 'Chapter 2');
      expect(milestones[2].title, 'Chapter 3');
    });

    test('markAsCompleted should update milestone completion status', () async {
      final goal = Goal()
        ..title = 'Learn Java'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 180
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });

      final milestone = Milestone()
        ..title = 'Chapter 1'
        ..orderIndex = 0
        ..isCompleted = false;

      final id = await milestoneRepository.createMilestone(milestone, goal.id);

      await milestoneRepository.markAsCompleted(id);

      final completed = await milestoneRepository.getMilestone(id);

      expect(completed!.isCompleted, true);
      expect(completed.completedAt, isNotNull);
    });

    test(
      'getCompletedMilestones should return only completed milestones',
      () async {
        final goal = Goal()
          ..title = 'Learn Java'
          ..frequency = [0, 1, 2, 3, 4]
          ..targetDuration = 180
          ..priorityIndex = 0
          ..colorHex = '#4CAF50'
          ..iconName = 'code'
          ..createdAt = DateTime.now()
          ..isActive = true;

        await isar.writeTxn(() async {
          await isar.goals.put(goal);
        });

        final milestone1 = Milestone()
          ..title = 'Chapter 1'
          ..orderIndex = 0
          ..isCompleted = true
          ..completedAt = DateTime.now();

        final milestone2 = Milestone()
          ..title = 'Chapter 2'
          ..orderIndex = 1
          ..isCompleted = false;

        await milestoneRepository.createMilestone(milestone1, goal.id);
        await milestoneRepository.createMilestone(milestone2, goal.id);

        final completed = await milestoneRepository.getCompletedMilestones(
          goal.id,
        );

        expect(completed.length, 1);
        expect(completed.first.title, 'Chapter 1');
      },
    );

    test('reorderMilestones should update order indexes', () async {
      final goal = Goal()
        ..title = 'Learn Java'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 180
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });

      final milestone1 = Milestone()
        ..title = 'Chapter 1'
        ..orderIndex = 0
        ..isCompleted = false;

      final milestone2 = Milestone()
        ..title = 'Chapter 2'
        ..orderIndex = 1
        ..isCompleted = false;

      await milestoneRepository.createMilestone(milestone1, goal.id);
      await milestoneRepository.createMilestone(milestone2, goal.id);

      // Swap order
      await milestoneRepository.reorderMilestones([milestone2, milestone1]);

      final milestones = await milestoneRepository.getMilestonesForGoal(
        goal.id,
      );

      expect(milestones[0].title, 'Chapter 2');
      expect(milestones[0].orderIndex, 0);
      expect(milestones[1].title, 'Chapter 1');
      expect(milestones[1].orderIndex, 1);
    });
  });
}
