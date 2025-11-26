import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/scheduled_task.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/productivity_providers.dart';
import '../../../../core/services/database_service.dart';
import '../../../goals/presentation/providers/habit_metrics_provider.dart';
import '../../../goals/presentation/widgets/streak_badge.dart';
import '../providers/scheduled_task_providers.dart';
import 'task_completion_modal.dart';

/// Card widget for displaying a scheduled task
class ScheduledTaskCard extends ConsumerWidget {
  final ScheduledTask task;
  final VoidCallback? onCompleted;

  const ScheduledTaskCard({super.key, required this.task, this.onCompleted});

  /// Check if this task can be completed (only today's tasks)
  bool _canComplete() {
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
    final taskColor = Color(
      int.parse(task.colorHex?.replaceFirst('#', '0xFF') ?? '0xFFC6F432'),
    );
    
    final canComplete = _canComplete();

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
          onTap: canComplete
              ? () => _showCompletionModal(context, ref)
              : null,
          onLongPress: task.isCompleted ? null : () => _showRescheduleModal(context, ref),
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
                          // Streak badge
                          _buildStreakBadge(ref),
                        ],
                      ),
                    ],
                  ),
                ),

                // Completion checkbox
                Checkbox(
                  value: task.isCompleted,
                  onChanged: canComplete
                      ? (_) => _showCompletionModal(context, ref)
                      : null,
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

  Widget _buildStreakBadge(WidgetRef ref) {
    final streakAsync = ref.watch(goalStreakStatusProvider(task.goalId));
    
    return streakAsync.when(
      data: (status) {
        if (status.currentStreak <= 0) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: MiniStreakBadge(
            streak: status.currentStreak,
            isAtRisk: status.isAtRisk,
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
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

  void _showRescheduleModal(BuildContext context, WidgetRef ref) {
    TimeOfDay selectedTime = TimeOfDay(
      hour: task.scheduledStartTime.hour,
      minute: task.scheduledStartTime.minute,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                'Reschedule Task',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Time picker button
              InkWell(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.primary,
                            surface: AppColors.surfaceDark,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setModalState(() => selectedTime = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'New Time: ${selectedTime.format(context)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: BorderSide(
                          color: AppColors.textSecondary.withValues(alpha: 0.3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Update the task with new time
                        final repo = ref.read(scheduledTaskRepositoryProvider);
                        final newStartTime = DateTime(
                          task.scheduledDate.year,
                          task.scheduledDate.month,
                          task.scheduledDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        
                        task.scheduledStartTime = newStartTime;
                        task.wasRescheduled = true;
                        task.rescheduleCount = (task.rescheduleCount) + 1;
                        
                        await repo.updateScheduledTask(task);
                        
                        // Notify parent to refresh
                        onCompleted?.call();
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task rescheduled to ${selectedTime.format(context)}'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textInversePrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Reschedule'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
