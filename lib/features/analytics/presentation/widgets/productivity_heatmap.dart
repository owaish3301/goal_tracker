import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/analytics_provider.dart';

/// Card showing productivity heatmap by day and hour
class ProductivityHeatmap extends StatelessWidget {
  final AnalyticsData data;

  const ProductivityHeatmap({super.key, required this.data});

  // Day labels moved to _DayBarChart

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
          const Row(
            children: [
              Icon(Icons.analytics_rounded, color: AppColors.accent, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Productivity Patterns',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your productivity by day of week',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),

          // Day of week productivity bars
          if (data.productivityByDay.isEmpty)
            _EmptyState()
          else
            _DayBarChart(productivityByDay: data.productivityByDay),

          const SizedBox(height: 24),

          // Average productivity
          Row(
            children: [
              Expanded(
                child: _ProductivityStat(
                  label: 'Avg Productivity',
                  value: data.averageProductivity.toStringAsFixed(1),
                  icon: Icons.speed_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProductivityStat(
                  label: 'Consistency',
                  value: '${(data.averageConsistency * 100).toInt()}%',
                  icon: Icons.repeat_rounded,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayBarChart extends StatelessWidget {
  final Map<int, double> productivityByDay;

  const _DayBarChart({required this.productivityByDay});

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    // Find max value for scaling
    final maxValue = productivityByDay.values.isEmpty
        ? 5.0
        : productivityByDay.values.reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        final value = productivityByDay[index] ?? 0;
        final heightPercent = maxValue > 0 ? value / maxValue : 0.0;
        final isToday = DateTime.now().weekday - 1 == index;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                // Value label
                Text(
                  value > 0 ? value.toStringAsFixed(1) : '-',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isToday
                        ? AppColors.primary
                        : AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                // Bar
                Container(
                  height: 60,
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    width: double.infinity,
                    height: (heightPercent * 60).clamp(4.0, 60.0).toDouble(),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: isToday
                            ? [AppColors.primary, AppColors.accent]
                            : [
                                AppColors.primary.withValues(alpha: 0.5),
                                AppColors.accent.withValues(alpha: 0.3),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Day label
                Text(
                  _dayLabels[index],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? AppColors.primary
                        : AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ProductivityStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ProductivityStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 40,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete tasks to see patterns',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
