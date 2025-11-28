import 'package:flutter/material.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';

/// Displays consistency score as a visual indicator
class ConsistencyIndicator extends StatelessWidget {
  final double score; // 0.0 to 1.0
  final bool showLabel;
  final bool compact;

  const ConsistencyIndicator({
    super.key,
    required this.score,
    this.showLabel = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactIndicator();
    }
    return _buildFullIndicator();
  }

  Widget _buildCompactIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildProgressBar(width: 40, height: 4),
        const SizedBox(width: 6),
        Text(
          '${(score * 100).round()}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _getColor(),
          ),
        ),
      ],
    );
  }

  Widget _buildFullIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Consistency',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                '${(score * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getColor(),
                ),
              ),
            ],
          ),
        if (showLabel) const SizedBox(height: 6),
        _buildProgressBar(width: double.infinity, height: 6),
      ],
    );
  }

  Widget _buildProgressBar({required double width, required double height}) {
    return SizedBox(
      width: width == double.infinity ? null : width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LinearProgressIndicator(
          value: score.clamp(0.0, 1.0),
          backgroundColor: AppColors.surface,
          valueColor: AlwaysStoppedAnimation(_getColor()),
          minHeight: height,
        ),
      ),
    );
  }

  Color _getColor() {
    if (score >= 0.8) return AppColors.success;
    if (score >= 0.5) return AppColors.primary;
    if (score >= 0.3) return AppColors.warning;
    return AppColors.error;
  }
}

/// Displays the sticky (optimal) time for a habit
class StickyTimeIndicator extends StatelessWidget {
  final int hour;
  final int? dayOfWeek;
  final double consistency;

  const StickyTimeIndicator({
    super.key,
    required this.hour,
    this.dayOfWeek,
    required this.consistency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⏰', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Best time: ${_formatHour(hour)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (dayOfWeek != null)
                Text(
                  _formatDayOfWeek(dayOfWeek!),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${(consistency * 100).round()}%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour $period';
  }

  String _formatDayOfWeek(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (day >= 0 && day < 7) {
      return 'Most active on ${days[day]}';
    }
    return '';
  }
}

/// A combined widget showing streak and consistency together
class HabitHealthCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final double consistencyScore;
  final bool isAtRisk;
  final String habitStage;
  final int? stickyHour;
  final int? stickyDayOfWeek;
  final double? timeConsistency;

  const HabitHealthCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.consistencyScore,
    this.isAtRisk = false,
    this.habitStage = 'Starting',
    this.stickyHour,
    this.stickyDayOfWeek,
    this.timeConsistency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                '📊 Habit Health',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              _buildHabitStageChip(),
            ],
          ),
          const SizedBox(height: 16),

          // Streak Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  emoji: currentStreak >= 21 ? '🔒' : '🔥',
                  label: 'Current Streak',
                  value: '$currentStreak days',
                  highlight: currentStreak > 0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  emoji: '🏆',
                  label: 'Best Streak',
                  value: '$longestStreak days',
                  highlight: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Consistency Bar
          ConsistencyIndicator(score: consistencyScore),

          // At Risk Warning
          if (isAtRisk) ...[const SizedBox(height: 12), _buildAtRiskWarning()],

          // Sticky Time
          if (stickyHour != null && timeConsistency != null) ...[
            const SizedBox(height: 12),
            StickyTimeIndicator(
              hour: stickyHour!,
              dayOfWeek: stickyDayOfWeek,
              consistency: timeConsistency!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String emoji,
    required String label,
    required String value,
    required bool highlight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: highlight
                    ? (isAtRisk ? AppColors.warning : AppColors.primary)
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildHabitStageChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStageColor().withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        habitStage,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _getStageColor(),
        ),
      ),
    );
  }

  Widget _buildAtRiskWarning() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Complete a task today to keep your $currentStreak day streak!',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStageColor() {
    switch (habitStage) {
      case 'Habit Locked':
        return AppColors.success;
      case 'Almost There':
        return AppColors.primary;
      case 'Building':
        return AppColors.accent;
      default:
        return AppColors.textSecondary;
    }
  }
}
