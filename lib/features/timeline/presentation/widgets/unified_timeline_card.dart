import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/timeline_item.dart';
import '../../../one_time_tasks/presentation/widgets/one_time_task_card.dart';
import '../../../one_time_tasks/presentation/providers/one_time_task_provider.dart';
import '../../../scheduled_tasks/presentation/widgets/scheduled_task_card.dart';

/// Unified card that displays either a OneTimeTask or ScheduledTask
class UnifiedTimelineCard extends ConsumerWidget {
  final TimelineItem item;
  final VoidCallback? onCompleted;

  const UnifiedTimelineCard({super.key, required this.item, this.onCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Delegate to the appropriate card widget
    switch (item.type) {
      case TimelineItemType.oneTime:
        return OneTimeTaskCard(
          task: item.asOneTimeTask!,
          onToggleComplete: () async {
            // Haptic feedback for better UX
            HapticFeedback.lightImpact();

            print(
              '🔘 OneTimeTask toggle tapped for task: ${item.asOneTimeTask!.id}',
            );

            // Toggle the one-time task completion
            final notifier = ref.read(oneTimeTaskNotifierProvider.notifier);
            await notifier.toggleComplete(item.asOneTimeTask!.id);

            print('✅ OneTimeTask toggled successfully');

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
