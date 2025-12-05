import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/database_service.dart';
import '../../../../data/models/habit_metrics.dart';

/// Analytics data model for a single goal
class GoalAnalytics {
  final int goalId;
  final String title;
  final String colorHex;
  final String iconName;
  final int currentStreak;
  final int longestStreak;
  final int totalCompletions;
  final int totalScheduled;
  final double consistencyScore;
  final bool isAtRisk;
  final int completedMilestones;
  final int totalMilestones;

  GoalAnalytics({
    required this.goalId,
    required this.title,
    required this.colorHex,
    required this.iconName,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompletions,
    required this.totalScheduled,
    required this.consistencyScore,
    required this.isAtRisk,
    required this.completedMilestones,
    required this.totalMilestones,
  });

  double get completionRate =>
      totalScheduled > 0 ? totalCompletions / totalScheduled : 0.0;

  double get milestoneProgress =>
      totalMilestones > 0 ? completedMilestones / totalMilestones : 0.0;
}

/// Main analytics data aggregation
class AnalyticsData {
  final int totalGoals;
  final int activeGoals;
  final double overallCompletionRate;
  final int longestCurrentStreak;
  final int goalsWithActiveStreaks;
  final int goalsAtRisk;
  final double averageConsistency;
  final double averageProductivity;
  final int totalCompletions;
  final int totalScheduled;
  final List<GoalAnalytics> goalAnalytics;
  final Map<int, double> productivityByHour; // 0-23 -> avg productivity
  final Map<int, double> productivityByDay; // 0-6 -> avg productivity (Mon=0)

  AnalyticsData({
    required this.totalGoals,
    required this.activeGoals,
    required this.overallCompletionRate,
    required this.longestCurrentStreak,
    required this.goalsWithActiveStreaks,
    required this.goalsAtRisk,
    required this.averageConsistency,
    required this.averageProductivity,
    required this.totalCompletions,
    required this.totalScheduled,
    required this.goalAnalytics,
    required this.productivityByHour,
    required this.productivityByDay,
  });

  /// Empty state for initial loading
  static AnalyticsData empty() => AnalyticsData(
    totalGoals: 0,
    activeGoals: 0,
    overallCompletionRate: 0,
    longestCurrentStreak: 0,
    goalsWithActiveStreaks: 0,
    goalsAtRisk: 0,
    averageConsistency: 0,
    averageProductivity: 0,
    totalCompletions: 0,
    totalScheduled: 0,
    goalAnalytics: [],
    productivityByHour: {},
    productivityByDay: {},
  );

  bool get hasData => totalGoals > 0;
}

/// Provider for fetching all analytics data
final analyticsDataProvider = FutureProvider<AnalyticsData>((ref) async {
  final goalRepo = ref.watch(goalRepositoryProvider);
  final habitMetricsRepo = ref.watch(habitMetricsRepositoryProvider);
  final productivityRepo = ref.watch(productivityDataRepositoryProvider);
  final milestoneRepo = ref.watch(milestoneRepositoryProvider);
  final scheduledTaskRepo = ref.watch(scheduledTaskRepositoryProvider);

  // Fetch all goals
  final allGoals = await goalRepo.getAllGoals();
  final activeGoals = allGoals.where((g) => g.isActive).toList();

  if (allGoals.isEmpty) {
    return AnalyticsData.empty();
  }

  // Fetch all habit metrics
  final allMetrics = await habitMetricsRepo.getAllMetrics();
  final metricsMap = <int, HabitMetrics>{};
  for (final m in allMetrics) {
    metricsMap[m.goalId] = m;
  }

  // Calculate goal-level analytics
  final goalAnalyticsList = <GoalAnalytics>[];
  int totalCompletions = 0;
  int totalScheduled = 0;
  int goalsWithActiveStreaks = 0;
  int goalsAtRisk = 0;
  int longestCurrentStreak = 0;

  for (final goal in activeGoals) {
    final metrics = metricsMap[goal.id];
    final currentStreak = metrics?.currentStreak ?? 0;
    final isAtRisk = metrics?.streakAtRisk ?? false;

    if (currentStreak > 0) goalsWithActiveStreaks++;
    if (isAtRisk) goalsAtRisk++;
    if (currentStreak > longestCurrentStreak) {
      longestCurrentStreak = currentStreak;
    }

    totalCompletions += metrics?.totalCompletions ?? 0;
    totalScheduled += metrics?.totalScheduled ?? 0;

    // Get milestone counts for this goal
    final milestones = await milestoneRepo.getMilestonesForGoal(goal.id);
    final completedMilestones = milestones.where((m) => m.isCompleted).length;

    goalAnalyticsList.add(
      GoalAnalytics(
        goalId: goal.id,
        title: goal.title,
        colorHex: goal.colorHex,
        iconName: goal.iconName,
        currentStreak: currentStreak,
        longestStreak: metrics?.longestStreak ?? 0,
        totalCompletions: metrics?.totalCompletions ?? 0,
        totalScheduled: metrics?.totalScheduled ?? 0,
        consistencyScore: metrics?.consistencyScore ?? 0.0,
        isAtRisk: isAtRisk,
        completedMilestones: completedMilestones,
        totalMilestones: milestones.length,
      ),
    );
  }

  // Sort by streak (highest first)
  goalAnalyticsList.sort((a, b) => b.currentStreak.compareTo(a.currentStreak));

  // Calculate overall completion rate
  final overallCompletionRate = totalScheduled > 0
      ? totalCompletions / totalScheduled
      : 0.0;

  // Calculate average consistency
  final avgConsistency = await habitMetricsRepo.getAverageConsistency();

  // Calculate average productivity from completed scheduled tasks
  double avgProductivity = 0.0;
  final allCompletedTasks = await scheduledTaskRepo
      .getAllCompletedScheduledTasks();
  if (allCompletedTasks.isNotEmpty) {
    final tasksWithRating = allCompletedTasks
        .where((t) => t.productivityRating != null)
        .toList();
    if (tasksWithRating.isNotEmpty) {
      final totalRating = tasksWithRating.fold<int>(
        0,
        (sum, t) => sum + t.productivityRating!,
      );
      avgProductivity = totalRating / tasksWithRating.length;
    }
  }

  // Get productivity patterns
  Map<int, double> productivityByHour = {};
  Map<int, double> productivityByDay = {};

  // Aggregate productivity by hour across all goals
  for (final goal in activeGoals) {
    final hourlyData = await productivityRepo.getProductivityByTimeSlot(
      goal.id,
    );
    for (final entry in hourlyData.entries) {
      productivityByHour[entry.key] =
          (productivityByHour[entry.key] ?? 0) + entry.value;
    }

    final dailyData = await productivityRepo.getProductivityByDayOfWeek(
      goal.id,
    );
    for (final entry in dailyData.entries) {
      productivityByDay[entry.key] =
          (productivityByDay[entry.key] ?? 0) + entry.value;
    }
  }

  // Average the productivity values
  if (activeGoals.isNotEmpty) {
    for (final key in productivityByHour.keys) {
      productivityByHour[key] = productivityByHour[key]! / activeGoals.length;
    }
    for (final key in productivityByDay.keys) {
      productivityByDay[key] = productivityByDay[key]! / activeGoals.length;
    }
  }

  return AnalyticsData(
    totalGoals: allGoals.length,
    activeGoals: activeGoals.length,
    overallCompletionRate: overallCompletionRate,
    longestCurrentStreak: longestCurrentStreak,
    goalsWithActiveStreaks: goalsWithActiveStreaks,
    goalsAtRisk: goalsAtRisk,
    averageConsistency: avgConsistency,
    averageProductivity: avgProductivity,
    totalCompletions: totalCompletions,
    totalScheduled: totalScheduled,
    goalAnalytics: goalAnalyticsList,
    productivityByHour: productivityByHour,
    productivityByDay: productivityByDay,
  );
});

/// Provider for refreshing analytics data
final analyticsRefreshProvider = Provider<void Function()>((ref) {
  return () => ref.invalidate(analyticsDataProvider);
});
