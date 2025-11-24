import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/scheduled_task.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/productivity_providers.dart';
import 'task_completion_modal.dart';

/// Card widget for displaying a scheduled task
class ScheduledTaskCard extends ConsumerWidget {
  final ScheduledTask task;
  final VoidCallback? onCompleted;

  const ScheduledTaskCard({super.key, required this.task, this.onCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskColor = Color(
      int.parse(task.colorHex?.replaceFirst('#', '0xFF') ?? '0xFFC6F432'),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: task.isCompleted
              ? AppColors.textSecondary.withValues(alpha: 0.3)
              : taskColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: task.isCompleted
              ? null
              : () => _showCompletionModal(context, ref),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Color indicator
                Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: taskColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),

                // Task info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Time and duration
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${task.scheduledStartTime.hour.toString().padLeft(2, '0')}:${task.scheduledStartTime.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.timer,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${task.duration}min',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // ML badge
                          if (task.schedulingMethod == 'ml-based')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.psychology,
                                    size: 12,
                                    color: AppColors.accent,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'ML',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accent,
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

                // Completion checkbox
                Checkbox(
                  value: task.isCompleted,
                  onChanged: task.isCompleted
                      ? null
                      : (_) => _showCompletionModal(context, ref),
                  activeColor: taskColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCompletionModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskCompletionModal(
        task: task,
        onComplete: (actualStartTime, actualDuration, rating, notes) async {
          // Collect productivity data
          final collector = ref.read(productivityDataCollectorProvider);
          await collector.recordTaskCompletion(
            taskId: task.id,
            actualStartTime: actualStartTime,
            actualDurationMinutes: actualDuration,
            productivityRating: rating,
            notes: notes,
          );

          // Notify parent
          onCompleted?.call();
        },
      ),
    );
  }
}
