import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/timeline_item.dart';
import '../../../one_time_tasks/presentation/providers/one_time_task_provider.dart';
import '../../../scheduled_tasks/presentation/providers/scheduled_task_providers.dart';

/// Provider that merges OneTimeTasks and ScheduledTasks into a unified timeline
final unifiedTimelineProvider =
    FutureProvider.family<List<TimelineItem>, DateTime>((ref, date) async {
      // Get both types of tasks
      final oneTimeTasks = await ref.watch(tasksForDateProvider(date).future);
      final scheduledTasks = await ref.watch(
        scheduledTasksForDateProvider(date).future,
      );

      // Convert to TimelineItems
      final timelineItems = <TimelineItem>[
        ...oneTimeTasks.map((task) => TimelineItem.fromOneTimeTask(task)),
        ...scheduledTasks.map((task) => TimelineItem.fromScheduledTask(task)),
      ];

      // Sort by scheduled time
      timelineItems.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

      return timelineItems;
    });
