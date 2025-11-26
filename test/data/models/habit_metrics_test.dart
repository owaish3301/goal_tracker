import 'package:flutter_test/flutter_test.dart';
import 'package:goal_tracker/data/models/habit_metrics.dart';

void main() {
  group('HabitMetrics', () {
    group('createDefault', () {
      test('creates metrics with default values', () {
        final metrics = HabitMetrics.createDefault(1);

        expect(metrics.goalId, 1);
        expect(metrics.currentStreak, 0);
        expect(metrics.longestStreak, 0);
        expect(metrics.consistencyScore, 0.0);
        expect(metrics.timeConsistency, 0.0);
        expect(metrics.totalCompletions, 0);
        expect(metrics.totalScheduled, 0);
        expect(metrics.lastCompletedDate, isNull);
        expect(metrics.stickyHour, isNull);
        expect(metrics.stickyDayOfWeek, isNull);
      });
    });

    group('habitStage', () {
      test('returns Starting for streak < 3', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 2;
        expect(metrics.habitStage, 'Starting');
      });

      test('returns Building for streak 3-6', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 5;
        expect(metrics.habitStage, 'Building');
      });

      test('returns Almost There for streak 7-20', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 14;
        expect(metrics.habitStage, 'Almost There');
      });

      test('returns Habit Locked for streak >= 21', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 21;
        expect(metrics.habitStage, 'Habit Locked');
      });

      test('returns Habit Locked for streak > 21', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 50;
        expect(metrics.habitStage, 'Habit Locked');
      });
    });

    group('daysUntilHabitLock', () {
      test('returns 21 when streak is 0', () {
        final metrics = HabitMetrics.createDefault(1);
        expect(metrics.daysUntilHabitLock, 21);
      });

      test('returns correct days remaining', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 7;
        expect(metrics.daysUntilHabitLock, 14);
      });

      test('returns 0 when streak >= 21', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 25;
        expect(metrics.daysUntilHabitLock, 0);
      });
    });

    group('streakAtRisk', () {
      test('returns false when lastCompletedDate is null', () {
        final metrics = HabitMetrics.createDefault(1);
        expect(metrics.streakAtRisk, false);
      });

      test('returns false when streak is 0', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.lastCompletedDate = DateTime.now().subtract(
          const Duration(days: 2),
        );
        expect(metrics.streakAtRisk, false);
      });

      test('returns false when completed today', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 5;
        metrics.lastCompletedDate = DateTime.now();
        expect(metrics.streakAtRisk, false);
      });

      test('returns true when last completed yesterday and not today', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 5;
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        metrics.lastCompletedDate = DateTime(
          yesterday.year,
          yesterday.month,
          yesterday.day,
          10,
        );
        expect(metrics.streakAtRisk, true);
      });
    });

    group('isHabitLocked', () {
      test('returns false when streak < 21', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 20;
        expect(metrics.isHabitLocked, false);
      });

      test('returns true when streak = 21', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 21;
        expect(metrics.isHabitLocked, true);
      });

      test('returns true when streak > 21', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.currentStreak = 100;
        expect(metrics.isHabitLocked, true);
      });
    });

    group('completionRate', () {
      test('returns 0 when totalScheduled is 0', () {
        final metrics = HabitMetrics.createDefault(1);
        expect(metrics.completionRate, 0.0);
      });

      test('returns correct rate', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.totalCompletions = 15;
        metrics.totalScheduled = 20;
        expect(metrics.completionRate, 0.75);
      });

      test('handles 100% completion', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.totalCompletions = 10;
        metrics.totalScheduled = 10;
        expect(metrics.completionRate, 1.0);
      });
    });

    group('formattedStickyTime', () {
      test('returns null when stickyHour is null', () {
        final metrics = HabitMetrics.createDefault(1);
        expect(metrics.formattedStickyTime, isNull);
      });

      test('formats AM hours correctly', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.stickyHour = 9;
        expect(metrics.formattedStickyTime, '9 AM');
      });

      test('formats PM hours correctly', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.stickyHour = 14;
        expect(metrics.formattedStickyTime, '2 PM');
      });

      test('formats noon correctly', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.stickyHour = 12;
        expect(metrics.formattedStickyTime, '12 PM');
      });

      test('formats midnight correctly', () {
        final metrics = HabitMetrics.createDefault(1);
        metrics.stickyHour = 0;
        expect(metrics.formattedStickyTime, '12 AM');
      });
    });
  });
}
