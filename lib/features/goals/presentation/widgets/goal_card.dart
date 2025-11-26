import 'package:flutter/material.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/core/constants/constants.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    this.onDelete,
  });

  // Cache color parsing - computed once per goal
  Color get _goalColor =>
      Color(int.parse(goal.colorHex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    final color = _goalColor;
    final icon = AppConstants.getIconFromName(goal.iconName);

    // RepaintBoundary prevents repaint propagation during scrolling
    return RepaintBoundary(
      child: Dismissible(
        key: Key(goal.id.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(32),
          ),
          child:
              const Icon(Icons.delete_outline, color: Colors.white, size: 28),
        ),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Goal'),
              content: Text('Are you sure you want to delete "${goal.title}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) => onDelete?.call(),
        child: Card(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: color, width: 4)),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  _GoalIconBadge(color: color, icon: icon),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        _DayIndicators(
                          frequency: goal.frequency,
                          activeColor: color,
                        ),
                        const SizedBox(height: 8),
                        _DurationLabel(duration: goal.targetDuration),
                      ],
                    ),
                  ),
                  const Icon(Icons.drag_handle, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted widget for icon badge - can be const when color/icon are same
class _GoalIconBadge extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _GoalIconBadge({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

// Extracted day indicators widget - prevents rebuilding all 7 circles
class _DayIndicators extends StatelessWidget {
  final List<int> frequency;
  final Color activeColor;

  const _DayIndicators({required this.frequency, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (index) {
        final isActive = frequency.contains(index);
        return Padding(
          padding: EdgeInsets.only(right: index < 6 ? 4 : 0),
          child: _DayCircle(
            dayIndex: index,
            isActive: isActive,
            activeColor: activeColor,
          ),
        );
      }),
    );
  }
}

// Individual day circle - extracted for potential caching
class _DayCircle extends StatelessWidget {
  final int dayIndex;
  final bool isActive;
  final Color activeColor;

  const _DayCircle({
    required this.dayIndex,
    required this.isActive,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor.withValues(alpha: 0.3)
            : AppColors.surfaceDark.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          AppConstants.dayNames[dayIndex],
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? activeColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// Duration label extracted
class _DurationLabel extends StatelessWidget {
  final int duration;

  const _DurationLabel({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.schedule,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          _formatDuration(duration),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0 && mins > 0) {
      return '${hours}h ${mins}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${mins}m';
    }
  }
}
