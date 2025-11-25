import 'package:flutter/material.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/data/models/goal_category.dart';

/// A widget for selecting a goal category with visual feedback
class CategorySelector extends StatelessWidget {
  final GoalCategory selectedCategory;
  final ValueChanged<GoalCategory> onChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Helps optimize scheduling based on task type',
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: GoalCategory.values.map((category) {
            final isSelected = category == selectedCategory;
            return _CategoryChip(
              category: category,
              isSelected: isSelected,
              onTap: () => onChanged(category),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Show optimal times hint for selected category
        _OptimalTimesHint(category: selectedCategory),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final GoalCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category.emoji,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 6),
            Text(
              _getShortDisplayName(category),
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getShortDisplayName(GoalCategory category) {
    switch (category) {
      case GoalCategory.exercise:
        return 'Exercise';
      case GoalCategory.learning:
        return 'Learning';
      case GoalCategory.creative:
        return 'Creative';
      case GoalCategory.work:
        return 'Work';
      case GoalCategory.wellness:
        return 'Wellness';
      case GoalCategory.social:
        return 'Social';
      case GoalCategory.chores:
        return 'Chores';
      case GoalCategory.other:
        return 'Other';
    }
  }
}

class _OptimalTimesHint extends StatelessWidget {
  final GoalCategory category;

  const _OptimalTimesHint({required this.category});

  @override
  Widget build(BuildContext context) {
    final optimalHours = category.optimalHours;
    final timeRanges = _formatTimeRanges(optimalHours);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            size: 16,
            color: AppColors.primary.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Best times: $timeRanges',
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.9),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeRanges(List<int> hours) {
    if (hours.isEmpty) return 'Anytime';

    // Sort hours and group consecutive ones
    final sorted = List<int>.from(hours)..sort();
    final ranges = <String>[];
    
    int rangeStart = sorted[0];
    int rangeEnd = sorted[0];

    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i] == rangeEnd + 1) {
        rangeEnd = sorted[i];
      } else {
        ranges.add(_formatRange(rangeStart, rangeEnd));
        rangeStart = sorted[i];
        rangeEnd = sorted[i];
      }
    }
    ranges.add(_formatRange(rangeStart, rangeEnd));

    return ranges.join(', ');
  }

  String _formatRange(int start, int end) {
    if (start == end) {
      return _formatHour(start);
    }
    return '${_formatHour(start)}-${_formatHour(end + 1)}';
  }

  String _formatHour(int hour) {
    if (hour == 0 || hour == 24) return '12AM';
    if (hour == 12) return '12PM';
    if (hour < 12) return '${hour}AM';
    return '${hour - 12}PM';
  }
}
