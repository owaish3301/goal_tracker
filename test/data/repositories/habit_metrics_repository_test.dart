import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/habit_metrics.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/data/models/task.dart';
import 'package:goal_tracker/data/models/one_time_task.dart';
import 'package:goal_tracker/data/models/productivity_data.dart';
import 'package:goal_tracker/data/models/app_settings.dart';
import 'package:goal_tracker/data/models/scheduled_task.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/data/repositories/habit_metrics_repository.dart';

void main() {
  late Isar isar;
  late HabitMetricsRepository repository;

  setUp(() async {
    // Initialize in-memory Isar instance for testing
    isar = await Isar.open(
      [
        GoalSchema,
        MilestoneSchema,
        TaskSchema,
        OneTimeTaskSchema,
        ProductivityDataSchema,
        AppSettingsSchema,
        HabitMetricsSchema,
        ScheduledTaskSchema,
        UserProfileSchema,
      ],
      directory: '',
      name: 'test_${DateTime.now().millisecondsSinceEpoch}',
    );

    repository = HabitMetricsRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('HabitMetricsRepository', () {
    group('CRUD Operations', () {
      test('upsertMetrics should create new metrics', () async {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 5;

        final id = await repository.upsertMetrics(metrics);

        expect(id, greaterThan(0));
        
        final retrieved = await repository.getMetrics(id);
        expect(retrieved, isNotNull);
        expect(retrieved!.goalId, 1);
        expect(retrieved.currentStreak, 5);
      });

      test('upsertMetrics should update existing metrics', () async {
        final metrics = HabitMetrics.createDefault(1);
        await repository.upsertMetrics(metrics);

        metrics.currentStreak = 10;
        await repository.upsertMetrics(metrics);

        final retrieved = await repository.getMetricsForGoal(1);
        expect(retrieved!.currentStreak, 10);
      });

      test('getMetricsForGoal should return null if not found', () async {
        final result = await repository.getMetricsForGoal(999);
        expect(result, isNull);
      });

      test('getOrCreateMetricsForGoal should create if not exists', () async {
        final metrics = await repository.getOrCreateMetricsForGoal(1);

        expect(metrics, isNotNull);
        expect(metrics.goalId, 1);
        expect(metrics.currentStreak, 0);
      });

      test('getOrCreateMetricsForGoal should return existing', () async {
        final initial = HabitMetrics.createDefault(1);
        initial.currentStreak = 7;
        await repository.upsertMetrics(initial);

        final retrieved = await repository.getOrCreateMetricsForGoal(1);

        expect(retrieved.currentStreak, 7);
      });
    });

    group('Streak Operations', () {
      test('incrementStreak should start streak at 1 for first completion', () async {
        final now = DateTime.now();
        await repository.incrementStreak(1, now);

        final metrics = await repository.getMetricsForGoal(1);
        expect(metrics!.currentStreak, 1);
        expect(metrics.longestStreak, 1);
        expect(metrics.totalCompletions, 1);
      });

      test('incrementStreak should increment for consecutive days', () async {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        await repository.incrementStreak(1, yesterday);

        final today = DateTime.now();
        await repository.incrementStreak(1, today);

        final metrics = await repository.getMetricsForGoal(1);
        expect(metrics!.currentStreak, 2);
        expect(metrics.longestStreak, 2);
        expect(metrics.totalCompletions, 2);
      });

      test('incrementStreak should not increment for same day', () async {
        final now = DateTime.now();
        await repository.incrementStreak(1, now);
        await repository.incrementStreak(1, now);

        final metrics = await repository.getMetricsForGoal(1);
        // Same day completion should NOT increment the streak again
        expect(metrics!.currentStreak, 1);
        // But totalCompletions should be 2 since we have 2 completions
        expect(metrics.totalCompletions, 2);
      });

      test('incrementStreak should reset for non-consecutive days', () async {
        final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
        await repository.incrementStreak(1, twoDaysAgo);

        final today = DateTime.now();
        await repository.incrementStreak(1, today);

        final metrics = await repository.getMetricsForGoal(1);
        expect(metrics!.currentStreak, 1); // Reset to 1
        expect(metrics.longestStreak, 1);
      });

      test('incrementStreak should update longestStreak correctly', () async {
        // Build up a streak
        for (int i = 5; i >= 0; i--) {
          final date = DateTime.now().subtract(Duration(days: i));
          await repository.incrementStreak(1, date);
        }

        final metrics = await repository.getMetricsForGoal(1);
        expect(metrics!.currentStreak, 6);
        expect(metrics.longestStreak, 6);
      });

      test('resetStreak should set currentStreak to 0', () async {
        final now = DateTime.now();
        await repository.incrementStreak(1, now);

        await repository.resetStreak(1);

        final metrics = await repository.getMetricsForGoal(1);
        expect(metrics!.currentStreak, 0);
        expect(metrics.longestStreak, 1); // Longest should remain
      });

      test('incrementScheduled should increment totalScheduled', () async {
        await repository.incrementScheduled(1);
        await repository.incrementScheduled(1);
        await repository.incrementScheduled(1);

        final metrics = await repository.getMetricsForGoal(1);
        expect(metrics!.totalScheduled, 3);
      });
    });

    group('Consistency Operations', () {
      test('updateConsistencyScores should update all consistency fields', () async {
        await repository.getOrCreateMetricsForGoal(1);

        await repository.updateConsistencyScores(
          1,
          consistencyScore: 0.85,
          timeConsistency: 0.75,
          stickyHour: 9,
          stickyDayOfWeek: 1,
        );

        final metrics = await repository.getMetricsForGoal(1);
        expect(metrics!.consistencyScore, 0.85);
        expect(metrics.timeConsistency, 0.75);
        expect(metrics.stickyHour, 9);
        expect(metrics.stickyDayOfWeek, 1);
      });

      test('updateConsistencyScores should clamp values', () async {
        await repository.getOrCreateMetricsForGoal(1);

        await repository.updateConsistencyScores(
          1,
          consistencyScore: 1.5, // Over 1.0
          timeConsistency: -0.5, // Under 0.0
        );

        final metrics = await repository.getMetricsForGoal(1);
        expect(metrics!.consistencyScore, 1.0);
        expect(metrics.timeConsistency, 0.0);
      });
    });

    group('Query Methods', () {
      test('getMetricsByStreak should return sorted by streak descending', () async {
        final metrics1 = HabitMetrics.createDefault(1);
        metrics1.currentStreak = 5;
        await repository.upsertMetrics(metrics1);

        final metrics2 = HabitMetrics.createDefault(2);
        metrics2.currentStreak = 10;
        await repository.upsertMetrics(metrics2);

        final metrics3 = HabitMetrics.createDefault(3);
        metrics3.currentStreak = 3;
        await repository.upsertMetrics(metrics3);

        final sorted = await repository.getMetricsByStreak();
        expect(sorted.length, 3);
        expect(sorted[0].currentStreak, 10);
        expect(sorted[1].currentStreak, 5);
        expect(sorted[2].currentStreak, 3);
      });

      test('getActiveStreakMetrics should only return active streaks', () async {
        final active = HabitMetrics.createDefault(1);
        active.currentStreak = 5;
        await repository.upsertMetrics(active);

        final inactive = HabitMetrics.createDefault(2);
        inactive.currentStreak = 0;
        await repository.upsertMetrics(inactive);

        final result = await repository.getActiveStreakMetrics();
        expect(result.length, 1);
        expect(result[0].goalId, 1);
      });

      test('getActiveStreakCount should return correct count', () async {
        final active1 = HabitMetrics.createDefault(1);
        active1.currentStreak = 5;
        await repository.upsertMetrics(active1);

        final active2 = HabitMetrics.createDefault(2);
        active2.currentStreak = 10;
        await repository.upsertMetrics(active2);

        final inactive = HabitMetrics.createDefault(3);
        inactive.currentStreak = 0;
        await repository.upsertMetrics(inactive);

        final count = await repository.getActiveStreakCount();
        expect(count, 2);
      });

      test('getLongestCurrentStreak should return highest streak', () async {
        final m1 = HabitMetrics.createDefault(1);
        m1.currentStreak = 5;
        await repository.upsertMetrics(m1);

        final m2 = HabitMetrics.createDefault(2);
        m2.currentStreak = 15;
        await repository.upsertMetrics(m2);

        final longest = await repository.getLongestCurrentStreak();
        expect(longest, 15);
      });

      test('getAverageConsistency should calculate correctly', () async {
        final m1 = HabitMetrics.createDefault(1);
        m1.consistencyScore = 0.8;
        await repository.upsertMetrics(m1);

        final m2 = HabitMetrics.createDefault(2);
        m2.consistencyScore = 0.6;
        await repository.upsertMetrics(m2);

        final avg = await repository.getAverageConsistency();
        expect(avg, closeTo(0.7, 0.01));
      });
    });

    group('Deletion', () {
      test('deleteMetricsForGoal should delete metrics', () async {
        final metrics = HabitMetrics.createDefault(1);
        await repository.upsertMetrics(metrics);

        final deleted = await repository.deleteMetricsForGoal(1);
        expect(deleted, true);

        final retrieved = await repository.getMetricsForGoal(1);
        expect(retrieved, isNull);
      });

      test('deleteMetricsForGoal should return false if not found', () async {
        final deleted = await repository.deleteMetricsForGoal(999);
        expect(deleted, false);
      });

      test('deleteAllMetrics should clear all metrics', () async {
        await repository.upsertMetrics(HabitMetrics.createDefault(1));
        await repository.upsertMetrics(HabitMetrics.createDefault(2));
        await repository.upsertMetrics(HabitMetrics.createDefault(3));

        await repository.deleteAllMetrics();

        final all = await repository.getAllMetrics();
        expect(all, isEmpty);
      });
    });
  });
}
