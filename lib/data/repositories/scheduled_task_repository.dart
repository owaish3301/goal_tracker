import 'package:isar/isar.dart';
import '../models/scheduled_task.dart';

class ScheduledTaskRepository {
  final Isar isar;

  ScheduledTaskRepository(this.isar);

  // Create a new scheduled task
  // By default this allows duplicates (preserves existing test behavior).
  // When called with `allowDuplicates: false` the method will perform an
  // existence check inside the same Isar write transaction to avoid
  // race-conditions that create duplicate tasks for the same goal+date.
  Future<int> createScheduledTask(ScheduledTask task, {bool allowDuplicates = true}) async {
    if (!allowDuplicates) {
      return await isar.writeTxn(() async {
        final existing = await getTaskForGoalOnDate(task.goalId, task.scheduledDate);
        if (existing != null) {
          return existing.id;
        }
        return await isar.scheduledTasks.put(task);
      });
    }

    return await isar.writeTxn(() async {
      return await isar.scheduledTasks.put(task);
    });
  }

  // Get a scheduled task by ID
  Future<ScheduledTask?> getScheduledTask(int id) async {
    return await isar.scheduledTasks.get(id);
  }

  // Get all scheduled tasks for a specific date
  Future<List<ScheduledTask>> getScheduledTasksForDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    return await isar.scheduledTasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .sortByScheduledStartTime()
        .findAll();
  }

  // Get all scheduled tasks for a specific goal
  Future<List<ScheduledTask>> getScheduledTasksByGoal(int goalId) async {
    return await isar.scheduledTasks
        .filter()
        .goalIdEqualTo(goalId)
        .sortByScheduledDate()
        .findAll();
  }

  // Get all pending (incomplete) scheduled tasks
  Future<List<ScheduledTask>> getAllPendingScheduledTasks() async {
    return await isar.scheduledTasks
        .filter()
        .isCompletedEqualTo(false)
        .sortByScheduledStartTime()
        .findAll();
  }

  // Get all completed scheduled tasks
  Future<List<ScheduledTask>> getAllCompletedScheduledTasks() async {
    return await isar.scheduledTasks
        .filter()
        .isCompletedEqualTo(true)
        .sortByCompletedAt()
        .findAll();
  }

  // Get tasks scheduled by ML vs rule-based
  Future<List<ScheduledTask>> getTasksBySchedulingMethod(String method) async {
    return await isar.scheduledTasks
        .filter()
        .schedulingMethodEqualTo(method)
        .findAll();
  }

  // Get tasks that were rescheduled (important for ML learning)
  Future<List<ScheduledTask>> getRescheduledTasks() async {
    return await isar.scheduledTasks
        .filter()
        .wasRescheduledEqualTo(true)
        .findAll();
  }

  // Update a scheduled task
  Future<void> updateScheduledTask(ScheduledTask task) async {
    await isar.writeTxn(() async {
      await isar.scheduledTasks.put(task);
    });
  }

  // Mark task as completed with productivity data
  Future<void> markAsCompleted(
    int taskId, {
    required DateTime actualStartTime,
    required int actualDuration,
    required int productivityRating,
    String? notes,
    bool? milestoneCompleted,
  }) async {
    await isar.writeTxn(() async {
      final task = await isar.scheduledTasks.get(taskId);
      if (task != null) {
        task.isCompleted = true;
        task.completedAt = DateTime.now();
        task.actualStartTime = actualStartTime;
        task.actualDuration = actualDuration;
        task.productivityRating = productivityRating;
        task.completionNotes = notes;
        task.milestoneCompleted = milestoneCompleted;
        await isar.scheduledTasks.put(task);
      }
    });
  }

  // Mark task as incomplete (undo completion)
  Future<void> markAsIncomplete(int taskId) async {
    await isar.writeTxn(() async {
      final task = await isar.scheduledTasks.get(taskId);
      if (task != null) {
        task.isCompleted = false;
        task.completedAt = null;
        task.actualStartTime = null;
        task.actualDuration = null;
        task.productivityRating = null;
        task.completionNotes = null;
        task.milestoneCompleted = null;
        await isar.scheduledTasks.put(task);
      }
    });
  }

  // Record a reschedule (important for ML learning!)
  Future<void> recordReschedule(int taskId, DateTime newTime) async {
    await isar.writeTxn(() async {
      final task = await isar.scheduledTasks.get(taskId);
      if (task != null) {
        task.wasRescheduled = true;
        task.rescheduledTo = newTime;
        task.rescheduleCount++;
        task.scheduledStartTime = newTime;
        await isar.scheduledTasks.put(task);
      }
    });
  }

  // Delete a scheduled task
  Future<bool> deleteScheduledTask(int id) async {
    return await isar.writeTxn(() async {
      return await isar.scheduledTasks.delete(id);
    });
  }

  // Delete all scheduled tasks for a specific date (for regeneration)
  Future<int> deleteScheduledTasksForDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    return await isar.writeTxn(() async {
      final tasks = await isar.scheduledTasks
          .filter()
          .scheduledDateEqualTo(normalizedDate)
          .findAll();

      final ids = tasks.map((t) => t.id).toList();
      return await isar.scheduledTasks.deleteAll(ids);
    });
  }

  // Delete all auto-generated tasks for a date (keep manual ones AND rescheduled ones)
  Future<int> deleteAutoGeneratedTasksForDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    return await isar.writeTxn(() async {
      final tasks = await isar.scheduledTasks
          .filter()
          .scheduledDateEqualTo(normalizedDate)
          .isAutoGeneratedEqualTo(true)
          .wasRescheduledEqualTo(false) // Don't delete rescheduled tasks!
          .findAll();

      final ids = tasks.map((t) => t.id).toList();
      return await isar.scheduledTasks.deleteAll(ids);
    });
  }
  
  // Get existing scheduled task for a goal on a date (to check if already scheduled)
  Future<ScheduledTask?> getTaskForGoalOnDate(int goalId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return await isar.scheduledTasks
        .filter()
        .goalIdEqualTo(goalId)
        .scheduledDateEqualTo(normalizedDate)
        .findFirst();
  }
  
  // Get all rescheduled tasks for a date (to treat as blockers)
  Future<List<ScheduledTask>> getRescheduledTasksForDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return await isar.scheduledTasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .wasRescheduledEqualTo(true)
        .findAll();
  }

  // Delete all scheduled tasks for a specific goal (when goal is deleted)
  Future<int> deleteScheduledTasksByGoal(int goalId) async {
    return await isar.writeTxn(() async {
      final tasks = await isar.scheduledTasks
          .filter()
          .goalIdEqualTo(goalId)
          .findAll();

      final ids = tasks.map((t) => t.id).toList();
      return await isar.scheduledTasks.deleteAll(ids);
    });
  }

  // Get tasks needing feedback (completed but no productivity rating)
  Future<List<ScheduledTask>> getTasksNeedingFeedback() async {
    return await isar.scheduledTasks
        .filter()
        .isCompletedEqualTo(true)
        .productivityRatingIsNull()
        .findAll();
  }

  // Get count of tasks for a date
  Future<int> getTaskCountForDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    return await isar.scheduledTasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .count();
  }

  // Get ML performance metrics
  Future<Map<String, dynamic>> getMLPerformanceMetrics() async {
    final allTasks = await isar.scheduledTasks.where().findAll();

    final mlTasks = allTasks
        .where((t) => t.schedulingMethod == 'ml-based')
        .toList();
    final ruleTasks = allTasks
        .where((t) => t.schedulingMethod == 'rule-based')
        .toList();

    final mlRescheduled = mlTasks.where((t) => t.wasRescheduled).length;
    final ruleRescheduled = ruleTasks.where((t) => t.wasRescheduled).length;

    return {
      'total_tasks': allTasks.length,
      'ml_tasks': mlTasks.length,
      'rule_tasks': ruleTasks.length,
      'ml_reschedule_rate': mlTasks.isEmpty
          ? 0.0
          : mlRescheduled / mlTasks.length,
      'rule_reschedule_rate': ruleTasks.isEmpty
          ? 0.0
          : ruleRescheduled / ruleTasks.length,
    };
  }

  // Stream of tasks for a date (for real-time updates)
  Stream<List<ScheduledTask>> watchTasksForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    return isar.scheduledTasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .watch(fireImmediately: true);
  }

  /// Remove duplicate tasks for the same goal on the same date
  /// Keeps the first task (usually rescheduled or completed) and removes others
  Future<int> removeDuplicateTasks() async {
    return await isar.writeTxn(() async {
      final allTasks = await isar.scheduledTasks.where().findAll();
      
      // Group by goalId + date
      final Map<String, List<ScheduledTask>> grouped = {};
      for (final task in allTasks) {
        final key = '${task.goalId}_${task.scheduledDate.toIso8601String().split('T')[0]}';
        grouped.putIfAbsent(key, () => []).add(task);
      }
      
      // Find duplicates
      final idsToDelete = <int>[];
      for (final tasks in grouped.values) {
        if (tasks.length > 1) {
          // Sort: keep completed/rescheduled first, then by ID (oldest)
          tasks.sort((a, b) {
            // Prioritize completed tasks
            if (a.isCompleted != b.isCompleted) {
              return a.isCompleted ? -1 : 1;
            }
            // Then prioritize rescheduled tasks
            if (a.wasRescheduled != b.wasRescheduled) {
              return a.wasRescheduled ? -1 : 1;
            }
            // Otherwise keep the oldest (lowest ID)
            return a.id.compareTo(b.id);
          });
          
          // Keep the first, delete the rest
          for (int i = 1; i < tasks.length; i++) {
            idsToDelete.add(tasks[i].id);
          }
        }
      }
      
      if (idsToDelete.isNotEmpty) {
        await isar.scheduledTasks.deleteAll(idsToDelete);
      }
      
      return idsToDelete.length;
    });
  }
}
