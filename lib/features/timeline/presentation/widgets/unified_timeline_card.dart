import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/one_time_task.dart';
import '../../../../core/theme/app_colors.dart';
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
          onToggleComplete: canComplete
              ? () async {
                  // Haptic feedback for better UX
                  HapticFeedback.lightImpact();

                  // Toggle the one-time task completion
                  final notifier = ref.read(
                    oneTimeTaskNotifierProvider.notifier,
                  );
                  await notifier.toggleComplete(task.id);

                  // Notify parent to refresh
                  onCompleted?.call();
                }
              : null,
          onDelete: () async {
            // Haptic feedback for delete
            HapticFeedback.mediumImpact();

            // Delete the task
            final notifier = ref.read(oneTimeTaskNotifierProvider.notifier);
            await notifier.deleteTask(task.id);

            // Notify parent to refresh
            onCompleted?.call();
          },
        );
      case TimelineItemType.scheduled:
        return ScheduledTaskCard(
          task: item.asScheduledTask!,
          onCompleted: onCompleted,
        );
      case TimelineItemType.preview:
        return _GoalPreviewCard(item: item);
    }
  }
}

/// Card for previewing goals on future dates (no time assigned yet)
class _GoalPreviewCard extends StatelessWidget {
  final TimelineItem item;

  const _GoalPreviewCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final goal = item.asGoal!;
    final goalColor = Color(int.parse(goal.colorHex.replaceFirst('#', '0xFF')));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: goalColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: goalColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            // Goal info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Duration and preview indicator
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${goal.targetDuration} min',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Preview badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: 12,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Preview',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
