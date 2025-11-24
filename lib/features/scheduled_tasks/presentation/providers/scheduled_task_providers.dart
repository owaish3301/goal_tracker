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
        print(
          '📅 Schedule already exists for ${date.toIso8601String().split('T')[0]}',
        );
        return existing;
      }

      // Generate new schedule
      print(
        '🚀 Generating schedule for ${date.toIso8601String().split('T')[0]}',
      );
      final tasks = await hybridScheduler.scheduleForDate(date);

      // Save to database
      for (final task in tasks) {
        await repo.createScheduledTask(task);
      }

      return tasks;
    });

/// Provider to check if schedule needs generation (on app launch)
final autoGenerateScheduleProvider = FutureProvider<void>((ref) async {
  final today = DateTime.now();
  final normalizedToday = DateTime(today.year, today.month, today.day);

  // Trigger generation for today (will skip if already exists)
  await ref.watch(generateScheduleProvider(normalizedToday).future);

  print('✅ Auto-generation check complete');
});
