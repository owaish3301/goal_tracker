import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/data/models/daily_activity_log.dart';
import 'package:goal_tracker/data/repositories/daily_activity_log_repository.dart';

void main() {
  late Isar isar;
  late DailyActivityLogRepository repository;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [DailyActivityLogSchema],
      directory: '',
      name: 'test_${DateTime.now().millisecondsSinceEpoch}',
    );
    repository = DailyActivityLogRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('DailyActivityLogRepository - CRUD', () {
    test('saveLog saves and retrieves log', () async {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15))
        ..tasksCompleted = 3
        ..productivitySum = 12.0
        ..averageProductivity = 4.0;

      await repository.saveLog(log);

      final retrieved = await repository.getForDate(DateTime(2024, 1, 15));
      expect(retrieved, isNotNull);
      expect(retrieved!.date, DateTime(2024, 1, 15));
      expect(retrieved.tasksCompleted, 3);
      expect(retrieved.productivitySum, 12.0);
    });

    test('getForDate returns null for non-existent date', () async {
      final result = await repository.getForDate(DateTime(2024, 1, 15));
      expect(result, isNull);
    });

    test('getOrCreateForDate creates new log if not exists', () async {
      final date = DateTime(2024, 1, 15);

      final log = await repository.getOrCreateForDate(date);

      expect(log.date, date);
      expect(log.tasksCompleted, 0);

      // Should be persisted
      final retrieved = await repository.getForDate(date);
      expect(retrieved, isNotNull);
    });

    test('getOrCreateForDate returns existing log if exists', () async {
      final date = DateTime(2024, 1, 15);

      // Create initial log with data
      final initial = DailyActivityLog.createForDate(date)..tasksCompleted = 5;
      await repository.saveLog(initial);

      // getOrCreateForDate should return existing
      final retrieved = await repository.getOrCreateForDate(date);
      expect(retrieved.tasksCompleted, 5);
    });
  });

  group('DailyActivityLogRepository - Date Range Queries', () {
    test('getLogsInRange returns logs within date range', () async {
      // Create logs for multiple dates
      for (int i = 10; i <= 20; i++) {
        final log = DailyActivityLog.createForDate(DateTime(2024, 1, i))
          ..tasksCompleted = i;
        await repository.saveLog(log);
      }

      final logs = await repository.getLogsInRange(
        DateTime(2024, 1, 12),
        DateTime(2024, 1, 18),
      );

      expect(logs.length, 7); // 12-18 inclusive
      expect(logs.first.tasksCompleted, 12);
      expect(logs.last.tasksCompleted, 18);
    });

    test('getRecentLogs returns last N days of logs', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);

      // Create logs for last 10 days (going back from today)
      for (int i = 0; i < 10; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        final log = DailyActivityLog.createForDate(date)
          ..tasksCompleted = 10 - i;
        await repository.saveLog(log);
      }

      // getRecentLogs(days: 5) returns logs from last 5 days
      // Days 0, 1, 2, 3, 4 back from today (5 days total + potentially today = up to 6)
      final logs = await repository.getRecentLogs(days: 5);

      // The logs returned should be at most 6 (days 0 through 5 inclusive)
      expect(logs.length, lessThanOrEqualTo(6));
      expect(logs.isNotEmpty, true);
    });
  });

  group('DailyActivityLogRepository - Pattern Aggregation', () {
    test(
      'getActivityPatterns returns learned patterns from activity data',
      () async {
        final now = DateTime.now();
        final normalizedNow = DateTime(now.year, now.month, now.day);

        // Create recent weekday logs with first activity at 7am
        for (int i = 1; i <= 7; i++) {
          final date = normalizedNow.subtract(Duration(days: i));
          if (date.weekday >= 6) continue; // Skip weekends

          final log = DailyActivityLog.createForDate(date)
            ..firstActivityAt = DateTime(date.year, date.month, date.day, 7, 0)
            ..lastActivityAt = DateTime(date.year, date.month, date.day, 22, 0);
          await repository.saveLog(log);
        }

        // Find a recent weekend date
        var recentWeekend = normalizedNow;
        while (recentWeekend.weekday < 6) {
          recentWeekend = recentWeekend.subtract(const Duration(days: 1));
        }

        final weekendLog = DailyActivityLog.createForDate(recentWeekend)
          ..firstActivityAt = DateTime(
            recentWeekend.year,
            recentWeekend.month,
            recentWeekend.day,
            9,
            0,
          )
          ..lastActivityAt = DateTime(
            recentWeekend.year,
            recentWeekend.month,
            recentWeekend.day,
            23,
            0,
          );
        await repository.saveLog(weekendLog);

        final patterns = await repository.getActivityPatterns();

        expect(patterns.weekdayWakeHour, isNotNull);
        expect(patterns.weekendWakeHour, isNotNull);
        expect(patterns.hasAnyPattern, true);
      },
    );

    test('getAverageCompletionRate calculates correctly', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);

      // Create recent logs with varying completion rates
      for (int i = 0; i < 4; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        final log = DailyActivityLog.createForDate(date)
          ..tasksScheduled = 4
          ..tasksCompleted = i + 1; // 1,2,3,4 completions
        await repository.saveLog(log);
      }

      final rate = await repository.getAverageCompletionRate(days: 7);

      // Average: (1/4 + 2/4 + 3/4 + 4/4) / 4 = (0.25 + 0.5 + 0.75 + 1.0) / 4 = 0.625
      expect(rate, closeTo(0.625, 0.01));
    });

    test('getAverageCompletionRate returns 0 when no data', () async {
      final rate = await repository.getAverageCompletionRate(days: 7);
      expect(rate, 0.0);
    });

    test('getAverageWeekdayWakeHour returns correct average', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);

      // Create recent weekday logs with activities at 7am
      for (int i = 1; i <= 7; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        if (date.weekday >= 6) continue; // Skip weekends

        final log = DailyActivityLog.createForDate(date)
          ..firstActivityAt = DateTime(date.year, date.month, date.day, 7, 0);
        await repository.saveLog(log);
      }

      final avgWakeHour = await repository.getAverageWeekdayWakeHour();
      expect(avgWakeHour, 7);
    });

    test('getAverageWeekendWakeHour returns correct average', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);

      // Find recent weekend dates
      var recentSaturday = normalizedNow;
      while (recentSaturday.weekday != 6) {
        recentSaturday = recentSaturday.subtract(const Duration(days: 1));
      }
      final recentSunday = recentSaturday.add(const Duration(days: 1));

      final saturday = DailyActivityLog.createForDate(recentSaturday)
        ..firstActivityAt = DateTime(
          recentSaturday.year,
          recentSaturday.month,
          recentSaturday.day,
          9,
          0,
        );
      await repository.saveLog(saturday);

      final sunday = DailyActivityLog.createForDate(recentSunday)
        ..firstActivityAt = DateTime(
          recentSunday.year,
          recentSunday.month,
          recentSunday.day,
          10,
          0,
        );
      await repository.saveLog(sunday);

      final avgWakeHour = await repository.getAverageWeekendWakeHour();
      expect(avgWakeHour, 10); // (9+10)/2 rounded
    });
  });
}
