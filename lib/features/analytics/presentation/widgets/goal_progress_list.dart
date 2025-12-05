import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/analytics_provider.dart';

/// Card showing per-goal progress
class GoalProgressList extends StatelessWidget {
  final List<GoalAnalytics> goals;

  const GoalProgressList({super.key, required this.goals});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flag_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Goal Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${goals.length} goals',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (goals.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 40,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No goals yet. Add some to track!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...goals.map((goal) => _GoalProgressRow(goal: goal)),
        ],
      ),
    );
  }
}

class _GoalProgressRow extends StatelessWidget {
  final GoalAnalytics goal;

  const _GoalProgressRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    final goalColor = Color(int.parse(goal.colorHex.replaceFirst('#', '0xFF')));
    final completionPercent = goal.completionRate;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: goalColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getIconData(goal.iconName),
                  color: goalColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${(completionPercent * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: goalColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 38), // Align with text
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: completionPercent,
                    backgroundColor: AppColors.background,
                    valueColor: AlwaysStoppedAnimation<Color>(goalColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${goal.totalCompletions}/${goal.totalScheduled}',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = <String, IconData>{
      'fitness_center': Icons.fitness_center,
      'school': Icons.school,
      'palette': Icons.palette,
      'work': Icons.work,
      'self_improvement': Icons.self_improvement,
      'people': Icons.people,
      'home': Icons.home,
      'category': Icons.category,
      'star': Icons.star,
      'book': Icons.book,
      'code': Icons.code,
      'music_note': Icons.music_note,
      'restaurant': Icons.restaurant,
    };
    return iconMap[iconName] ?? Icons.flag;
  }
}
