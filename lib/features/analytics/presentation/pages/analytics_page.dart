import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/analytics_provider.dart';
import '../widgets/analytics_overview_card.dart';
import '../widgets/streak_insights_card.dart';
import '../widgets/productivity_heatmap.dart';
import '../widgets/goal_progress_list.dart';

/// Analytics page showing user productivity insights
class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(analyticsDataProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: analyticsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.error.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load analytics',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(analyticsDataProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (data) {
          if (!data.hasData) {
            return _EmptyAnalytics();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(analyticsDataProvider);
              await ref.read(analyticsDataProvider.future);
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Overview Card
                  AnalyticsOverviewCard(data: data),
                  const SizedBox(height: 16),

                  // Streak Insights
                  StreakInsightsCard(data: data),
                  const SizedBox(height: 16),

                  // Productivity Patterns
                  ProductivityHeatmap(data: data),
                  const SizedBox(height: 16),

                  // Goal Progress
                  GoalProgressList(goals: data.goalAnalytics),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.insights_rounded,
                size: 64,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Analytics Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start by adding goals and completing tasks.\nYour productivity insights will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FeatureHint(icon: Icons.flag_rounded, label: 'Track Goals'),
                SizedBox(width: 24),
                _FeatureHint(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Build Streaks',
                ),
                SizedBox(width: 24),
                _FeatureHint(icon: Icons.speed_rounded, label: 'See Patterns'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureHint extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureHint({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
