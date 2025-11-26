import 'package:isar/isar.dart';
import '../models/habit_metrics.dart';

/// Repository for managing HabitMetrics data
class HabitMetricsRepository {
  final Isar _isar;

  HabitMetricsRepository(this._isar);

  // === CRUD Operations ===

  /// Create or update habit metrics
  Future<int> upsertMetrics(HabitMetrics metrics) async {
    metrics.updatedAt = DateTime.now();
    return await _isar.writeTxn(() async {
      return await _isar.habitMetrics.put(metrics);
    });
  }

  /// Get metrics by ID
  Future<HabitMetrics?> getMetrics(int id) async {
    return await _isar.habitMetrics.get(id);
  }

  /// Get metrics for a specific goal
  Future<HabitMetrics?> getMetricsForGoal(int goalId) async {
    return await _isar.habitMetrics
        .filter()
        .goalIdEqualTo(goalId)
        .findFirst();
  }

  /// Get or create metrics for a goal
  Future<HabitMetrics> getOrCreateMetricsForGoal(int goalId) async {
    final existing = await getMetricsForGoal(goalId);
    if (existing != null) return existing;

    final metrics = HabitMetrics.createDefault(goalId);
    await upsertMetrics(metrics);
    return (await getMetricsForGoal(goalId))!;
  }

  /// Get all habit metrics
  Future<List<HabitMetrics>> getAllMetrics() async {
    return await _isar.habitMetrics.where().findAll();
  }

  /// Get metrics sorted by streak (highest first)
  Future<List<HabitMetrics>> getMetricsByStreak() async {
    return await _isar.habitMetrics
        .where()
        .sortByCurrentStreakDesc()
        .findAll();
  }

  /// Get metrics for goals with active streaks
  Future<List<HabitMetrics>> getActiveStreakMetrics() async {
    return await _isar.habitMetrics
        .filter()
        .currentStreakGreaterThan(0)
        .sortByCurrentStreakDesc()
        .findAll();
  }

  /// Get metrics for goals at risk of losing streak
  Future<List<HabitMetrics>> getAtRiskStreaks() async {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dayBefore = DateTime(now.year, now.month, now.day - 2);

    return await _isar.habitMetrics
        .filter()
        .currentStreakGreaterThan(0)
        .lastCompletedDateBetween(dayBefore, yesterday)
        .sortByCurrentStreakDesc()
        .findAll();
  }

  /// Delete metrics for a goal
  Future<bool> deleteMetricsForGoal(int goalId) async {
    return await _isar.writeTxn(() async {
      final metrics = await _isar.habitMetrics
          .filter()
          .goalIdEqualTo(goalId)
          .findFirst();
      if (metrics != null) {
        return await _isar.habitMetrics.delete(metrics.id);
      }
      return false;
    });
  }

  /// Delete all metrics
  Future<void> deleteAllMetrics() async {
    await _isar.writeTxn(() async {
      await _isar.habitMetrics.clear();
    });
  }

  // === Streak Operations ===

  /// Increment streak for a goal (call when task is completed)
  Future<void> incrementStreak(int goalId, DateTime completedAt) async {
    final metrics = await getOrCreateMetricsForGoal(goalId);
    final completedDate = DateTime(
      completedAt.year,
      completedAt.month,
      completedAt.day,
    );

    if (metrics.lastCompletedDate != null) {
      final lastDate = DateTime(
        metrics.lastCompletedDate!.year,
        metrics.lastCompletedDate!.month,
        metrics.lastCompletedDate!.day,
      );
      final daysDiff = completedDate.difference(lastDate).inDays;

      if (daysDiff == 0) {
        // Already completed today, just update timestamp
        metrics.lastCompletedDate = completedAt;
      } else if (daysDiff == 1) {
        // Consecutive day - increment streak
        metrics.currentStreak++;
        if (metrics.currentStreak > metrics.longestStreak) {
          metrics.longestStreak = metrics.currentStreak;
        }
        metrics.lastCompletedDate = completedAt;
      } else {
        // Streak broken - reset
        metrics.currentStreak = 1;
        metrics.lastCompletedDate = completedAt;
      }
    } else {
      // First completion ever
      metrics.currentStreak = 1;
      metrics.longestStreak = 1;
      metrics.lastCompletedDate = completedAt;
    }

    metrics.totalCompletions++;
    await upsertMetrics(metrics);
  }

  /// Reset streak for a goal (call when scheduled task is skipped)
  Future<void> resetStreak(int goalId) async {
    final metrics = await getMetricsForGoal(goalId);
    if (metrics != null && metrics.currentStreak > 0) {
      metrics.currentStreak = 0;
      await upsertMetrics(metrics);
    }
  }

  /// Increment scheduled count for a goal
  Future<void> incrementScheduled(int goalId) async {
    final metrics = await getOrCreateMetricsForGoal(goalId);
    metrics.totalScheduled++;
    await upsertMetrics(metrics);
  }

  // === Consistency Operations ===

  /// Update consistency scores based on historical data
  Future<void> updateConsistencyScores(
    int goalId, {
    required double consistencyScore,
    required double timeConsistency,
    int? stickyHour,
    int? stickyDayOfWeek,
  }) async {
    final metrics = await getOrCreateMetricsForGoal(goalId);
    metrics.consistencyScore = consistencyScore.clamp(0.0, 1.0);
    metrics.timeConsistency = timeConsistency.clamp(0.0, 1.0);
    metrics.stickyHour = stickyHour;
    metrics.stickyDayOfWeek = stickyDayOfWeek;
    await upsertMetrics(metrics);
  }

  // === Statistics ===

  /// Get total goals with active streaks
  Future<int> getActiveStreakCount() async {
    return await _isar.habitMetrics
        .filter()
        .currentStreakGreaterThan(0)
        .count();
  }

  /// Get the longest current streak across all goals
  Future<int> getLongestCurrentStreak() async {
    final metrics = await _isar.habitMetrics
        .where()
        .sortByCurrentStreakDesc()
        .findFirst();
    return metrics?.currentStreak ?? 0;
  }

  /// Get average consistency score across all goals
  Future<double> getAverageConsistency() async {
    final allMetrics = await getAllMetrics();
    if (allMetrics.isEmpty) return 0.0;
    
    final total = allMetrics.fold<double>(
      0.0,
      (sum, m) => sum + m.consistencyScore,
    );
    return total / allMetrics.length;
  }
}
