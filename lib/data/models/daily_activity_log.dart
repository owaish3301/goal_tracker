import 'package:isar/isar.dart';

part 'daily_activity_log.g.dart';

/// Tracks actual user activity per day for dynamic wake/sleep time learning
/// This allows the ML to adapt to real user behavior rather than just profile defaults
@collection
class DailyActivityLog {
  Id id = Isar.autoIncrement;

  /// The date this log is for (normalized to midnight)
  @Index(unique: true)
  late DateTime date;

  /// First activity timestamp of the day (approximates wake time)
  DateTime? firstActivityAt;

  /// Last activity timestamp of the day (approximates sleep time)
  DateTime? lastActivityAt;

  /// Number of tasks completed this day
  late int tasksCompleted;

  /// Number of tasks scheduled this day
  late int tasksScheduled;

  /// Number of tasks skipped this day
  late int tasksSkipped;

  /// Average productivity rating for the day (1.0-5.0)
  late double averageProductivity;

  /// Sum of all productivity ratings (for calculating running average)
  late double productivitySum;

  /// Whether this is a weekend day
  late bool isWeekend;

  /// Day of week (0=Monday, 6=Sunday)
  late int dayOfWeek;

  /// When this log was last updated
  late DateTime updatedAt;

  // === MANUAL OVERRIDES (Smart Sleep Logic) ===

  /// Manually overridden wake hour (set by user)
  int? manualWakeHour;

  /// Manually overridden sleep hour (set by user)
  int? manualSleepHour;

  /// Whether the schedule for this day is locked (confirmed by user)
  bool isScheduleLocked = false;

  /// Whether detected times were flagged as anomalous
  bool wasAnomaly = false;

  // === Computed Properties ===

  /// Effective wake hour based on first activity
  @ignore
  int? get effectiveWakeHour => firstActivityAt?.hour;

  /// Effective sleep hour based on last activity
  @ignore
  int? get effectiveSleepHour => lastActivityAt?.hour;

  /// Active window duration in hours
  @ignore
  double? get activeWindowHours {
    if (firstActivityAt == null || lastActivityAt == null) return null;
    return lastActivityAt!.difference(firstActivityAt!).inMinutes / 60.0;
  }

  /// Completion rate for the day (0.0 - 1.0)
  @ignore
  double get completionRate {
    if (tasksScheduled == 0) return 0.0;
    return tasksCompleted / tasksScheduled;
  }

  /// Create a new log for a date
  static DailyActivityLog createForDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final dow = normalized.weekday - 1; // 0=Monday
    return DailyActivityLog()
      ..date = normalized
      ..firstActivityAt = null
      ..lastActivityAt = null
      ..tasksCompleted = 0
      ..tasksScheduled = 0
      ..tasksSkipped = 0
      ..averageProductivity = 0.0
      ..productivitySum = 0.0
      ..isWeekend =
          dow >=
          5 // Saturday or Sunday
      ..dayOfWeek = dow
      ..updatedAt = DateTime.now();
  }

  /// Record an activity (updates first/last activity timestamps)
  void recordActivity(DateTime activityTime) {
    if (firstActivityAt == null || activityTime.isBefore(firstActivityAt!)) {
      firstActivityAt = activityTime;
    }
    if (lastActivityAt == null || activityTime.isAfter(lastActivityAt!)) {
      lastActivityAt = activityTime;
    }
    updatedAt = DateTime.now();
  }

  /// Record a task completion with rating
  void recordTaskCompletion(double productivityRating) {
    tasksCompleted++;
    productivitySum += productivityRating;
    averageProductivity = productivitySum / tasksCompleted;
    updatedAt = DateTime.now();
  }

  /// Record a scheduled task
  void recordTaskScheduled() {
    tasksScheduled++;
    updatedAt = DateTime.now();
  }

  /// Record a skipped task
  void recordTaskSkipped() {
    tasksSkipped++;
    updatedAt = DateTime.now();
  }

  @override
  String toString() {
    return 'DailyActivityLog(date: $date, wake: $effectiveWakeHour, '
        'sleep: $effectiveSleepHour, completed: $tasksCompleted/$tasksScheduled)';
  }
}
