import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/data/models/daily_activity_log.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/data/models/productivity_data.dart';
import 'package:goal_tracker/data/repositories/daily_activity_log_repository.dart';
import 'package:goal_tracker/data/repositories/user_profile_repository.dart';
import 'package:goal_tracker/data/repositories/productivity_data_repository.dart';
import 'package:goal_tracker/core/services/daily_activity_service.dart';
import 'package:goal_tracker/core/services/dynamic_time_window_service.dart';

/// Comprehensive test suite for sleep and wake tracking features
/// Tests edge cases, data seeding, and real-world scenarios
void main() {
  late Isar isar;
  late DailyActivityLogRepository activityRepo;
  late UserProfileRepository profileRepo;
  late ProductivityDataRepository productivityRepo;
  late DailyActivityService activityService;
  late DynamicTimeWindowService timeWindowService;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [DailyActivityLogSchema, UserProfileSchema, ProductivityDataSchema],
      directory: '',
      name: 'test_sleep_wake_${DateTime.now().millisecondsSinceEpoch}',
    );
    activityRepo = DailyActivityLogRepository(isar);
    profileRepo = UserProfileRepository(isar);
    productivityRepo = ProductivityDataRepository(isar);
    activityService = DailyActivityService(activityRepo, profileRepo);
    timeWindowService = DynamicTimeWindowService(
      activityRepo: activityRepo,
      productivityRepo: productivityRepo,
      profileRepo: profileRepo,
      activityService: activityService,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('Data Seeding Utilities', () {
    test('seedActivityLogsForWeeks creates realistic activity patterns', () async {
      // Seed 2 weeks of data
      await seedActivityLogsForWeeks(
        activityRepo,
        weeks: 2,
        weekdayWakeHour: 7,
        weekdaySleepHour: 23,
        weekendWakeHour: 9,
        weekendSleepHour: 1, // Past midnight
      );

      final patterns = await activityRepo.getActivityPatterns();
      
      expect(patterns.weekdayWakeHour, 7);
      expect(patterns.weekdaySleepHour, 23);
      expect(patterns.weekendWakeHour, 9);
      expect(patterns.weekendSleepHour, 1);
      expect(patterns.hasAnyPattern, true);
    });

    test('seedProductivityData creates realistic productivity patterns', () async {
      await seedProductivityData(
        productivityRepo,
        days: 14,
        peakHours: [9, 10, 11], // Morning peak
        averageScore: 4.0,
      );

      final recentData = await productivityRepo.getRecentData(limit: 100);
      expect(recentData.length, greaterThan(0));
      
      // Check that peak hours have higher scores
      final peakData = recentData.where((d) => 
        d.hourOfDay == 9 || d.hourOfDay == 10 || d.hourOfDay == 11
      ).toList();
      
      if (peakData.isNotEmpty) {
        final avgPeakScore = peakData.fold<double>(
          0.0,
          (sum, d) => sum + d.productivityScore,
        ) / peakData.length;
        expect(avgPeakScore, greaterThanOrEqualTo(3.5));
      }
    });
  });

  group('Edge Cases - Midnight Crossing', () {
    test('handles sleep time past midnight correctly (wake=7, sleep=1)', () async {
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 7
        ..sleepHour = 1 // 1 AM next day
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      final window = await activityService.getActiveWindow(DateTime(2024, 1, 15));
      
      expect(window.wakeHour, 7);
      expect(window.sleepHour, 1);
      expect(window.durationHours, 18); // 7am to 1am next day = 18 hours
      
      // Test isActiveHour
      expect(window.isActiveHour(7), true); // Wake hour
      expect(window.isActiveHour(23), true); // Late evening
      expect(window.isActiveHour(0), true); // Midnight
      expect(window.isActiveHour(1), false); // Sleep hour (exclusive)
      expect(window.isActiveHour(2), false); // Past sleep
      expect(window.isActiveHour(6), false); // Before wake
    });

    test('handles very late sleep (wake=6, sleep=3)', () async {
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 6
        ..sleepHour = 3 // 3 AM
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      final window = await activityService.getActiveWindow(DateTime(2024, 1, 15));
      
      expect(window.durationHours, 21); // 6am to 3am next day = 21 hours
      expect(window.isActiveHour(2), true);
      expect(window.isActiveHour(3), false);
      expect(window.isActiveHour(4), false);
    });

    test('calculateRelativeTimeInDay handles midnight crossing', () async {
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 20 // 8 PM
        ..sleepHour = 4 // 4 AM next day
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      // Test various times in the window
      final time1 = DateTime(2024, 1, 15, 20, 0); // Wake time
      final relative1 = await activityService.calculateRelativeTimeInDay(time1);
      expect(relative1, closeTo(0.0, 0.1));

      final time2 = DateTime(2024, 1, 15, 23, 0); // Mid-evening
      final relative2 = await activityService.calculateRelativeTimeInDay(time2);
      expect(relative2, greaterThan(0.2));
      expect(relative2, lessThan(0.5));

      final time3 = DateTime(2024, 1, 16, 2, 0); // Early morning
      final relative3 = await activityService.calculateRelativeTimeInDay(time3);
      expect(relative3, greaterThan(0.5));
      expect(relative3, lessThan(1.0));
    });
  });

  group('Edge Cases - Invalid Windows', () {
    test('rejects invalid time window (less than 4 hours)', () async {
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 22
        ..sleepHour = 23 // Only 1 hour window - invalid
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      final window = await timeWindowService.getTimeWindowForDate(
        DateTime(2024, 1, 15),
      );

      // Should fall back to defaults (7-23)
      expect(window.totalWindowHours, greaterThanOrEqualTo(4));
      expect(window.totalWindowHours, lessThanOrEqualTo(20));
    });

    test('rejects invalid time window (more than 20 hours)', () async {
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 6
        ..sleepHour = 5 // 23 hour window - invalid
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      final window = await timeWindowService.getTimeWindowForDate(
        DateTime(2024, 1, 15),
      );

      // Should fall back to defaults
      expect(window.totalWindowHours, lessThanOrEqualTo(20));
    });

    test('handles same wake and sleep hour', () async {
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 7
        ..sleepHour = 7 // Same hour - invalid
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      final window = await timeWindowService.getTimeWindowForDate(
        DateTime(2024, 1, 15),
      );

      // Should fall back to defaults
      expect(window.totalWindowHours, greaterThan(4));
    });
  });

  group('Edge Cases - Data Patterns', () {
    test('handles inconsistent weekday patterns', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);

      // Create inconsistent weekday data (varying wake times)
      final wakeTimes = [6, 7, 8, 7, 6, 9, 7];
      for (int i = 0; i < 7; i++) {
        var date = normalizedNow.subtract(Duration(days: i + 1));
        while (date.weekday >= 6) {
          date = date.subtract(const Duration(days: 1));
        }
        
        final log = DailyActivityLog.createForDate(date)
          ..firstActivityAt = DateTime(date.year, date.month, date.day, wakeTimes[i], 0)
          ..lastActivityAt = DateTime(date.year, date.month, date.day, 22, 0);
        await activityRepo.saveLog(log);
      }

      final patterns = await activityRepo.getActivityPatterns();
      
      // Should average to around 7
      expect(patterns.weekdayWakeHour, isNotNull);
      expect(patterns.weekdayWakeHour!, greaterThanOrEqualTo(6));
      expect(patterns.weekdayWakeHour!, lessThanOrEqualTo(8));
    });

    test('handles sparse weekend data', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);

      // Create only 1 weekend day of data
      var saturday = normalizedNow;
      while (saturday.weekday != 6) {
        saturday = saturday.subtract(const Duration(days: 1));
      }

      final log = DailyActivityLog.createForDate(saturday)
        ..firstActivityAt = DateTime(saturday.year, saturday.month, saturday.day, 10, 0)
        ..lastActivityAt = DateTime(saturday.year, saturday.month, saturday.day, 23, 0);
      await activityRepo.saveLog(log);

      final patterns = await activityRepo.getActivityPatterns();
      
      // Should still have weekend pattern with limited data
      expect(patterns.weekendWakeHour, isNotNull);
      expect(patterns.weekendDataPoints, 1);
    });

    test('prioritizes learned patterns over profile defaults', () async {
      // Set profile to 7am wake
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 7
        ..sleepHour = 23
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      // Create learned pattern of 9am wake for weekdays
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);
      
      for (int i = 0; i < 7; i++) {
        var date = normalizedNow.subtract(Duration(days: i + 1));
        while (date.weekday >= 6) {
          date = date.subtract(const Duration(days: 1));
        }
        
        final log = DailyActivityLog.createForDate(date)
          ..firstActivityAt = DateTime(date.year, date.month, date.day, 9, 0)
          ..lastActivityAt = DateTime(date.year, date.month, date.day, 22, 0);
        await activityRepo.saveLog(log);
      }

      // Check for a weekday
      var weekday = normalizedNow;
      while (weekday.weekday >= 6) {
        weekday = weekday.add(const Duration(days: 1));
      }

      final effectiveWake = await activityService.getEffectiveWakeHour(weekday);
      
      // Should use learned pattern (9am) with some weighting towards profile (7am)
      expect(effectiveWake, greaterThanOrEqualTo(7));
      expect(effectiveWake, lessThanOrEqualTo(9));
    });
  });

  group('Real-World Scenarios', () {
    test('Scenario: Early Bird User (6am-10pm)', () async {
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 6
        ..sleepHour = 22
        ..chronoType = ChronoType.earlyBird
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      final window = await timeWindowService.getTimeWindowForDate(
        DateTime(2024, 1, 15),
      );

      expect(window.wakeHour, 6);
      expect(window.sleepHour, 22);
      expect(window.totalWindowHours, 16);
      
      // Early bird should have optimal window in the morning
      expect(window.optimalStartHour, lessThanOrEqualTo(10));
    });

    test('Scenario: Night Owl User (10am-2am)', () async {
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 10
        ..sleepHour = 2 // 2 AM
        ..chronoType = ChronoType.nightOwl
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      final window = await timeWindowService.getTimeWindowForDate(
        DateTime(2024, 1, 15),
      );

      expect(window.wakeHour, 10);
      expect(window.sleepHour, 2);
      expect(window.totalWindowHours, 16);
      expect(window.isActiveHour(1), true); // 1 AM should be active
      expect(window.isActiveHour(9), false); // 9 AM should be inactive
    });

    test('Scenario: Shift Worker (irregular schedule)', () async {
      // Simulate shift work with different patterns on different days
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);

      for (int i = 0; i < 7; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        
        // Alternate between day shift (7am) and night shift (7pm)
        final wakeHour = i % 2 == 0 ? 7 : 19;
        final sleepHour = i % 2 == 0 ? 23 : 11;
        
        final log = DailyActivityLog.createForDate(date)
          ..firstActivityAt = DateTime(date.year, date.month, date.day, wakeHour, 0)
          ..lastActivityAt = DateTime(date.year, date.month, date.day, sleepHour, 0);
        await activityRepo.saveLog(log);
      }

      final patterns = await activityRepo.getActivityPatterns();
      
      // Should have some pattern, even if averaged
      expect(patterns.hasAnyPattern, true);
      // The average will be somewhere in the middle
      expect(patterns.weekdayWakeHour, isNotNull);
    });

    test('Scenario: College Student (late sleep, late wake)', () async {
      await seedActivityLogsForWeeks(
        activityRepo,
        weeks: 2,
        weekdayWakeHour: 9, // Late morning
        weekdaySleepHour: 2, // 2 AM
        weekendWakeHour: 11, // Even later on weekends
        weekendSleepHour: 3, // 3 AM
      );

      final patterns = await activityRepo.getActivityPatterns();
      
      expect(patterns.weekdayWakeHour, 9);
      expect(patterns.weekdaySleepHour, 2);
      expect(patterns.weekendWakeHour, 11);
      expect(patterns.weekendSleepHour, 3);
      
      // Weekend should be different from weekday
      expect(patterns.weekendWakeHour! > patterns.weekdayWakeHour!, true);
    });

    test('Scenario: User with gradual sleep schedule improvement', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);

      // Simulate gradually improving sleep schedule over 2 weeks
      for (int i = 0; i < 14; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        if (date.weekday >= 6) continue; // Weekdays only
        
        // Wake hour improves from 9am to 7am
        final wakeHour = 9 - (i ~/ 7); // 9am first week, 8am second week
        
        final log = DailyActivityLog.createForDate(date)
          ..firstActivityAt = DateTime(date.year, date.month, date.day, wakeHour, 0)
          ..lastActivityAt = DateTime(date.year, date.month, date.day, 23, 0);
        await activityRepo.saveLog(log);
      }

      final patterns = await activityRepo.getActivityPatterns();
      
      // Should average recent patterns (more weight on recent data)
      expect(patterns.weekdayWakeHour, isNotNull);
      expect(patterns.weekdayWakeHour!, greaterThanOrEqualTo(7));
      expect(patterns.weekdayWakeHour!, lessThanOrEqualTo(9));
    });
  });

  group('Learning and Adaptation', () {
    test('learns optimal window from productivity data', () async {
      // Seed profile
      final profile = UserProfile.createDefault()
        ..wakeUpHour = 6
        ..sleepHour = 23
        ..chronoType = ChronoType.normal
        ..onboardingCompleted = true;
      await profileRepo.saveProfile(profile);

      // Seed productivity data showing morning peak (9-11 AM)
      await seedProductivityData(
        productivityRepo,
        days: 14,
        peakHours: [9, 10, 11],
        averageScore: 4.2,
      );

      final window = await timeWindowService.getTimeWindowForDate(
        DateTime(2024, 1, 15),
      );

      // Optimal window should align with peak hours
      expect(window.optimalStartHour, lessThanOrEqualTo(10));
      expect(window.optimalEndHour, greaterThanOrEqualTo(10));
      expect(window.isLearned, isTrue);
    });

    test('adapts to new patterns over time', () async {
      final now = DateTime.now();
      final normalizedNow = DateTime(now.year, now.month, now.day);

      // Old pattern (2-3 weeks ago): 8am wake
      for (int i = 14; i < 21; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        if (date.weekday >= 6) continue;
        
        final log = DailyActivityLog.createForDate(date)
          ..firstActivityAt = DateTime(date.year, date.month, date.day, 8, 0)
          ..lastActivityAt = DateTime(date.year, date.month, date.day, 22, 0);
        await activityRepo.saveLog(log);
      }

      // New pattern (last 2 weeks): 7am wake
      for (int i = 0; i < 14; i++) {
        final date = normalizedNow.subtract(Duration(days: i));
        if (date.weekday >= 6) continue;
        
        final log = DailyActivityLog.createForDate(date)
          ..firstActivityAt = DateTime(date.year, date.month, date.day, 7, 0)
          ..lastActivityAt = DateTime(date.year, date.month, date.day, 22, 0);
        await activityRepo.saveLog(log);
      }

      // Should use more recent data (lookback is 14 days by default)
      final patterns = await activityRepo.getActivityPatterns(lookbackDays: 14);
      
      expect(patterns.weekdayWakeHour, 7); // Should reflect new pattern
    });
  });

  group('Performance and Data Volume', () {
    test('handles large volume of activity logs efficiently', () async {
      final stopwatch = Stopwatch()..start();
      
      // Seed 90 days of data (realistic for a 3-month old account)
      await seedActivityLogsForWeeks(
        activityRepo,
        weeks: 13, // ~90 days
        weekdayWakeHour: 7,
        weekdaySleepHour: 23,
        weekendWakeHour: 9,
        weekendSleepHour: 1,
      );
      
      stopwatch.stop();
      
      // Seeding should be reasonably fast
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Less than 5 seconds
      
      // Query patterns
      final queryStopwatch = Stopwatch()..start();
      final patterns = await activityRepo.getActivityPatterns();
      queryStopwatch.stop();
      
      expect(patterns.hasAnyPattern, true);
      expect(queryStopwatch.elapsedMilliseconds, lessThan(1000)); // Less than 1 second
    });
  });
}

// ============================================================================
// Utility Functions for Data Seeding
// ============================================================================

/// Seeds activity logs for specified number of weeks
/// Creates realistic patterns with some variation
Future<void> seedActivityLogsForWeeks(
  DailyActivityLogRepository repo, {
  required int weeks,
  required int weekdayWakeHour,
  required int weekdaySleepHour,
  required int weekendWakeHour,
  required int weekendSleepHour,
}) async {
  final now = DateTime.now();
  final normalizedNow = DateTime(now.year, now.month, now.day);
  
  for (int i = 0; i < weeks * 7; i++) {
    final date = normalizedNow.subtract(Duration(days: i));
    final isWeekend = date.weekday >= 6;
    
    // Add some natural variation (±1 hour)
    final variation = (i % 3) - 1; // -1, 0, or 1
    final wakeHour = isWeekend 
        ? (weekendWakeHour + variation).clamp(5, 12)
        : (weekdayWakeHour + variation).clamp(5, 10);
    final sleepHour = isWeekend 
        ? (weekendSleepHour + variation).clamp(0, 5)
        : (weekdaySleepHour + variation).clamp(21, 24);
    
    // Handle sleep times that cross midnight: move lastActivityAt to the next day
    DateTime lastActivityDate = date;
    if (sleepHour <= wakeHour || sleepHour < 6) {
      lastActivityDate = date.add(const Duration(days: 1));
    }
    
    final log = DailyActivityLog.createForDate(date)
      ..firstActivityAt = DateTime(date.year, date.month, date.day, wakeHour, 0)
      ..lastActivityAt = DateTime(
        lastActivityDate.year,
        lastActivityDate.month,
        lastActivityDate.day,
        sleepHour,
        0,
      )
      ..tasksScheduled = 3 + (i % 3)
      ..tasksCompleted = 2 + (i % 2)
      ..productivitySum = 8.0 + (i % 5).toDouble()
      ..averageProductivity = (8.0 + (i % 5).toDouble()) / (2 + (i % 2));
    
    await repo.saveLog(log);
  }
}

/// Seeds productivity data with realistic patterns
Future<void> seedProductivityData(
  ProductivityDataRepository repo, {
  required int days,
  required List<int> peakHours,
  required double averageScore,
}) async {
  final now = DateTime.now();
  
  for (int day = 0; day < days; day++) {
    final date = now.subtract(Duration(days: day));
    
    // Create 3-5 productivity entries per day
    for (int entry = 0; entry < 3 + (day % 3); entry++) {
      // Randomly pick an hour, with bias towards peak hours
      final hour = (entry % 2 == 0 && peakHours.isNotEmpty)
          ? peakHours[entry % peakHours.length]
          : 8 + (entry * 3);
      
      // Higher score during peak hours
      final isPeak = peakHours.contains(hour);
      final score = isPeak
          ? (averageScore + 0.5 + (entry % 10) / 10.0).clamp(1.0, 5.0)
          : (averageScore - 0.3 + (entry % 10) / 10.0).clamp(1.0, 5.0);
      
      final data = ProductivityData()
        ..goalId = 1 + (entry % 3)
        ..hourOfDay = hour
        ..dayOfWeek = date.weekday - 1
        ..duration = 60
        ..timeSlotType = hour < 12 ? 0 : (hour < 18 ? 1 : 2)
        ..hadPriorTask = entry > 0
        ..hadFollowingTask = entry < 3
        ..weekOfYear = 1
        ..isWeekend = date.weekday >= 6
        ..taskOrderInDay = entry + 1
        ..totalTasksScheduledToday = 4
        ..tasksCompletedBeforeThis = entry
        ..relativeTimeInDay = hour / 24.0
        ..minutesSinceFirstActivity = hour * 60
        ..previousTaskRating = entry > 0 ? score - 0.5 : 0.0
        ..completionRateLast7Days = 0.8
        ..currentStreakAtCompletion = day + 1
        ..goalConsistencyScore = 0.9
        ..consecutiveTasksCompleted = entry
        ..minutesSinceLastCompletion = entry > 0 ? 120 : 0
        ..productivityScore = score
        ..wasRescheduled = false
        ..wasCompleted = true
        ..actualDurationMinutes = 60
        ..minutesFromScheduled = 0
        ..recordedAt = date
        ..scheduledTaskId = day * 10 + entry;
      
      await repo.isar.writeTxn(() async {
        await repo.isar.productivityDatas.put(data);
      });
    }
  }
}
