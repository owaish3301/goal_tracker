import '../../data/repositories/daily_activity_log_repository.dart';
import '../../data/repositories/user_profile_repository.dart';

/// Service for managing daily activity tracking and wake/sleep pattern learning
/// Provides dynamic wake/sleep times that adapt to actual user behavior
class DailyActivityService {
  final DailyActivityLogRepository _activityRepo;
  final UserProfileRepository _profileRepo;

  DailyActivityService(this._activityRepo, this._profileRepo);

  // === Activity Recording ===

  /// Record user activity (call when user interacts with app)
  Future<void> recordActivity(DateTime activityTime) async {
    final log = await _activityRepo.getOrCreateForDate(activityTime);
    log.recordActivity(activityTime);
    await _activityRepo.saveLog(log);
  }

  /// Record task completion
  Future<void> recordTaskCompletion({
    required DateTime completionTime,
    required double productivityRating,
  }) async {
    final log = await _activityRepo.getOrCreateForDate(completionTime);
    log.recordActivity(completionTime);
    log.recordTaskCompletion(productivityRating);
    await _activityRepo.saveLog(log);
  }

  /// Record task scheduled
  Future<void> recordTaskScheduled(DateTime date) async {
    final log = await _activityRepo.getOrCreateForDate(date);
    log.recordTaskScheduled();
    await _activityRepo.saveLog(log);
  }

  /// Record task skipped
  Future<void> recordTaskSkipped(DateTime date) async {
    final log = await _activityRepo.getOrCreateForDate(date);
    log.recordTaskSkipped();
    await _activityRepo.saveLog(log);
  }

  // === Dynamic Wake/Sleep Time ===

  /// Get effective wake hour for a date
  /// Priority: learned pattern > profile default
  Future<int> getEffectiveWakeHour(DateTime date) async {
    final patterns = await _activityRepo.getActivityPatterns();
    final isWeekend = date.weekday >= 6;

    // Try learned pattern first
    if (isWeekend && patterns.weekendWakeHour != null) {
      return patterns.weekendWakeHour!;
    }
    if (!isWeekend && patterns.weekdayWakeHour != null) {
      return patterns.weekdayWakeHour!;
    }

    // Fall back to user profile
    final profile = await _profileRepo.getProfile();
    if (profile != null) {
      return profile.wakeUpHour;
    }

    // Default fallback
    return isWeekend ? 8 : 7;
  }

  /// Get effective sleep hour for a date
  /// Priority: learned pattern > profile default
  Future<int> getEffectiveSleepHour(DateTime date) async {
    final patterns = await _activityRepo.getActivityPatterns();
    final isWeekend = date.weekday >= 6;

    // Try learned pattern first
    if (isWeekend && patterns.weekendSleepHour != null) {
      return patterns.weekendSleepHour!;
    }
    if (!isWeekend && patterns.weekdaySleepHour != null) {
      return patterns.weekdaySleepHour!;
    }

    // Fall back to user profile
    final profile = await _profileRepo.getProfile();
    if (profile != null) {
      return profile.sleepHour;
    }

    // Default fallback
    return 23;
  }

  /// Get the effective active window for a date
  Future<ActiveWindow> getActiveWindow(DateTime date) async {
    final wakeHour = await getEffectiveWakeHour(date);
    final sleepHour = await getEffectiveSleepHour(date);

    return ActiveWindow(
      wakeHour: wakeHour,
      sleepHour: sleepHour,
      date: date,
    );
  }

  // === Context Calculations for ML ===

  /// Calculate relative position in the day (0.0 = wake, 1.0 = sleep)
  Future<double> calculateRelativeTimeInDay(DateTime time) async {
    final wakeHour = await getEffectiveWakeHour(time);
    final sleepHour = await getEffectiveSleepHour(time);

    return _calculateRelativeTime(
      currentHour: time.hour,
      wakeHour: wakeHour,
      sleepHour: sleepHour,
    );
  }

  double _calculateRelativeTime({
    required int currentHour,
    required int wakeHour,
    required int sleepHour,
  }) {
    // Handle wrap-around (e.g., sleep at 1 AM)
    int effectiveSleep = sleepHour;
    if (sleepHour < wakeHour) {
      effectiveSleep = sleepHour + 24;
    }

    int effectiveCurrent = currentHour;
    if (currentHour < wakeHour) {
      effectiveCurrent = currentHour + 24;
    }

    final activeWindow = effectiveSleep - wakeHour;
    if (activeWindow <= 0) return 0.5; // Fallback

    final position = effectiveCurrent - wakeHour;
    return (position / activeWindow).clamp(0.0, 1.0);
  }

  /// Get minutes since first activity today
  Future<int> getMinutesSinceFirstActivity(DateTime time) async {
    final log = await _activityRepo.getForDate(time);
    if (log?.firstActivityAt == null) return 0;

    return time.difference(log!.firstActivityAt!).inMinutes.abs();
  }

  /// Get today's task completion context
  Future<TaskCompletionContext> getTodayContext(DateTime date) async {
    final log = await _activityRepo.getOrCreateForDate(date);
    final completionRate = await _activityRepo.getAverageCompletionRate(days: 7);

    return TaskCompletionContext(
      taskOrderInDay: log.tasksCompleted + 1, // Next task order
      totalTasksScheduledToday: log.tasksScheduled,
      tasksCompletedBeforeThis: log.tasksCompleted,
      completionRateLast7Days: completionRate,
    );
  }

  /// Get previous task rating (for momentum calculation)
  Future<double> getPreviousTaskRating(DateTime date) async {
    final log = await _activityRepo.getForDate(date);
    if (log == null || log.tasksCompleted == 0) return 0.0;
    return log.averageProductivity;
  }

  // === Statistics ===

  /// Get activity summary for a date
  Future<DailyActivitySummary> getDailySummary(DateTime date) async {
    final log = await _activityRepo.getForDate(date);
    final window = await getActiveWindow(date);

    return DailyActivitySummary(
      date: date,
      firstActivityAt: log?.firstActivityAt,
      lastActivityAt: log?.lastActivityAt,
      tasksCompleted: log?.tasksCompleted ?? 0,
      tasksScheduled: log?.tasksScheduled ?? 0,
      tasksSkipped: log?.tasksSkipped ?? 0,
      averageProductivity: log?.averageProductivity ?? 0.0,
      activeWindow: window,
    );
  }

  /// Check if we have enough data to learn patterns
  Future<bool> hasLearnedPatterns() async {
    final patterns = await _activityRepo.getActivityPatterns();
    return patterns.hasAnyPattern;
  }
}

/// Represents the user's active window for a day
class ActiveWindow {
  final int wakeHour;
  final int sleepHour;
  final DateTime date;

  ActiveWindow({
    required this.wakeHour,
    required this.sleepHour,
    required this.date,
  });

  /// Duration of active window in hours
  int get durationHours {
    if (sleepHour > wakeHour) {
      return sleepHour - wakeHour;
    }
    return (24 - wakeHour) + sleepHour; // Wrap around midnight
  }

  /// Check if a given hour is within the active window
  bool isActiveHour(int hour) {
    if (sleepHour > wakeHour) {
      return hour >= wakeHour && hour < sleepHour;
    }
    // Wrap around midnight
    return hour >= wakeHour || hour < sleepHour;
  }

  @override
  String toString() => 'ActiveWindow($wakeHour:00 - $sleepHour:00)';
}

/// Context for task completion (used by ML)
class TaskCompletionContext {
  final int taskOrderInDay;
  final int totalTasksScheduledToday;
  final int tasksCompletedBeforeThis;
  final double completionRateLast7Days;

  TaskCompletionContext({
    required this.taskOrderInDay,
    required this.totalTasksScheduledToday,
    required this.tasksCompletedBeforeThis,
    required this.completionRateLast7Days,
  });
}

/// Daily activity summary
class DailyActivitySummary {
  final DateTime date;
  final DateTime? firstActivityAt;
  final DateTime? lastActivityAt;
  final int tasksCompleted;
  final int tasksScheduled;
  final int tasksSkipped;
  final double averageProductivity;
  final ActiveWindow activeWindow;

  DailyActivitySummary({
    required this.date,
    this.firstActivityAt,
    this.lastActivityAt,
    required this.tasksCompleted,
    required this.tasksScheduled,
    required this.tasksSkipped,
    required this.averageProductivity,
    required this.activeWindow,
  });

  double get completionRate {
    if (tasksScheduled == 0) return 0.0;
    return tasksCompleted / tasksScheduled;
  }
}
