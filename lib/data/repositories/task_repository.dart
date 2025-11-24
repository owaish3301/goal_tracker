import 'package:isar/isar.dart';
import '../models/task.dart';
import '../models/goal.dart';
import '../models/milestone.dart';

class TaskRepository {
  final Isar isar;

  TaskRepository(this.isar);

  // Create
  Future<int> createTask(Task task, int goalId, {int? milestoneId}) async {
    return await isar.writeTxn(() async {
      final goal = await isar.goals.get(goalId);
      if (goal != null) {
        task.goal.value = goal;
        await task.goal.save();
      }

      if (milestoneId != null) {
        final milestone = await isar.milestones.get(milestoneId);
        if (milestone != null) {
          task.completedMilestone.value = milestone;
          await task.completedMilestone.save();
        }
      }

      return await isar.tasks.put(task);
    });
  }

  // Read
  Future<Task?> getTask(int id) async {
    return await isar.tasks.get(id);
  }

  Future<List<Task>> getTasksForDate(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.tasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .sortByScheduledStartTime()
        .findAll();
  }

  Future<List<Task>> getPendingTasks(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.tasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .statusEqualTo(TaskStatus.pending)
        .sortByScheduledStartTime()
        .findAll();
  }

  Future<List<Task>> getCompletedTasks(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.tasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .statusEqualTo(TaskStatus.completed)
        .sortByScheduledStartTime()
        .findAll();
  }

  Future<List<Task>> getTasksForGoal(int goalId) async {
    final goal = await isar.goals.get(goalId);
    if (goal == null) return [];

    await goal.tasks.load();
    return goal.tasks.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Update
  Future<void> updateTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }

  Future<void> updateTaskStatus(int id, TaskStatus status) async {
    final task = await getTask(id);
    if (task != null) {
      task.status = status;
      if (status == TaskStatus.completed) {
        task.completedAt = DateTime.now();
      }
      await updateTask(task);
    }
  }

  Future<void> recordCompletion({
    required int taskId,
    required DateTime actualStartTime,
    required int actualDuration,
    required double productivityScore,
    String? notes,
    int? completedMilestoneId,
  }) async {
    final task = await getTask(taskId);
    if (task != null) {
      await isar.writeTxn(() async {
        task.status = TaskStatus.completed;
        task.actualStartTime = actualStartTime;
        task.actualDuration = actualDuration;
        task.productivityScore = productivityScore;
        task.notes = notes;
        task.completedAt = DateTime.now();

        if (completedMilestoneId != null) {
          final milestone = await isar.milestones.get(completedMilestoneId);
          if (milestone != null) {
            task.completedMilestone.value = milestone;
            await task.completedMilestone.save();
          }
        }

        await isar.tasks.put(task);
      });
    }
  }

  Future<void> rescheduleTask({
    required int taskId,
    required DateTime newStartTime,
  }) async {
    final task = await getTask(taskId);
    if (task != null) {
      task.wasManuallyRescheduled = true;
      task.originalScheduledTime = task.scheduledStartTime;
      task.scheduledStartTime = newStartTime;
      task.scheduledDate = _normalizeDate(newStartTime);
      task.status = TaskStatus.rescheduled;
      await updateTask(task);
    }
  }

  // Delete
  Future<bool> deleteTask(int id) async {
    return await isar.writeTxn(() async {
      return await isar.tasks.delete(id);
    });
  }

  Future<void> deleteTasksForDate(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    final tasks = await isar.tasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .findAll();

    await isar.writeTxn(() async {
      await isar.tasks.deleteAll(tasks.map((t) => t.id).toList());
    });
  }

  // Count
  Future<int> getTaskCount(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.tasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .count();
  }

  Future<int> getCompletedTaskCount(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.tasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .statusEqualTo(TaskStatus.completed)
        .count();
  }

  // Helper
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
