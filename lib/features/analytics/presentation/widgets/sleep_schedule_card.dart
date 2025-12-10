import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/dynamic_time_window_service.dart';

/// Card showing the user's sleep schedule and active hours
class SleepScheduleCard extends StatelessWidget {
  final DynamicTimeWindow timeWindow;

  const SleepScheduleCard({super.key, required this.timeWindow});

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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.bedtime_rounded,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sleep Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      timeWindow.isLearned
                          ? 'Learned from your patterns'
                          : 'From your profile settings',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (timeWindow.isLearned)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Smart',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Time display
          Row(
            children: [
              Expanded(
                child: _TimeBlock(
                  icon: Icons.wb_sunny_rounded,
                  iconColor: AppColors.warning,
                  label: 'Wake Up',
                  time: _formatHour(timeWindow.wakeHour),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TimeBlock(
                  icon: Icons.nights_stay_rounded,
                  iconColor: AppColors.accent,
                  label: 'Sleep',
                  time: _formatHour(timeWindow.sleepHour),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Active hours bar
          _ActiveHoursBar(timeWindow: timeWindow),
          const SizedBox(height: 12),

          // Optimal window info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.flash_on_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Peak productivity: ${_formatHour(timeWindow.optimalStartHour)} - ${_formatHour(timeWindow.optimalEndHour)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour == 12) return '12:00 PM';
    if (hour < 12) return '$hour:00 AM';
    return '${hour - 12}:00 PM';
  }
}

class _TimeBlock extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String time;

  const _TimeBlock({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveHoursBar extends StatelessWidget {
  final DynamicTimeWindow timeWindow;

  const _ActiveHoursBar({required this.timeWindow});

  @override
  Widget build(BuildContext context) {
    // Calculate active hours (handles past-midnight)
    int activeHours;
    if (timeWindow.sleepHour > timeWindow.wakeHour) {
      activeHours = timeWindow.sleepHour - timeWindow.wakeHour;
    } else {
      // Past midnight (e.g., wake 7, sleep 1 = 18 hours)
      activeHours = (24 - timeWindow.wakeHour) + timeWindow.sleepHour;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Hours',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '$activeHours hours',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Visual timeline bar
        SizedBox(
          height: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: List.generate(24, (hour) {
                final isActive = _isActiveHour(hour);
                final isOptimal =
                    hour >= timeWindow.optimalStartHour &&
                    hour < timeWindow.optimalEndHour;

                return Expanded(
                  child: Container(
                    color: isOptimal
                        ? AppColors.primary
                        : isActive
                        ? AppColors.accent.withValues(alpha: 0.4)
                        : AppColors.background,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Time labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '12AM',
              style: TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
            Text(
              '6AM',
              style: TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
            Text(
              '12PM',
              style: TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
            Text(
              '6PM',
              style: TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
            Text(
              '12AM',
              style: TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _isActiveHour(int hour) {
    if (timeWindow.sleepHour > timeWindow.wakeHour) {
      // Normal case: wake 7, sleep 23
      return hour >= timeWindow.wakeHour && hour < timeWindow.sleepHour;
    } else {
      // Past-midnight case: wake 7, sleep 1
      return hour >= timeWindow.wakeHour || hour < timeWindow.sleepHour;
    }
  }
}
