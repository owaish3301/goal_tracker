import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/data/models/task.dart';
import 'package:goal_tracker/data/models/one_time_task.dart';
import 'package:goal_tracker/data/models/productivity_data.dart';
import 'package:goal_tracker/data/models/app_settings.dart';
import 'package:goal_tracker/data/repositories/goal_repository.dart';

void main() {
  late Isar isar;
  late GoalRepository goalRepository;

  setUp(() async {
    // Initialize in-memory Isar instance for testing
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
      name: 'test_goal_tracker',
    );

    goalRepository = GoalRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('GoalRepository', () {
    test('createGoal should create a new goal', () async {
      final goal = Goal()
        ..title = 'Learn Flutter'
        ..frequency =
            [0, 1, 2, 3, 4] // Mon-Fri
        ..targetDuration = 120
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      final id = await goalRepository.createGoal(goal);

      expect(id, greaterThan(0));
      expect(goal.id, id);
    });

    test('getGoal should retrieve a goal by id', () async {
      final goal = Goal()
        ..title = 'Gym'
        ..frequency =
            [0, 2, 4] // Mon, Wed, Fri
        ..targetDuration = 60
        ..priorityIndex = 1
        ..colorHex = '#FF5733'
        ..iconName = 'fitness_center'
        ..createdAt = DateTime.now()
        ..isActive = true;

      final id = await goalRepository.createGoal(goal);
      final retrievedGoal = await goalRepository.getGoal(id);

      expect(retrievedGoal, isNotNull);
      expect(retrievedGoal!.title, 'Gym');
      expect(retrievedGoal.frequency, [0, 2, 4]);
      expect(retrievedGoal.targetDuration, 60);
    });

    test('getAllGoals should return all goals', () async {
      final goal1 = Goal()
        ..title = 'Goal 1'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 60
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      final goal2 = Goal()
        ..title = 'Goal 2'
        ..frequency = [0, 2, 4]
        ..targetDuration = 90
        ..priorityIndex = 1
        ..colorHex = '#FF5733'
        ..iconName = 'book'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await goalRepository.createGoal(goal1);
      await goalRepository.createGoal(goal2);

      final goals = await goalRepository.getAllGoals();

      expect(goals.length, 2);
    });

    test('getActiveGoals should return only active goals', () async {
      final activeGoal = Goal()
        ..title = 'Active Goal'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 60
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      final inactiveGoal = Goal()
        ..title = 'Inactive Goal'
        ..frequency = [0, 2, 4]
        ..targetDuration = 90
        ..priorityIndex = 1
        ..colorHex = '#FF5733'
        ..iconName = 'book'
        ..createdAt = DateTime.now()
        ..isActive = false;

      await goalRepository.createGoal(activeGoal);
      await goalRepository.createGoal(inactiveGoal);

      final activeGoals = await goalRepository.getActiveGoals();

      expect(activeGoals.length, 1);
      expect(activeGoals.first.title, 'Active Goal');
    });

    test('getGoalsForDay should return goals for specific day', () async {
      final mondayGoal = Goal()
        ..title = 'Monday Goal'
        ..frequency =
            [0] // Monday only
        ..targetDuration = 60
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      final weekdayGoal = Goal()
        ..title = 'Weekday Goal'
        ..frequency =
            [0, 1, 2, 3, 4] // Mon-Fri
        ..targetDuration = 90
        ..priorityIndex = 1
        ..colorHex = '#FF5733'
        ..iconName = 'book'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await goalRepository.createGoal(mondayGoal);
      await goalRepository.createGoal(weekdayGoal);

      final mondayGoals = await goalRepository.getGoalsForDay(0); // Monday

      expect(mondayGoals.length, 2);
    });

    test('updateGoal should update goal fields', () async {
      final goal = Goal()
        ..title = 'Original Title'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 60
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      final id = await goalRepository.createGoal(goal);

      goal.title = 'Updated Title';
      goal.targetDuration = 120;
      await goalRepository.updateGoal(goal);

      final updatedGoal = await goalRepository.getGoal(id);

      expect(updatedGoal!.title, 'Updated Title');
      expect(updatedGoal.targetDuration, 120);
      expect(updatedGoal.updatedAt, isNotNull);
    });

    test('deleteGoal should remove goal from database', () async {
      final goal = Goal()
        ..title = 'To Delete'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 60
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      final id = await goalRepository.createGoal(goal);
      final deleted = await goalRepository.deleteGoal(id);

      expect(deleted, true);

      final retrievedGoal = await goalRepository.getGoal(id);
      expect(retrievedGoal, isNull);
    });

    test('updatePriorityIndexes should reorder goals', () async {
      final goal1 = Goal()
        ..title = 'Goal 1'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 60
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      final goal2 = Goal()
        ..title = 'Goal 2'
        ..frequency = [0, 2, 4]
        ..targetDuration = 90
        ..priorityIndex = 1
        ..colorHex = '#FF5733'
        ..iconName = 'book'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await goalRepository.createGoal(goal1);
      await goalRepository.createGoal(goal2);

      // Swap priorities
      await goalRepository.updatePriorityIndexes([goal2, goal1]);

      final goals = await goalRepository.getGoalsByPriority();

      expect(goals.first.title, 'Goal 2');
      expect(goals.first.priorityIndex, 0);
      expect(goals.last.title, 'Goal 1');
      expect(goals.last.priorityIndex, 1);
    });

    test('getGoalCount should return total count', () async {
      final goal1 = Goal()
        ..title = 'Goal 1'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 60
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      final goal2 = Goal()
        ..title = 'Goal 2'
        ..frequency = [0, 2, 4]
        ..targetDuration = 90
        ..priorityIndex = 1
        ..colorHex = '#FF5733'
        ..iconName = 'book'
        ..createdAt = DateTime.now()
        ..isActive = false;

      await goalRepository.createGoal(goal1);
      await goalRepository.createGoal(goal2);

      final totalCount = await goalRepository.getGoalCount();
      final activeCount = await goalRepository.getActiveGoalCount();

      expect(totalCount, 2);
      expect(activeCount, 1);
    });
  });
}
