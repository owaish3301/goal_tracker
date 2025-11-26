import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/one_time_task.dart';
import '../../domain/timeline_item.dart';
import '../../../one_time_tasks/presentation/widgets/one_time_task_card.dart';
import '../../../one_time_tasks/presentation/providers/one_time_task_provider.dart';
import '../../../scheduled_tasks/presentation/widgets/scheduled_task_card.dart';

/// Unified card that displays either a OneTimeTask or ScheduledTask
class UnifiedTimelineCard extends ConsumerWidget {
  final TimelineItem item;
  final VoidCallback? onCompleted;

  const UnifiedTimelineCard({super.key, required this.item, this.onCompleted});

  /// Check if a one-time task can be completed (only today's tasks)
  bool _canCompleteOneTimeTask(OneTimeTask task) {
    if (task.isCompleted) return false;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(
      task.scheduledDate.year,
      task.scheduledDate.month,
      task.scheduledDate.day,
    );
    
    // Only allow completing today's tasks
    return taskDate.isAtSameMomentAs(today);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Delegate to the appropriate card widget
    switch (item.type) {
      case TimelineItemType.oneTime:
        final task = item.asOneTimeTask!;
        final canComplete = _canCompleteOneTimeTask(task);
        
        return OneTimeTaskCard(
          task: task,
          onToggleComplete: canComplete ? () async {
            // Haptic feedback for better UX
            HapticFeedback.lightImpact();

            print(
              '🔘 OneTimeTask toggle tapped for task: ${task.id}',
            );

            // Toggle the one-time task completion
            final notifier = ref.read(oneTimeTaskNotifierProvider.notifier);
            await notifier.toggleComplete(task.id);

            print('✅ OneTimeTask toggled successfully');

            // Notify parent to refresh
            onCompleted?.call();
          } : null,
          onDelete: () async {
            // Haptic feedback for delete
            HapticFeedback.mediumImpact();

            print('🗑️ Deleting one-time task: ${task.id}');

            // Delete the task
            final notifier = ref.read(oneTimeTaskNotifierProvider.notifier);
            await notifier.deleteTask(task.id);

            print('✅ OneTimeTask deleted successfully');

            // Notify parent to refresh
            onCompleted?.call();
          },
        );
      case TimelineItemType.scheduled:
        return ScheduledTaskCard(
          task: item.asScheduledTask!,
          onCompleted: onCompleted,
        );
    }
  }
}
