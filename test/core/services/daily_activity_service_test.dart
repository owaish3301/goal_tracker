import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/data/models/daily_activity_log.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/data/repositories/daily_activity_log_repository.dart';
import 'package:goal_tracker/data/repositories/user_profile_repository.dart';
import 'package:goal_tracker/core/services/daily_activity_service.dart';

/// Create a properly initialized test UserProfile
UserProfile createTestProfile({
  int wakeUpHour = 7,
  int sleepHour = 22,
  ChronoType chronoType = ChronoType.normal,
}) {
  return UserProfile()
    ..wakeUpHour = wakeUpHour
    ..sleepHour = sleepHour
    ..chronoType = chronoType
    ..hasWorkSchedule = false
    ..preferredSessionLength = SessionLength.medium
    ..prefersRoutine = true
    ..onboardingCompleted = true
    ..createdAt = DateTime.now();
}

void main() {
  late Isar isar;
  late DailyActivityLogRepository activityRepo;
  late UserProfileRepository profileRepo;
  late DailyActivityService service;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [DailyActivityLogSchema, UserProfileSchema],
      directory: '',
      name: 'test_${DateTime.now().millisecondsSinceEpoch}',
    );
    activityRepo = DailyActivityLogRepository(isar);
    profileRepo = UserProfileRepository(isar);
    service = DailyActivityService(activityRepo, profileRepo);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('DailyActivityService - Activity Recording', () {
    test('recordActivity updates first and last activity', () async {
      final time = DateTime(2024, 1, 15, 9, 30);
      
      await service.recordActivity(time);
      
      final log = await activityRepo.getForDate(time);
      expect(log, isNotNull);
      expect(log!.firstActivityAt, time);
      expect(log.lastActivityAt, time);
    });
    
    test('recordTaskCompletion updates log counters', () async {
      final time = DateTime(2024, 1, 15, 10, 0);
      
      await service.recordTaskCompletion(
        completionTime: time,
        productivityRating: 4.0,
      );
      
      final log = await activityRepo.getForDate(time);
      expect(log, isNotNull);
      expect(log!.tasksCompleted, 1);
      expect(log.productivitySum, 4.0);
    });
    
    test('recordTaskScheduled updates scheduled count', () async {
      final date = DateTime(2024, 1, 15);
      
      await service.recordTaskScheduled(date);
      await service.recordTaskScheduled(date);
      
      final log = await activityRepo.getForDate(date);
      expect(log!.tasksScheduled, 2);
    });
    
    test('recordTaskSkipped updates skipped count', () async {
      final date = DateTime(2024, 1, 15);
      
      await service.recordTaskSkipped(date);
      
      final log = await activityRepo.getForDate(date);
      expect(log!.tasksSkipped, 1);
    });
  });
  
  group('DailyActivityService - Dynamic Wake/Sleep Hours', () {
    test('getEffectiveWakeHour returns profile default when no patterns', () async {
      final profile = createTestProfile(wakeUpHour: 6, sleepHour: 22);
      await profileRepo.saveProfile(profile);
      
      final wakeHour = await service.getEffectiveWakeHour(DateTime(2024, 1, 15));
      
      expect(wakeHour, 6);
    });
    
    test('getEffectiveWakeHour returns learned weekday pattern', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);
      
      // Create recent logs with learned weekday pattern (activity at 7am)
      for (int i = 1; i <= 7; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        if (date.weekday < 6) {
          final log = DailyActivityLog.createForDate(date)
            ..firstActivityAt = DateTime(date.year, date.month, date.day, 7, 0);
          await activityRepo.saveLog(log);
        }
      }
      
      // Query for a weekday
      var testDate = normalizedNow;
      while (testDate.weekday >= 6) {
        testDate = testDate.subtract(Duration(days: 1));
      }
      
      final wakeHour = await service.getEffectiveWakeHour(testDate);
      expect(wakeHour, 7);
    });
    
    test('getEffectiveWakeHour returns learned weekend pattern for weekends', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);
      
      // Find recent weekend dates within lookback period
      var recentSaturday = normalizedNow;
      while (recentSaturday.weekday != 6) {
        recentSaturday = recentSaturday.subtract(Duration(days: 1));
      }
      final recentSunday = recentSaturday.add(Duration(days: 1));
      
      final saturday = DailyActivityLog.createForDate(recentSaturday)
        ..firstActivityAt = DateTime(recentSaturday.year, recentSaturday.month, recentSaturday.day, 9, 0);
      await activityRepo.saveLog(saturday);
      
      final sunday = DailyActivityLog.createForDate(recentSunday)
        ..firstActivityAt = DateTime(recentSunday.year, recentSunday.month, recentSunday.day, 9, 0);
      await activityRepo.saveLog(sunday);
      
      // Query for a weekend day (use recentSaturday)
      final wakeHour = await service.getEffectiveWakeHour(recentSaturday);
      expect(wakeHour, 9);
    });
    
    test('getEffectiveWakeHour returns default 8 for weekend when no data', () async {
      // Find a Saturday
      var saturday = DateTime.now();
      while (saturday.weekday != 6) {
        saturday = saturday.add(Duration(days: 1));
      }
      
      final wakeHour = await service.getEffectiveWakeHour(saturday);
      expect(wakeHour, 8); // Weekend default
    });
    
    test('getEffectiveWakeHour returns default 7 for weekday when no data', () async {
      // Find a Monday
      var monday = DateTime.now();
      while (monday.weekday != 1) {
        monday = monday.add(Duration(days: 1));
      }
      
      final wakeHour = await service.getEffectiveWakeHour(monday);
      expect(wakeHour, 7); // Weekday default
    });
    
    test('getEffectiveSleepHour returns profile default when no patterns', () async {
      final profile = createTestProfile(wakeUpHour: 6, sleepHour: 22);
      await profileRepo.saveProfile(profile);
      
      final sleepHour = await service.getEffectiveSleepHour(DateTime(2024, 1, 15));
      expect(sleepHour, 22);
    });
    
    test('getActiveWindow returns correct window', () async {
      final profile = createTestProfile(wakeUpHour: 7, sleepHour: 23);
      await profileRepo.saveProfile(profile);
      
      final window = await service.getActiveWindow(DateTime(2024, 1, 15));
      
      expect(window.wakeHour, 7);
      expect(window.sleepHour, 23);
      expect(window.durationHours, 16);
    });
  });
  
  group('DailyActivityService - Context Calculations', () {
    test('calculateRelativeTimeInDay returns 0.5 at midpoint', () async {
      final profile = createTestProfile(wakeUpHour: 6, sleepHour: 22); // 16 hour window
      await profileRepo.saveProfile(profile);
      
      // Midpoint at 14:00 (6 + 8 hours)
      final time = DateTime(2024, 1, 15, 14, 0);
      final relative = await service.calculateRelativeTimeInDay(time);
      
      expect(relative, closeTo(0.5, 0.1));
    });
    
    test('calculateRelativeTimeInDay returns 0.0 at wake time', () async {
      final profile = createTestProfile(wakeUpHour: 6, sleepHour: 22);
      await profileRepo.saveProfile(profile);
      
      final time = DateTime(2024, 1, 15, 6, 0);
      final relative = await service.calculateRelativeTimeInDay(time);
      
      expect(relative, closeTo(0.0, 0.1));
    });
    
    test('calculateRelativeTimeInDay returns 1.0 at sleep time', () async {
      final profile = createTestProfile(wakeUpHour: 6, sleepHour: 22);
      await profileRepo.saveProfile(profile);
      
      final time = DateTime(2024, 1, 15, 22, 0);
      final relative = await service.calculateRelativeTimeInDay(time);
      
      expect(relative, closeTo(1.0, 0.1));
    });
    
    test('getMinutesSinceFirstActivity calculates correctly', () async {
      final firstActivity = DateTime(2024, 1, 15, 8, 0);
      await service.recordActivity(firstActivity);
      
      final checkTime = DateTime(2024, 1, 15, 10, 30);
      final minutes = await service.getMinutesSinceFirstActivity(checkTime);
      
      expect(minutes, 150); // 2.5 hours = 150 minutes
    });
    
    test('getMinutesSinceFirstActivity returns 0 when no activity', () async {
      final checkTime = DateTime(2024, 1, 15, 10, 0);
      final minutes = await service.getMinutesSinceFirstActivity(checkTime);
      
      expect(minutes, 0);
    });
    
    test('getTodayContext returns correct task order info', () async {
      final date = DateTime(2024, 1, 15, 10, 0);
      
      // Schedule 3 tasks, complete 1
      await service.recordTaskScheduled(date);
      await service.recordTaskScheduled(date);
      await service.recordTaskScheduled(date);
      await service.recordTaskCompletion(
        completionTime: date,
        productivityRating: 4.0,
      );
      
      final context = await service.getTodayContext(date);
      
      expect(context.taskOrderInDay, 2); // Next task would be 2nd
      expect(context.totalTasksScheduledToday, 3);
      expect(context.tasksCompletedBeforeThis, 1);
    });
    
    test('getPreviousTaskRating returns average productivity', () async {
      final date = DateTime(2024, 1, 15, 10, 0);
      
      await service.recordTaskCompletion(
        completionTime: date,
        productivityRating: 4.0,
      );
      await service.recordTaskCompletion(
        completionTime: date.add(const Duration(hours: 1)),
        productivityRating: 5.0,
      );
      
      final rating = await service.getPreviousTaskRating(date);
      
      expect(rating, closeTo(4.5, 0.1)); // (4+5)/2
    });
    
    test('getPreviousTaskRating returns 0 when no completions', () async {
      final date = DateTime(2024, 1, 15, 10, 0);
      final rating = await service.getPreviousTaskRating(date);
      
      expect(rating, 0.0);
    });
  });
  
  group('DailyActivityService - Statistics', () {
    test('getDailySummary returns complete summary', () async {
      final date = DateTime(2024, 1, 15);
      
      // Set up profile
      final profile = createTestProfile(wakeUpHour: 7, sleepHour: 23);
      await profileRepo.saveProfile(profile);
      
      // Record activity
      await service.recordActivity(DateTime(2024, 1, 15, 8, 0));
      await service.recordActivity(DateTime(2024, 1, 15, 18, 0));
      await service.recordTaskScheduled(date);
      await service.recordTaskScheduled(date);
      await service.recordTaskCompletion(
        completionTime: DateTime(2024, 1, 15, 10, 0),
        productivityRating: 4.0,
      );
      await service.recordTaskSkipped(date);
      
      final summary = await service.getDailySummary(date);
      
      expect(summary.date.day, 15);
      expect(summary.firstActivityAt, DateTime(2024, 1, 15, 8, 0));
      expect(summary.lastActivityAt, DateTime(2024, 1, 15, 18, 0));
      expect(summary.tasksCompleted, 1);
      expect(summary.tasksScheduled, 2);
      expect(summary.tasksSkipped, 1);
      expect(summary.averageProductivity, 4.0);
      expect(summary.activeWindow.wakeHour, 7);
      expect(summary.activeWindow.sleepHour, 23);
      expect(summary.completionRate, 0.5);
    });
    
    test('hasLearnedPatterns returns false when no data', () async {
      final hasPatterns = await service.hasLearnedPatterns();
      expect(hasPatterns, false);
    });
    
    test('hasLearnedPatterns returns true when patterns exist', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);
      
      // Create recent logs with activity data that creates patterns
      // Need BOTH firstActivityAt (wake) and lastActivityAt (sleep) for hasAnyPattern
      for (int i = 1; i <= 7; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        if (date.weekday < 6) { // Weekdays only
          final log = DailyActivityLog.createForDate(date)
            ..firstActivityAt = DateTime(date.year, date.month, date.day, 7, 0)
            ..lastActivityAt = DateTime(date.year, date.month, date.day, 22, 0);
          await activityRepo.saveLog(log);
        }
      }
      
      final hasPatterns = await service.hasLearnedPatterns();
      expect(hasPatterns, true);
    });
  });
  
  group('ActiveWindow', () {
    test('durationHours calculates correctly for normal day', () {
      final window = ActiveWindow(
        wakeHour: 7,
        sleepHour: 23,
        date: DateTime(2024, 1, 15),
      );
      
      expect(window.durationHours, 16);
    });
    
    test('durationHours handles wrap around midnight', () {
      final window = ActiveWindow(
        wakeHour: 7,
        sleepHour: 1, // 1 AM next day
        date: DateTime(2024, 1, 15),
      );
      
      expect(window.durationHours, 18); // 7am to 1am = 18 hours
    });
    
    test('isActiveHour returns true for hours in window', () {
      final window = ActiveWindow(
        wakeHour: 7,
        sleepHour: 23,
        date: DateTime(2024, 1, 15),
      );
      
      expect(window.isActiveHour(7), true);
      expect(window.isActiveHour(14), true);
      expect(window.isActiveHour(22), true);
      expect(window.isActiveHour(6), false);
      expect(window.isActiveHour(23), false);
    });
    
    test('isActiveHour handles wrap around midnight', () {
      final window = ActiveWindow(
        wakeHour: 7,
        sleepHour: 1, // 1 AM next day
        date: DateTime(2024, 1, 15),
      );
      
      expect(window.isActiveHour(7), true);
      expect(window.isActiveHour(23), true);
      expect(window.isActiveHour(0), true);
      expect(window.isActiveHour(1), false);
      expect(window.isActiveHour(5), false);
    });
  });
  
  group('TaskCompletionContext', () {
    test('creates with correct values', () {
      final context = TaskCompletionContext(
        taskOrderInDay: 3,
        totalTasksScheduledToday: 5,
        tasksCompletedBeforeThis: 2,
        completionRateLast7Days: 0.8,
      );
      
      expect(context.taskOrderInDay, 3);
      expect(context.totalTasksScheduledToday, 5);
      expect(context.tasksCompletedBeforeThis, 2);
      expect(context.completionRateLast7Days, 0.8);
    });
  });
}
