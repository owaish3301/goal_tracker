import 'package:isar/isar.dart';
import '../models/daily_activity_log.dart';

/// Repository for managing daily activity logs
class DailyActivityLogRepository {
  final Isar _isar;

  DailyActivityLogRepository(this._isar);

  // === CRUD Operations ===

  /// Get or create a log for a specific date
  Future<DailyActivityLog> getOrCreateForDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);

    var log = await _isar.dailyActivityLogs
        .filter()
        .dateEqualTo(normalized)
        .findFirst();

    if (log == null) {
      log = DailyActivityLog.createForDate(normalized);
      await _isar.writeTxn(() async {
        await _isar.dailyActivityLogs.put(log!);
      });
    }

    return log;
  }

  /// Get log for a specific date (returns null if not exists)
  Future<DailyActivityLog?> getForDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    return await _isar.dailyActivityLogs
        .filter()
        .dateEqualTo(normalized)
        .findFirst();
  }

  /// Save/update a log
  Future<int> saveLog(DailyActivityLog log) async {
    log.updatedAt = DateTime.now();
    return await _isar.writeTxn(() async {
      return await _isar.dailyActivityLogs.put(log);
    });
  }

  /// Get logs for a date range
  Future<List<DailyActivityLog>> getLogsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return await _isar.dailyActivityLogs
        .filter()
        .dateBetween(start, end)
        .sortByDate()
        .findAll();
  }

  /// Get recent logs (last N days)
  Future<List<DailyActivityLog>> getRecentLogs({int days = 30}) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    return getLogsInRange(startDate, endDate);
  }

  // === Wake/Sleep Pattern Analysis ===

  /// Calculate average wake hour for weekdays
  Future<(int?, int)> getAverageWeekdayWakeHour({int lookbackDays = 14}) async {
    final logs = await getRecentLogs(days: lookbackDays);
    final weekdayLogs = logs
        .where((l) => !l.isWeekend && l.firstActivityAt != null)
        .toList();

    if (weekdayLogs.isEmpty) return (null, 0);

    final totalHours = weekdayLogs.fold<int>(
      0,
      (sum, log) => sum + log.firstActivityAt!.hour,
    );
    return ((totalHours / weekdayLogs.length).round(), weekdayLogs.length);
  }

  /// Calculate average wake hour for weekends
  Future<(int?, int)> getAverageWeekendWakeHour({int lookbackDays = 14}) async {
    final logs = await getRecentLogs(days: lookbackDays);
    final weekendLogs = logs
        .where((l) => l.isWeekend && l.firstActivityAt != null)
        .toList();

    if (weekendLogs.isEmpty) return (null, 0);

    final totalHours = weekendLogs.fold<int>(
      0,
      (sum, log) => sum + log.firstActivityAt!.hour,
    );
    return ((totalHours / weekendLogs.length).round(), weekendLogs.length);
  }

  /// Calculate average sleep hour for weekdays
  Future<(int?, int)> getAverageWeekdaySleepHour({
    int lookbackDays = 14,
  }) async {
    final logs = await getRecentLogs(days: lookbackDays);
    final weekdayLogs = logs
        .where((l) => !l.isWeekend && l.lastActivityAt != null)
        .toList();

    if (weekdayLogs.isEmpty) return (null, 0);

    final totalHours = weekdayLogs.fold<int>(
      0,
      (sum, log) => sum + log.lastActivityAt!.hour,
    );
    return ((totalHours / weekdayLogs.length).round(), weekdayLogs.length);
  }

  /// Calculate average sleep hour for weekends
  Future<(int?, int)> getAverageWeekendSleepHour({
    int lookbackDays = 14,
  }) async {
    final logs = await getRecentLogs(days: lookbackDays);
    final weekendLogs = logs
        .where((l) => l.isWeekend && l.lastActivityAt != null)
        .toList();

    if (weekendLogs.isEmpty) return (null, 0);

    final totalHours = weekendLogs.fold<int>(
      0,
      (sum, log) => sum + log.lastActivityAt!.hour,
    );
    return ((totalHours / weekendLogs.length).round(), weekendLogs.length);
  }

  /// Get learned activity patterns
  Future<ActivityPatterns> getActivityPatterns({int lookbackDays = 14}) async {
    final (weekdayWake, weekdayWakeCount) = await getAverageWeekdayWakeHour(
      lookbackDays: lookbackDays,
    );
    final (weekendWake, weekendWakeCount) = await getAverageWeekendWakeHour(
      lookbackDays: lookbackDays,
    );
    final (weekdaySleep, _) = await getAverageWeekdaySleepHour(
      lookbackDays: lookbackDays,
    );
    final (weekendSleep, _) = await getAverageWeekendSleepHour(
      lookbackDays: lookbackDays,
    );

    return ActivityPatterns(
      weekdayWakeHour: weekdayWake,
      weekendWakeHour: weekendWake,
      weekdaySleepHour: weekdaySleep,
      weekendSleepHour: weekendSleep,
      weekdayDataPoints: weekdayWakeCount,
      weekendDataPoints: weekendWakeCount,
    );
  }

  // === Statistics ===

  /// Get average completion rate over recent days
  Future<double> getAverageCompletionRate({int days = 7}) async {
    final logs = await getRecentLogs(days: days);
    if (logs.isEmpty) return 0.0;

    final totalRate = logs.fold<double>(
      0.0,
      (sum, log) => sum + log.completionRate,
    );
    return totalRate / logs.length;
  }

  /// Get average productivity over recent days
  Future<double> getAverageProductivity({int days = 7}) async {
    final logs = await getRecentLogs(days: days);
    final logsWithRatings = logs.where((l) => l.tasksCompleted > 0).toList();

    if (logsWithRatings.isEmpty) return 0.0;

    final totalProductivity = logsWithRatings.fold<double>(
      0.0,
      (sum, log) => sum + log.averageProductivity,
    );
    return totalProductivity / logsWithRatings.length;
  }

  /// Get total tasks completed in recent days
  Future<int> getTotalTasksCompleted({int days = 7}) async {
    final logs = await getRecentLogs(days: days);
    return logs.fold<int>(0, (sum, log) => sum + log.tasksCompleted);
  }

  /// Delete old logs (keep last N days)
  Future<int> deleteOldLogs({int keepDays = 90}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: keepDays));
    final normalized = DateTime(
      cutoffDate.year,
      cutoffDate.month,
      cutoffDate.day,
    );

    return await _isar.writeTxn(() async {
      return await _isar.dailyActivityLogs
          .filter()
          .dateLessThan(normalized)
          .deleteAll();
    });
  }
}

/// Learned activity patterns for weekday/weekend
class ActivityPatterns {
  final int? weekdayWakeHour;
  final int? weekendWakeHour;
  final int? weekdaySleepHour;
  final int? weekendSleepHour;
  final int weekdayDataPoints;
  final int weekendDataPoints;

  ActivityPatterns({
    this.weekdayWakeHour,
    this.weekendWakeHour,
    this.weekdaySleepHour,
    this.weekendSleepHour,
    this.weekdayDataPoints = 0,
    this.weekendDataPoints = 0,
  });

  /// Get effective wake hour for a given date
  int? getWakeHourForDate(DateTime date) {
    final isWeekend = date.weekday >= 6;
    return isWeekend ? weekendWakeHour : weekdayWakeHour;
  }

  /// Get effective sleep hour for a given date
  int? getSleepHourForDate(DateTime date) {
    final isWeekend = date.weekday >= 6;
    return isWeekend ? weekendSleepHour : weekdaySleepHour;
  }

  /// Check if we have enough data for patterns
  bool get hasWeekdayPattern =>
      weekdayWakeHour != null && weekdaySleepHour != null;
  bool get hasWeekendPattern =>
      weekendWakeHour != null && weekendSleepHour != null;
  bool get hasAnyPattern => hasWeekdayPattern || hasWeekendPattern;

  @override
  String toString() {
    return 'ActivityPatterns(weekday: $weekdayWakeHour-$weekdaySleepHour ($weekdayDataPoints), '
        'weekend: $weekendWakeHour-$weekendSleepHour ($weekendDataPoints))';
  }
}
