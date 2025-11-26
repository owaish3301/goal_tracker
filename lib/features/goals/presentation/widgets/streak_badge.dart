import 'package:flutter/material.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';

/// A compact badge displaying the current streak count with a fire emoji
class StreakBadge extends StatelessWidget {
  final int streak;
  final bool isAtRisk;
  final bool showLabel;
  final double size;

  const StreakBadge({
    super.key,
    required this.streak,
    this.isAtRisk = false,
    this.showLabel = true,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    if (streak <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 0.4,
        vertical: size * 0.2,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(size),
        border: isAtRisk
            ? Border.all(
                color: AppColors.warning.withValues(alpha: 0.5),
                width: 1.5,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getStreakEmoji(),
            style: TextStyle(fontSize: size * 0.7),
          ),
          SizedBox(width: size * 0.15),
          Text(
            streak.toString(),
            style: TextStyle(
              fontSize: size * 0.65,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          if (showLabel) ...[
            SizedBox(width: size * 0.1),
            Text(
              streak == 1 ? 'day' : 'days',
              style: TextStyle(
                fontSize: size * 0.5,
                color: _textColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color get _backgroundColor {
    if (isAtRisk) {
      return AppColors.warning.withValues(alpha: 0.15);
    }
    if (streak >= 21) {
      // Habit locked
      return AppColors.success.withValues(alpha: 0.15);
    }
    if (streak >= 7) {
      // Week streak
      return AppColors.primary.withValues(alpha: 0.15);
    }
    return AppColors.surface;
  }

  Color get _textColor {
    if (isAtRisk) {
      return AppColors.warning;
    }
    if (streak >= 21) {
      return AppColors.success;
    }
    if (streak >= 7) {
      return AppColors.primary;
    }
    return AppColors.textPrimary;
  }

  String _getStreakEmoji() {
    if (streak >= 100) return '🏆';
    if (streak >= 50) return '⭐';
    if (streak >= 21) return '🔒'; // Habit locked
    if (streak >= 7) return '🔥';
    return '🔥';
  }
}

/// A larger streak display for detail views or cards
class StreakDisplay extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final bool isAtRisk;
  final String habitStage;

  const StreakDisplay({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    this.isAtRisk = false,
    this.habitStage = 'Starting',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isAtRisk
            ? Border.all(color: AppColors.warning.withValues(alpha: 0.5))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStreakColumn(
                label: 'Current',
                value: currentStreak,
                emoji: _getCurrentEmoji(),
                isHighlighted: true,
              ),
              const SizedBox(width: 24),
              _buildStreakColumn(
                label: 'Longest',
                value: longestStreak,
                emoji: '🏆',
                isHighlighted: false,
              ),
            ],
          ),
          if (isAtRisk) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'Complete today to keep your streak!',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          _buildHabitStageIndicator(),
        ],
      ),
    );
  }

  Widget _buildStreakColumn({
    required String label,
    required int value,
    required String emoji,
    required bool isHighlighted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? _getStreakColor() : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'days',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHabitStageIndicator() {
    return Row(
      children: [
        Text(
          habitStage,
          style: TextStyle(
            color: _getStageColor(),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _getStageProgress(),
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation(_getStageColor()),
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }

  String _getCurrentEmoji() {
    if (currentStreak >= 100) return '🏆';
    if (currentStreak >= 50) return '⭐';
    if (currentStreak >= 21) return '🔒';
    return '🔥';
  }

  Color _getStreakColor() {
    if (isAtRisk) return AppColors.warning;
    if (currentStreak >= 21) return AppColors.success;
    if (currentStreak >= 7) return AppColors.primary;
    return AppColors.textPrimary;
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

  double _getStageProgress() {
    // Progress towards 21-day habit lock
    return (currentStreak / 21).clamp(0.0, 1.0);
  }
}

/// A mini streak indicator for timeline cards
class MiniStreakBadge extends StatelessWidget {
  final int streak;
  final bool isAtRisk;

  const MiniStreakBadge({
    super.key,
    required this.streak,
    this.isAtRisk = false,
  });

  @override
  Widget build(BuildContext context) {
    if (streak <= 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          streak >= 21 ? '🔒' : '🔥',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 2),
        Text(
          streak.toString(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isAtRisk
                ? AppColors.warning
                : (streak >= 21 ? AppColors.success : AppColors.primary),
          ),
        ),
      ],
    );
  }
}
