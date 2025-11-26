import 'package:flutter/material.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';

class MilestoneEditor extends StatefulWidget {
  final List<Milestone> milestones;
  final ValueChanged<List<Milestone>> onChanged;

  const MilestoneEditor({
    super.key,
    required this.milestones,
    required this.onChanged,
  });

  @override
  State<MilestoneEditor> createState() => _MilestoneEditorState();
}

class _MilestoneEditorState extends State<MilestoneEditor> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addMilestone() {
    if (_controller.text.trim().isEmpty) return;

    final newMilestone = Milestone()
      ..title = _controller.text.trim()
      ..orderIndex = widget.milestones.length
      ..isCompleted = false;

    widget.onChanged([...widget.milestones, newMilestone]);
    _controller.clear();
  }

  void _deleteMilestone(int index) {
    final updated = List<Milestone>.from(widget.milestones);
    updated.removeAt(index);
    // Update order indexes
    for (int i = 0; i < updated.length; i++) {
      updated[i].orderIndex = i;
    }
    widget.onChanged(updated);
  }

  void _reorderMilestones(int oldIndex, int newIndex) {
    final updated = List<Milestone>.from(widget.milestones);
    if (newIndex > oldIndex) {
      newIndex--;
    }
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    // Update order indexes
    for (int i = 0; i < updated.length; i++) {
      updated[i].orderIndex = i;
    }
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            children: [
              Text(
                'Milestones',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              if (widget.milestones.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.milestones.length}',
                    style: const TextStyle(
                      fontSize: 12,
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

        if (_isExpanded) ...[
          const SizedBox(height: 12),

          // Add milestone input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.textPrimary),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Add a milestone...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _addMilestone(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addMilestone,
                icon: const Icon(Icons.add_circle),
                color: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Milestone list
          if (widget.milestones.isNotEmpty)
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.milestones.length,
              onReorder: _reorderMilestones,
              itemBuilder: (context, index) {
                final milestone = widget.milestones[index];
                return Container(
                  key: ValueKey(milestone.hashCode),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.drag_handle,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          milestone.title,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        iconSize: 20,
                        color: AppColors.error,
                        onPressed: () => _deleteMilestone(index),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ],
    );
  }
}
