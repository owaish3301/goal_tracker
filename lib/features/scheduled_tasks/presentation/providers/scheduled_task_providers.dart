import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/scheduled_task.dart';
import '../../../../core/providers/scheduler_providers.dart';
import '../../../../core/services/database_service.dart';

/// Provider to get scheduled tasks for a specific date
final scheduledTasksForDateProvider =
    FutureProvider.family<List<ScheduledTask>, DateTime>((ref, date) async {
      final repo = ref.watch(scheduledTaskRepositoryProvider);
      return await repo.getScheduledTasksForDate(date);
    });

/// Provider to trigger schedule generation for a date
final generateScheduleProvider =
    FutureProvider.family<List<ScheduledTask>, DateTime>((ref, date) async {
      final hybridScheduler = ref.watch(hybridSchedulerProvider);
      final repo = ref.watch(scheduledTaskRepositoryProvider);

      // Check if schedule already exists for this date
      final existing = await repo.getScheduledTasksForDate(date);
      if (existing.isNotEmpty) {
        return existing;
      }

      // Generate new schedule
      final tasks = await hybridScheduler.scheduleForDate(date);

      // Save to database, checking for duplicates before each save
      // This handles race conditions where multiple callers try to generate simultaneously
      final savedTasks = <ScheduledTask>[];
      for (final task in tasks) {
        // Check if task for this goal already exists (could have been created by another caller)
        final existingForGoal = await repo.getTaskForGoalOnDate(task.goalId, date);
        if (existingForGoal == null) {
          await repo.createScheduledTask(task);
          savedTasks.add(task);
        } else {
          savedTasks.add(existingForGoal);
        }
      }

      return savedTasks;
    });

/// Provider to check if schedule needs generation (on app launch)
final autoGenerateScheduleProvider = FutureProvider<void>((ref) async {
  final today = DateTime.now();
  final normalizedToday = DateTime(today.year, today.month, today.day);
  
  // First, clean up any duplicate tasks from previous bugs
  final repo = ref.watch(scheduledTaskRepositoryProvider);
  final duplicatesRemoved = await repo.removeDuplicateTasks();
  if (duplicatesRemoved > 0) {
  }

  // Trigger generation for today (will skip if already exists)
  await ref.watch(generateScheduleProvider(normalizedToday).future);

});
