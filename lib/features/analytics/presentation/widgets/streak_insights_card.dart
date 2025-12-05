import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/analytics_provider.dart';

/// Card showing streak insights and achievements
class StreakInsightsCard extends StatelessWidget {
  final AnalyticsData data;

  const StreakInsightsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final goalsWithStreaks = data.goalAnalytics
        .where((g) => g.currentStreak > 0)
        .toList();
    final atRiskGoals = data.goalAnalytics
        .where((g) => g.isAtRisk && g.currentStreak > 0)
        .toList();

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
                Icons.local_fire_department_rounded,
                color: AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Streaks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${data.goalsWithActiveStreaks} active',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // At risk warning
          if (atRiskGoals.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${atRiskGoals.length} streak${atRiskGoals.length > 1 ? 's' : ''} at risk today!',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Streak list
          if (goalsWithStreaks.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 40,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete tasks to build streaks!',
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
            ...goalsWithStreaks.take(5).map((goal) => _StreakRow(goal: goal)),
        ],
      ),
    );
  }
}

class _StreakRow extends StatelessWidget {
  final GoalAnalytics goal;

  const _StreakRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    final goalColor = Color(int.parse(goal.colorHex.replaceFirst('#', '0xFF')));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: goalColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconData(goal.iconName),
              color: goalColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Best: ${goal.longestStreak} days',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: AppColors.warning,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                '${goal.currentStreak}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                ),
              ),
              if (goal.isAtRisk) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.warning_rounded,
                  color: AppColors.error,
                  size: 16,
                ),
              ],
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
