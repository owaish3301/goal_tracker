import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/one_time_task.dart';

class OneTimeTaskCard extends StatelessWidget {
  final OneTimeTask task;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onTap;

  const OneTimeTaskCard({
    super.key,
    required this.task,
    this.onToggleComplete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final startTime = DateFormat('h:mm a').format(task.scheduledStartTime);
    final endTime = DateFormat(
      'h:mm a',
    ).format(task.scheduledStartTime.add(Duration(minutes: task.duration)));

    final taskColor = task.colorHex != null
        ? Color(int.parse(task.colorHex!, radix: 16))
        : AppColors.primary;

    return Dismissible(
      key: Key('task_${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            title: const Text(
              'Delete Task',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            content: const Text(
              'Are you sure you want to delete this task?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        // The actual deletion will be handled by the parent widget
      },
      child: InkWell(
        onTap: onTap, // Remove default edit navigation
        onLongPress: () {
          // Long-press to edit
          context.push('/events/${task.id}/edit');
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: taskColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Color indicator bar
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: taskColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),

              // Time column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    startTime,
                    style: TextStyle(
                      color: task.isCompleted
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 2,
                    height: 8,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    endTime,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Divider
              Container(
                width: 1,
                height: 50,
                color: AppColors.textSecondary.withValues(alpha: 0.3),
              ),
              const SizedBox(width: 16),

              // Task info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color: task.isCompleted
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.notes != null && task.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.notes!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      '${task.duration} min',
                      style: TextStyle(
                        color: taskColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Checkbox with larger tap area
              GestureDetector(
                onTap: onToggleComplete,
                child: Padding(
                  padding: const EdgeInsets.all(12), // Increase tap area
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: task.isCompleted ? taskColor : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: taskColor, width: 2),
                    ),
                    child: task.isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 18,
                            color: AppColors.textInversePrimary,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
