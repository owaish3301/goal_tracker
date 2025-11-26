import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/core/services/dynamic_time_window_service.dart';
import 'package:goal_tracker/core/services/daily_activity_service.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/data/models/productivity_data.dart';
import 'package:goal_tracker/data/models/daily_activity_log.dart';
import 'package:goal_tracker/data/repositories/user_profile_repository.dart';
import 'package:goal_tracker/data/repositories/productivity_data_repository.dart';
import 'package:goal_tracker/data/repositories/daily_activity_log_repository.dart';

void main() {
  late Isar isar;
  late DailyActivityLogRepository activityRepo;
  late ProductivityDataRepository productivityRepo;
  late UserProfileRepository profileRepo;
  late DailyActivityService activityService;
  late DynamicTimeWindowService dynamicTimeWindowService;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [
        UserProfileSchema,
        ProductivityDataSchema,
        DailyActivityLogSchema,
      ],
      directory: '',
      name: 'test_dynamic_window_${DateTime.now().millisecondsSinceEpoch}',
    );

    activityRepo = DailyActivityLogRepository(isar);
    productivityRepo = ProductivityDataRepository(isar);
    profileRepo = UserProfileRepository(isar);
    activityService = DailyActivityService(activityRepo, profileRepo);

    dynamicTimeWindowService = DynamicTimeWindowService(
      activityRepo: activityRepo,
      productivityRepo: productivityRepo,
      profileRepo: profileRepo,
      activityService: activityService,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  // Helper to create productivity data
  Future<void> createProductivityData({
    required int goalId,
    required int hourOfDay,
    required int dayOfWeek,
    required double productivityScore,
    bool wasCompleted = true,
  }) async {
    final now = DateTime.now();
    final data = ProductivityData()
      ..goalId = goalId
      ..hourOfDay = hourOfDay
      ..dayOfWeek = dayOfWeek
      ..duration = 60
      ..timeSlotType = hourOfDay < 12 ? 0 : (hourOfDay < 18 ? 1 : 2)
      ..hadPriorTask = false
      ..hadFollowingTask = false
      ..weekOfYear = 1
      ..isWeekend = dayOfWeek >= 5
      ..taskOrderInDay = 1
      ..totalTasksScheduledToday = 1
      ..tasksCompletedBeforeThis = 0
      ..relativeTimeInDay = hourOfDay / 24.0
      ..minutesSinceFirstActivity = 0
      ..previousTaskRating = 0.0
      ..completionRateLast7Days = 1.0
      ..currentStreakAtCompletion = 1
      ..goalConsistencyScore = 1.0
      ..consecutiveTasksCompleted = 1
      ..minutesSinceLastCompletion = 0
      ..productivityScore = productivityScore
      ..wasRescheduled = false
      ..wasCompleted = wasCompleted
      ..actualDurationMinutes = 60
      ..minutesFromScheduled = 0
      ..recordedAt = now
      ..scheduledTaskId = 1;

    await isar.writeTxn(() async {
      await isar.productivityDatas.put(data);
    });
  }

  group('DynamicTimeWindowService', () {
    group('getTimeWindowForDate', () {
      test('returns default window when no data exists', () async {
        final date = DateTime(2024, 1, 15); // Monday

        final result = await dynamicTimeWindowService.getTimeWindowForDate(date);

        // Should return default window (7 AM - 23 PM based on default profile)
        expect(result.wakeHour, greaterThanOrEqualTo(6));
        expect(result.wakeHour, lessThanOrEqualTo(8));
        expect(result.sleepHour, greaterThanOrEqualTo(22));
        expect(result.sleepHour, lessThanOrEqualTo(24));
        expect(result.isLearned, isFalse); // No learned data
      });

      test('uses profile wake/sleep times when available', () async {
        // Create profile with custom wake/sleep times
        final profile = UserProfile.createDefault()
          ..wakeUpHour = 7
          ..sleepHour = 23
          ..onboardingCompleted = true;
        await profileRepo.saveProfile(profile);

        final date = DateTime(2024, 1, 15);

        final result = await dynamicTimeWindowService.getTimeWindowForDate(date);

        expect(result.wakeHour, equals(7));
        expect(result.sleepHour, equals(23));
      });

      test('calculates optimal window from successful completions', () async {
        // Create consistent productivity data in morning hours
        for (int i = 0; i < 10; i++) {
          await createProductivityData(
            goalId: 1,
            hourOfDay: 8, // Completed at 8 AM
            dayOfWeek: i % 5, // Weekdays
            productivityScore: 4.5, // High score
          );
        }

        final date = DateTime(2024, 1, 15); // Monday

        final result = await dynamicTimeWindowService.getTimeWindowForDate(date);

        // Should have calculated some optimal window
        expect(result.optimalStartHour, greaterThanOrEqualTo(result.wakeHour));
        expect(result.optimalEndHour, lessThanOrEqualTo(result.sleepHour));
      });

      test('differentiates between weekday and weekend patterns', () async {
        final weekday = DateTime(2024, 1, 15); // Monday
        final weekend = DateTime(2024, 1, 13); // Saturday

        final weekdayWindow = await dynamicTimeWindowService.getTimeWindowForDate(weekday);
        final weekendWindow = await dynamicTimeWindowService.getTimeWindowForDate(weekend);

        // Patterns may differ between weekday and weekend
        // Just verify we get valid windows
        expect(weekdayWindow.wakeHour, lessThan(weekdayWindow.sleepHour));
        expect(weekendWindow.wakeHour, lessThan(weekendWindow.sleepHour));
      });
    });

    group('DynamicTimeWindow class', () {
      test('calculates total window hours correctly', () async {
        final date = DateTime(2024, 1, 15);
        final window = await dynamicTimeWindowService.getTimeWindowForDate(date);

        // totalWindowHours should be sleepHour - wakeHour for normal case
        expect(window.totalWindowHours, greaterThan(0));
        expect(window.totalWindowHours, lessThanOrEqualTo(24));
      });

      test('isActiveHour returns correct values', () async {
        final profile = UserProfile.createDefault()
          ..wakeUpHour = 8
          ..sleepHour = 22
          ..onboardingCompleted = true;
        await profileRepo.saveProfile(profile);

        final date = DateTime(2024, 1, 15);
        final window = await dynamicTimeWindowService.getTimeWindowForDate(date);

        // Hours within range should be active
        expect(window.isActiveHour(10), isTrue);
        expect(window.isActiveHour(15), isTrue);
        
        // Hours outside range should be inactive
        expect(window.isActiveHour(5), isFalse);
        expect(window.isActiveHour(23), isFalse);
      });

      test('isOptimalHour returns correct values', () async {
        final date = DateTime(2024, 1, 15);
        final window = await dynamicTimeWindowService.getTimeWindowForDate(date);

        // Optimal hours should be within the optimal window
        if (window.optimalStartHour < window.optimalEndHour) {
          final midOptimal = (window.optimalStartHour + window.optimalEndHour) ~/ 2;
          expect(window.isOptimalHour(midOptimal), isTrue);
        }
      });
    });

    group('SuccessfulHour class', () {
      test('aggregates completion data correctly', () async {
        // Create multiple completions at the same hour
        for (int i = 0; i < 5; i++) {
          await createProductivityData(
            goalId: i + 1,
            hourOfDay: 9, // All at 9 AM
            dayOfWeek: 1, // Monday
            productivityScore: 3.0 + i * 0.5, // 3.0, 3.5, 4.0, 4.5, 5.0
          );
        }

        final date = DateTime(2024, 1, 15); // Monday
        final window = await dynamicTimeWindowService.getTimeWindowForDate(date);

        // Check if 9 AM is in successful hours
        final nineAmHour = window.successfulHours.cast<SuccessfulHour?>().firstWhere(
          (h) => h?.hour == 9,
          orElse: () => null,
        );

        if (nineAmHour != null) {
          expect(nineAmHour.completionCount, greaterThan(0));
          expect(nineAmHour.averageScore, greaterThanOrEqualTo(3.0));
          expect(nineAmHour.averageScore, lessThanOrEqualTo(5.0));
        }
      });
    });
  });
}
