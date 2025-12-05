import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/core/constants/constants.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/streak_badge.dart';
import 'package:goal_tracker/features/goals/presentation/providers/milestone_provider.dart';

/// Expandable Goal Card that shows milestones in a collapsible section
class ExpandableGoalCard extends ConsumerStatefulWidget {
  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final int? currentStreak;
  final bool isStreakAtRisk;
  final int? priorityIndex;
  final Widget? dragHandle;

  const ExpandableGoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    this.onDelete,
    this.currentStreak,
    this.isStreakAtRisk = false,
    this.priorityIndex,
    this.dragHandle,
  });

  @override
  ConsumerState<ExpandableGoalCard> createState() => _ExpandableGoalCardState();
}

class _ExpandableGoalCardState extends ConsumerState<ExpandableGoalCard> {
  bool _isExpanded = false;
  final TextEditingController _milestoneController = TextEditingController();

  @override
  void dispose() {
    _milestoneController.dispose();
    super.dispose();
  }

  Color get _goalColor => Color(int.parse(widget.goal.colorHex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    final color = _goalColor;
    final icon = AppConstants.getIconFromName(widget.goal.iconName);
    final milestonesAsync = ref.watch(milestonesForGoalProvider(widget.goal.id));

    return RepaintBoundary(
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 4)),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              // Main card content
              InkWell(
                onTap: widget.onTap,
                onLongPress: widget.onDelete != null
                    ? () => _showDeleteConfirmation(context)
                    : null,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      if (widget.priorityIndex != null) ...[
                        _PriorityBadge(priority: widget.priorityIndex!),
                        const SizedBox(width: 12),
                      ],
                      _GoalIconBadge(color: color, icon: icon),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.goal.title,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                  ),
                                ),
                                if (widget.currentStreak != null && widget.currentStreak! > 0)
                                  StreakBadge(
                                    streak: widget.currentStreak!,
                                    isAtRisk: widget.isStreakAtRisk,
                                    showLabel: false,
                                    size: 20,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _DayIndicators(
                              frequency: widget.goal.frequency,
                              activeColor: color,
                            ),
                            const SizedBox(height: 8),
                            _DurationLabel(duration: widget.goal.targetDuration),
                          ],
                        ),
                      ),
                      widget.dragHandle ?? const Icon(Icons.drag_handle, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),

              // Milestones section
              milestonesAsync.when(
                data: (milestones) {
                  if (milestones.isEmpty && !_isExpanded) {
                    return const SizedBox.shrink();
                  }
                  return _buildMilestonesSection(milestones);
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMilestonesSection(List<Milestone> milestones) {
    return Column(
      children: [
        // Divider
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(height: 1, color: AppColors.textSecondary),
        ),

        // Milestone toggle header
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.flag_outlined, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Milestones',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(width: 8),
                if (milestones.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${milestones.where((m) => m.isCompleted).length}/${milestones.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                const Spacer(),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),

        // Expanded content
        if (_isExpanded) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                // Quick add milestone
                _buildQuickAddMilestone(),
                
                if (milestones.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildMilestoneList(milestones),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickAddMilestone() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _milestoneController,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Add a milestone...',
              hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              isDense: true,
            ),
            onSubmitted: (_) => _addMilestone(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _addMilestone,
          icon: const Icon(Icons.add_circle, size: 20),
          color: AppColors.primary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildMilestoneList(List<Milestone> milestones) {
    return Column(
      children: milestones.map((milestone) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: milestone.isCompleted,
                  onChanged: (value) {
                    if (value != null) {
                      HapticFeedback.lightImpact();
                      ref.read(milestoneNotifierProvider.notifier).toggleMilestoneCompletion(
                            milestone.id,
                            widget.goal.id,
                            value,
                          );
                    }
                  },
                  activeColor: _goalColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  milestone.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: milestone.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                    decoration: milestone.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                color: AppColors.error,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  ref.read(milestoneNotifierProvider.notifier).deleteMilestone(
                        milestone.id,
                        widget.goal.id,
                      );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _addMilestone() {
    if (_milestoneController.text.trim().isEmpty) return;

    final milestonesAsync = ref.read(milestonesForGoalProvider(widget.goal.id));
    final milestoneCount = milestonesAsync.valueOrNull?.length ?? 0;

    final newMilestone = Milestone()
      ..title = _milestoneController.text.trim()
      ..orderIndex = milestoneCount
      ..isCompleted = false;

    ref.read(milestoneNotifierProvider.notifier).createMilestone(
          newMilestone,
          widget.goal.id,
        );

    _milestoneController.clear();
    HapticFeedback.lightImpact();
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Goal'),
        content: Text('Are you sure you want to delete "${widget.goal.title}"?'),
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

    if (confirmed == true) {
      widget.onDelete?.call();
    }
  }
}

// Supporting widgets
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

class _DayIndicators extends StatelessWidget {
  final List<int> frequency;
  final Color activeColor;

  const _DayIndicators({required this.frequency, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
      ),
    );
  }
}

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
      width: 36,
      height: 24,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor.withValues(alpha: 0.3)
            : AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          AppConstants.dayNames[dayIndex],
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? activeColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _DurationLabel extends StatelessWidget {
  final int duration;

  const _DurationLabel({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
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

class _PriorityBadge extends StatelessWidget {
  final int priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '#$priority',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
