import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/timeline_item.dart';
import '../../../one_time_tasks/presentation/providers/one_time_task_provider.dart';
import '../../../scheduled_tasks/presentation/providers/scheduled_task_providers.dart';
import '../../../goals/presentation/providers/goal_provider.dart';

/// Provider that merges OneTimeTasks and ScheduledTasks into a unified timeline
/// For dates without schedules (including today), shows goal previews (names only, no times)
final unifiedTimelineProvider =
    FutureProvider.family<List<TimelineItem>, DateTime>((ref, date) async {
      // Normalize the date
      final normalizedDate = DateTime(date.year, date.month, date.day);

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

      // For any date with no scheduled tasks, show goal previews as fallback
      // This ensures users see their goals even if schedule generation failed
      if (scheduledTasks.isEmpty) {
        final goals = await ref.watch(goalsProvider.future);
        
        // Filter goals active on this day
        final dayOfWeek = normalizedDate.weekday; // 1=Monday, 7=Sunday
        final frequencyIndex = dayOfWeek - 1; // Convert to 0=Monday, 6=Sunday
        
        final goalsForDate = goals.where((goal) {
          final isActiveOnDay = goal.frequency.contains(frequencyIndex);
          final createdDate = DateTime(
            goal.createdAt.year,
            goal.createdAt.month,
            goal.createdAt.day,
          );
          final isCreatedBeforeOrOn = !normalizedDate.isBefore(createdDate);
          return goal.isActive && isActiveOnDay && isCreatedBeforeOrOn;
        }).toList();

        // Add goal previews (sorted by priority)
        goalsForDate.sort((a, b) => a.priorityIndex.compareTo(b.priorityIndex));
        for (final goal in goalsForDate) {
          timelineItems.add(TimelineItem.fromGoalPreview(goal));
        }
      }

      // Sort scheduled items by time (previews go at the end since they have no specific time)
      timelineItems.sort((a, b) {
        // Previews should be sorted by priority, after scheduled items
        if (a.type == TimelineItemType.preview && b.type == TimelineItemType.preview) {
          return 0; // Already sorted by priority above
        }
        if (a.type == TimelineItemType.preview) return 1; // Previews go after
        if (b.type == TimelineItemType.preview) return -1;
        return a.scheduledTime.compareTo(b.scheduledTime);
      });

      return timelineItems;
    });
