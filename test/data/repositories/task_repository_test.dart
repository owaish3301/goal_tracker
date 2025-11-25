import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/data/models/task.dart';
import 'package:goal_tracker/data/models/one_time_task.dart';
import 'package:goal_tracker/data/models/scheduled_task.dart';
import 'package:goal_tracker/data/models/productivity_data.dart';
import 'package:goal_tracker/data/models/app_settings.dart';
import 'package:goal_tracker/data/repositories/task_repository.dart';

void main() {
  late Isar isar;
  late TaskRepository taskRepository;

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
        AppSettingsSchema,
      ],
      directory: '',
      name: 'test_task_${DateTime.now().millisecondsSinceEpoch}',
    );

    taskRepository = TaskRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('TaskRepository', () {
    test('createTask should create a new task with goal link', () async {
      // Create a goal first
      final goal = Goal()
        ..title = 'Learn Flutter'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 120
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });

      final task = Task()
        ..scheduledDate = DateTime(2024, 1, 1)
        ..scheduledStartTime = DateTime(2024, 1, 1, 9, 0)
        ..scheduledDuration = 60
        ..status = TaskStatus.pending
        ..createdAt = DateTime.now()
        ..wasManuallyRescheduled = false;

      final id = await taskRepository.createTask(task, goal.id);

      expect(id, greaterThan(0));

      final retrievedTask = await taskRepository.getTask(id);
      await retrievedTask!.goal.load();

      expect(retrievedTask.goal.value, isNotNull);
      expect(retrievedTask.goal.value!.title, 'Learn Flutter');
    });

    test('getTasksForDate should return tasks for specific date', () async {
      final goal = Goal()
        ..title = 'Test Goal'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 120
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });

      final date = DateTime(2024, 1, 1);

      final task1 = Task()
        ..scheduledDate = date
        ..scheduledStartTime = DateTime(2024, 1, 1, 9, 0)
        ..scheduledDuration = 60
        ..status = TaskStatus.pending
        ..createdAt = DateTime.now()
        ..wasManuallyRescheduled = false;

      final task2 = Task()
        ..scheduledDate = date
        ..scheduledStartTime = DateTime(2024, 1, 1, 11, 0)
        ..scheduledDuration = 90
        ..status = TaskStatus.pending
        ..createdAt = DateTime.now()
        ..wasManuallyRescheduled = false;

      await taskRepository.createTask(task1, goal.id);
      await taskRepository.createTask(task2, goal.id);

      final tasks = await taskRepository.getTasksForDate(date);

      expect(tasks.length, 2);
      expect(tasks.first.scheduledStartTime.hour, 9);
      expect(tasks.last.scheduledStartTime.hour, 11);
    });

    test('recordCompletion should update task with completion data', () async {
      final goal = Goal()
        ..title = 'Test Goal'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 120
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });

      final task = Task()
        ..scheduledDate = DateTime(2024, 1, 1)
        ..scheduledStartTime = DateTime(2024, 1, 1, 9, 0)
        ..scheduledDuration = 60
        ..status = TaskStatus.pending
        ..createdAt = DateTime.now()
        ..wasManuallyRescheduled = false;

      final id = await taskRepository.createTask(task, goal.id);

      await taskRepository.recordCompletion(
        taskId: id,
        actualStartTime: DateTime(2024, 1, 1, 9, 5),
        actualDuration: 65,
        productivityScore: 4.5,
        notes: 'Great session!',
      );

      final completedTask = await taskRepository.getTask(id);

      expect(completedTask!.status, TaskStatus.completed);
      expect(completedTask.actualDuration, 65);
      expect(completedTask.productivityScore, 4.5);
      expect(completedTask.notes, 'Great session!');
      expect(completedTask.completedAt, isNotNull);
    });

    test(
      'rescheduleTask should update task time and mark as rescheduled',
      () async {
        final goal = Goal()
          ..title = 'Test Goal'
          ..frequency = [0, 1, 2, 3, 4]
          ..targetDuration = 120
          ..priorityIndex = 0
          ..colorHex = '#4CAF50'
          ..iconName = 'code'
          ..createdAt = DateTime.now()
          ..isActive = true;

        await isar.writeTxn(() async {
          await isar.goals.put(goal);
        });

        final originalTime = DateTime(2024, 1, 1, 9, 0);
        final task = Task()
          ..scheduledDate = DateTime(2024, 1, 1)
          ..scheduledStartTime = originalTime
          ..scheduledDuration = 60
          ..status = TaskStatus.pending
          ..createdAt = DateTime.now()
          ..wasManuallyRescheduled = false;

        final id = await taskRepository.createTask(task, goal.id);

        final newTime = DateTime(2024, 1, 1, 14, 0);
        await taskRepository.rescheduleTask(taskId: id, newStartTime: newTime);

        final rescheduledTask = await taskRepository.getTask(id);

        expect(rescheduledTask!.wasManuallyRescheduled, true);
        expect(rescheduledTask.originalScheduledTime, originalTime);
        expect(rescheduledTask.scheduledStartTime, newTime);
        expect(rescheduledTask.status, TaskStatus.rescheduled);
      },
    );

    test('getPendingTasks should return only pending tasks', () async {
      final goal = Goal()
        ..title = 'Test Goal'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 120
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });

      final date = DateTime(2024, 1, 1);

      final pendingTask = Task()
        ..scheduledDate = date
        ..scheduledStartTime = DateTime(2024, 1, 1, 9, 0)
        ..scheduledDuration = 60
        ..status = TaskStatus.pending
        ..createdAt = DateTime.now()
        ..wasManuallyRescheduled = false;

      final completedTask = Task()
        ..scheduledDate = date
        ..scheduledStartTime = DateTime(2024, 1, 1, 11, 0)
        ..scheduledDuration = 90
        ..status = TaskStatus.completed
        ..createdAt = DateTime.now()
        ..wasManuallyRescheduled = false;

      await taskRepository.createTask(pendingTask, goal.id);
      await taskRepository.createTask(completedTask, goal.id);

      final pending = await taskRepository.getPendingTasks(date);

      expect(pending.length, 1);
      expect(pending.first.status, TaskStatus.pending);
    });

    test('deleteTasksForDate should remove all tasks for a date', () async {
      final goal = Goal()
        ..title = 'Test Goal'
        ..frequency = [0, 1, 2, 3, 4]
        ..targetDuration = 120
        ..priorityIndex = 0
        ..colorHex = '#4CAF50'
        ..iconName = 'code'
        ..createdAt = DateTime.now()
        ..isActive = true;

      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });

      final date = DateTime(2024, 1, 1);

      final task1 = Task()
        ..scheduledDate = date
        ..scheduledStartTime = DateTime(2024, 1, 1, 9, 0)
        ..scheduledDuration = 60
        ..status = TaskStatus.pending
        ..createdAt = DateTime.now()
        ..wasManuallyRescheduled = false;

      final task2 = Task()
        ..scheduledDate = date
        ..scheduledStartTime = DateTime(2024, 1, 1, 11, 0)
        ..scheduledDuration = 90
        ..status = TaskStatus.pending
        ..createdAt = DateTime.now()
        ..wasManuallyRescheduled = false;

      await taskRepository.createTask(task1, goal.id);
      await taskRepository.createTask(task2, goal.id);

      await taskRepository.deleteTasksForDate(date);

      final tasks = await taskRepository.getTasksForDate(date);
      expect(tasks.length, 0);
    });
  });
}
