import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/scheduled_task.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/productivity_providers.dart';
import '../../../../core/services/database_service.dart';
import '../../../goals/presentation/providers/habit_metrics_provider.dart';
import '../../../goals/presentation/providers/milestone_provider.dart';
import '../../../goals/presentation/widgets/streak_badge.dart';
import '../providers/scheduled_task_providers.dart';
import '../../../timeline/presentation/providers/timeline_providers.dart';

import 'task_completion_modal.dart';

/// Card widget for displaying a scheduled task
class ScheduledTaskCard extends ConsumerStatefulWidget {
  final ScheduledTask task;
  final VoidCallback? onCompleted;

  const ScheduledTaskCard({super.key, required this.task, this.onCompleted});

  @override
  ConsumerState<ScheduledTaskCard> createState() => _ScheduledTaskCardState();
}

class _ScheduledTaskCardState extends ConsumerState<ScheduledTaskCard> {
  bool _showReason = false;

  /// Check if this task can be completed (only today's tasks)
  bool _canComplete() {
    if (widget.task.isCompleted) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(
      widget.task.scheduledDate.year,
      widget.task.scheduledDate.month,
      widget.task.scheduledDate.day,
    );

    // Only allow completing today's tasks
    return taskDate.isAtSameMomentAs(today);
  }

  /// Format time range as "HH:MM AM/PM - HH:MM AM/PM"
  String _formatTimeRange() {
    final startTime = widget.task.scheduledStartTime;
    final endTime = startTime.add(Duration(minutes: widget.task.duration));

    String format(DateTime dt) {
      final hour = dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$hour12:$minute $period';
    }

    return '${format(startTime)} - ${format(endTime)}';
  }

  /// Check if the reason button should be shown
  bool get _shouldShowReasonButton {
    return !widget.task.wasRescheduled &&
        widget.task.schedulingReason != null &&
        widget.task.schedulingReason!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final taskColor = Color(
      int.parse(task.colorHex?.replaceFirst('#', '0xFF') ?? '0xFFC6F432'),
    );

    final canComplete = _canComplete();

    return GestureDetector(
      onTap: () {
        // Dismiss reason when tapping outside the info button
        if (_showReason) {
          setState(() => _showReason = false);
        }
      },
      child: Container(
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
            onTap: canComplete ? () => _showCompletionModal(context) : null,
            onLongPress: task.isCompleted
                ? null
                : () => _showRescheduleModal(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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

                            // Milestone display
                            _buildMilestoneDisplay(),

                            // Time (start - end) and badges
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTimeRange(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                // Reason info button
                                if (_shouldShowReasonButton) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(
                                        () => _showReason = !_showReason,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _showReason
                                            ? AppColors.primary.withValues(
                                                alpha: 0.2,
                                              )
                                            : AppColors.textSecondary
                                                  .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        _showReason
                                            ? Icons.lightbulb
                                            : Icons.lightbulb_outline,
                                        size: 14,
                                        color: _showReason
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 8),
                                // ML badge
                                if (task.schedulingMethod == 'ml-based' ||
                                    task.schedulingMethod == 'smart-v2' &&
                                        task.mlConfidence != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withValues(
                                        alpha: 0.2,
                                      ),
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
                                _buildStreakBadge(),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Completion checkbox
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: canComplete
                            ? (_) => _showCompletionModal(context)
                            : null,
                        activeColor: taskColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  // Animated reason container
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: _showReason && task.schedulingReason != null
                        ? Container(
                            margin: const EdgeInsets.only(top: 12, left: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    task.schedulingReason!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMilestoneDisplay() {
    final milestoneAsync = ref.watch(
      firstIncompleteMilestoneProvider(widget.task.goalId),
    );

    return milestoneAsync.when(
      data: (milestone) {
        if (milestone == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              const Icon(
                Icons.flag_outlined,
                size: 12,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  milestone.title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStreakBadge() {
    final streakAsync = ref.watch(goalStreakStatusProvider(widget.task.goalId));

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

  void _showCompletionModal(BuildContext context) {
    final task = widget.task;
    final onCompleted = widget.onCompleted;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskCompletionModal(
        task: task,
        onComplete:
            (
              actualStartTime,
              actualDuration,
              rating,
              notes,
              milestoneId,
            ) async {
              try {
                // Collect productivity data
                final collector = ref.read(productivityDataCollectorProvider);
                await collector.recordTaskCompletion(
                  taskId: task.id,
                  actualStartTime: actualStartTime,
                  actualDurationMinutes: actualDuration,
                  productivityRating: rating,
                  notes: notes,
                );

                // If a milestone was completed, update the task to reference it
                if (milestoneId != null) {
                  task.milestoneId = milestoneId;
                  task.milestoneCompleted = true;
                  final taskRepo = ref.read(scheduledTaskRepositoryProvider);
                  await taskRepo.updateScheduledTask(task);
                }

                // Invalidate milestone providers
                ref.invalidate(milestonesForGoalProvider(task.goalId));
                ref.invalidate(firstIncompleteMilestoneProvider(task.goalId));

                // Invalidate streak provider for instant UI update
                ref.invalidate(goalStreakStatusProvider(task.goalId));
                ref.invalidate(allGoalStreaksProvider);
                ref.invalidate(goalsAtRiskProvider);

                // Invalidate timeline to show updated task state
                ref.invalidate(
                  scheduledTasksForDateProvider(task.scheduledDate),
                );
                ref.invalidate(unifiedTimelineProvider(task.scheduledDate));

                // Notify parent
                onCompleted?.call();
              } catch (e) {
                // Log error but don't prevent UI update
                debugPrint('Error completing task: $e');
                // Still invalidate providers to refresh UI
                ref.invalidate(
                  scheduledTasksForDateProvider(task.scheduledDate),
                );
                ref.invalidate(unifiedTimelineProvider(task.scheduledDate));
                onCompleted?.call();
              }
            },
      ),
    );
  }

  void _showRescheduleModal(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay(
      hour: widget.task.scheduledStartTime.hour,
      minute: widget.task.scheduledStartTime.minute,
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
              const Text(
                'Reschedule Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.task.title,
                style: const TextStyle(
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
                      const Icon(Icons.access_time, color: AppColors.primary),
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
                          widget.task.scheduledDate.year,
                          widget.task.scheduledDate.month,
                          widget.task.scheduledDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );

                        widget.task.scheduledStartTime = newStartTime;
                        widget.task.wasRescheduled = true;
                        widget.task.rescheduleCount =
                            (widget.task.rescheduleCount) + 1;
                        // Clear the scheduling reason since user manually rescheduled
                        widget.task.schedulingReason = null;

                        await repo.updateScheduledTask(widget.task);

                        // Notify parent to refresh
                        widget.onCompleted?.call();

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Task rescheduled to ${selectedTime.format(context)}',
                              ),
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
