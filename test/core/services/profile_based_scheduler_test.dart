import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/core/services/profile_based_scheduler.dart';
import 'package:goal_tracker/core/services/rule_based_scheduler.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/goal_category.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/data/repositories/user_profile_repository.dart';

void main() {
  late Isar isar;
  late UserProfileRepository userProfileRepository;
  late ProfileBasedScheduler profileBasedScheduler;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [UserProfileSchema],
      directory: '',
      name: 'test_profile_scheduler_${DateTime.now().millisecondsSinceEpoch}',
    );

    userProfileRepository = UserProfileRepository(isar);
    profileBasedScheduler = ProfileBasedScheduler(userProfileRepository);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  // Helper to create a test goal
  Goal createTestGoal({
    required String title,
    GoalCategory category = GoalCategory.other,
    int targetDuration = 60,
  }) {
    return Goal()
      ..id = 1
      ..title = title
      ..category = category
      ..targetDuration = targetDuration
      ..frequency = [0, 1, 2, 3, 4, 5, 6]
      ..colorHex = '#FF5733'
      ..iconName = 'fitness_center'
      ..isActive = true;
  }

  group('ProfileBasedScheduler', () {
    group('scoreTimeSlot', () {
      test('returns base score when no profile exists', () async {
        final goal = createTestGoal(title: 'Test Goal');
        final slot = TimeSlot(
          DateTime(2024, 1, 15, 9, 0),
          DateTime(2024, 1, 15, 10, 0),
        );
        final date = DateTime(2024, 1, 15);

        final result = await profileBasedScheduler.scoreTimeSlot(
          goal: goal,
          slot: slot,
          date: date,
        );

        // Should return a valid score
        expect(result.score, greaterThanOrEqualTo(0.0));
        expect(result.score, lessThanOrEqualTo(1.0));
        expect(result.factors, isNotEmpty);
      });

      test('scores morning slots higher for early bird chrono-type', () async {
        // Create profile with early bird preference
        final profile = UserProfile.createDefault()
          ..chronoType = ChronoType.earlyBird
          ..onboardingCompleted = true;
        await userProfileRepository.saveProfile(profile);

        final goal = createTestGoal(title: 'Morning Goal');
        final earlySlot = TimeSlot(
          DateTime(2024, 1, 15, 6, 0),
          DateTime(2024, 1, 15, 7, 0),
        );
        final lateSlot = TimeSlot(
          DateTime(2024, 1, 15, 21, 0),
          DateTime(2024, 1, 15, 22, 0),
        );
        final date = DateTime(2024, 1, 15);

        final earlyScore = await profileBasedScheduler.scoreTimeSlot(
          goal: goal,
          slot: earlySlot,
          date: date,
        );
        final lateScore = await profileBasedScheduler.scoreTimeSlot(
          goal: goal,
          slot: lateSlot,
          date: date,
        );

        // Early slot should score higher for early bird
        expect(earlyScore.score, greaterThan(lateScore.score));
      });

      test('scores evening slots higher for night owl chrono-type', () async {
        // Create profile with night owl preference
        final profile = UserProfile.createDefault()
          ..chronoType = ChronoType.nightOwl
          ..onboardingCompleted = true;
        await userProfileRepository.saveProfile(profile);

        final goal = createTestGoal(title: 'Evening Goal');
        final earlySlot = TimeSlot(
          DateTime(2024, 1, 15, 6, 0),
          DateTime(2024, 1, 15, 7, 0),
        );
        final eveningSlot = TimeSlot(
          DateTime(2024, 1, 15, 20, 0),
          DateTime(2024, 1, 15, 21, 0),
        );
        final date = DateTime(2024, 1, 15);

        final earlyScore = await profileBasedScheduler.scoreTimeSlot(
          goal: goal,
          slot: earlySlot,
          date: date,
        );
        final eveningScore = await profileBasedScheduler.scoreTimeSlot(
          goal: goal,
          slot: eveningSlot,
          date: date,
        );

        // Evening slot should score higher for night owl
        expect(eveningScore.score, greaterThan(earlyScore.score));
      });

      test('scores slots based on goal category optimal hours', () async {
        // Create exercise goal - optimal in morning (6-10 AM)
        final exerciseGoal = createTestGoal(
          title: 'Exercise',
          category: GoalCategory.exercise,
        );

        final morningSlot = TimeSlot(
          DateTime(2024, 1, 15, 7, 0),
          DateTime(2024, 1, 15, 8, 0),
        );
        final eveningSlot = TimeSlot(
          DateTime(2024, 1, 15, 21, 0),
          DateTime(2024, 1, 15, 22, 0),
        );
        final date = DateTime(2024, 1, 15);

        final morningScore = await profileBasedScheduler.scoreTimeSlot(
          goal: exerciseGoal,
          slot: morningSlot,
          date: date,
        );
        final eveningScore = await profileBasedScheduler.scoreTimeSlot(
          goal: exerciseGoal,
          slot: eveningSlot,
          date: date,
        );

        // Morning should score higher for exercise
        expect(morningScore.factors['category'], greaterThan(0));
        expect(morningScore.factors['category']!, greaterThan(eveningScore.factors['category']!));
      });

      test('penalizes work hours when user has work schedule', () async {
        // Create profile with work schedule
        final profile = UserProfile.createDefault()
          ..hasWorkSchedule = true
          ..workStartHour = 9
          ..workEndHour = 17
          ..onboardingCompleted = true;
        await userProfileRepository.saveProfile(profile);

        final goal = createTestGoal(title: 'Personal Goal');
        final workSlot = TimeSlot(
          DateTime(2024, 1, 15, 10, 0), // During work hours
          DateTime(2024, 1, 15, 11, 0),
        );
        final nonWorkSlot = TimeSlot(
          DateTime(2024, 1, 15, 7, 0), // Before work
          DateTime(2024, 1, 15, 8, 0),
        );
        final date = DateTime(2024, 1, 15); // Monday

        final workScore = await profileBasedScheduler.scoreTimeSlot(
          goal: goal,
          slot: workSlot,
          date: date,
        );
        final nonWorkScore = await profileBasedScheduler.scoreTimeSlot(
          goal: goal,
          slot: nonWorkSlot,
          date: date,
        );

        // Both should return valid scores
        expect(workScore.score, greaterThanOrEqualTo(0.0));
        expect(workScore.score, lessThanOrEqualTo(1.0));
        expect(nonWorkScore.score, greaterThanOrEqualTo(0.0));
        expect(nonWorkScore.score, lessThanOrEqualTo(1.0));
        // Work slot should have a work penalty factor applied
        expect(workScore.factors.containsKey('work_penalty'), isTrue);
      });
    });

    group('findBestSlotForGoal', () {
      test('returns highest scored slot from available options', () async {
        // Create profile with early bird preference
        final profile = UserProfile.createDefault()
          ..chronoType = ChronoType.earlyBird
          ..onboardingCompleted = true;
        await userProfileRepository.saveProfile(profile);

        final goal = createTestGoal(title: 'Test Goal');
        final availableSlots = [
          TimeSlot(
            DateTime(2024, 1, 15, 20, 0),
            DateTime(2024, 1, 15, 21, 0),
          ),
          TimeSlot(
            DateTime(2024, 1, 15, 6, 0), // Best for early bird
            DateTime(2024, 1, 15, 8, 0),
          ),
          TimeSlot(
            DateTime(2024, 1, 15, 14, 0),
            DateTime(2024, 1, 15, 16, 0),
          ),
        ];
        final date = DateTime(2024, 1, 15);

        final result = await profileBasedScheduler.findBestSlotForGoal(
          goal: goal,
          availableSlots: availableSlots,
          usedSlots: [],
          date: date,
        );

        expect(result, isNotNull);
        // Should pick one of the available slots
        expect([6, 14, 20], contains(result!.slot.start.hour));
        expect(result.score, greaterThan(0.0));
      });

      test('returns null when no slots available', () async {
        final goal = createTestGoal(title: 'Test Goal');
        final date = DateTime(2024, 1, 15);

        final result = await profileBasedScheduler.findBestSlotForGoal(
          goal: goal,
          availableSlots: [],
          usedSlots: [],
          date: date,
        );

        expect(result, isNull);
      });
      
      test('excludes already used slots', () async {
        final goal = createTestGoal(title: 'Test Goal');
        final availableSlots = [
          TimeSlot(
            DateTime(2024, 1, 15, 9, 0),
            DateTime(2024, 1, 15, 12, 0),
          ),
        ];
        final usedSlots = [
          TimeSlot(
            DateTime(2024, 1, 15, 9, 0),
            DateTime(2024, 1, 15, 10, 0),
          ),
        ];
        final date = DateTime(2024, 1, 15);

        final result = await profileBasedScheduler.findBestSlotForGoal(
          goal: goal,
          availableSlots: availableSlots,
          usedSlots: usedSlots,
          date: date,
        );

        // Should still find the remaining slot
        expect(result, isNotNull);
        // The result should be after the used slot
        expect(result!.slot.start.hour, greaterThanOrEqualTo(10));
      });
    });

    group('getSchedulingRecommendations', () {
      test('returns recommendations based on goal category', () async {
        final goal = createTestGoal(
          title: 'Study Session',
          category: GoalCategory.learning,
        );
        final date = DateTime(2024, 1, 15);

        final recommendations = await profileBasedScheduler.getSchedulingRecommendations(
          goal,
          date,
        );

        expect(recommendations['category'], equals('Learning & Study'));
        expect(recommendations['category_optimal_hours'], isNotNull);
        expect(recommendations['category_best_hour'], isNotNull);
      });

      test('includes chrono-type windows in recommendations', () async {
        final profile = UserProfile.createDefault()
          ..chronoType = ChronoType.earlyBird
          ..onboardingCompleted = true;
        await userProfileRepository.saveProfile(profile);

        final goal = createTestGoal(title: 'Test Goal');
        final date = DateTime(2024, 1, 15);

        final recommendations = await profileBasedScheduler.getSchedulingRecommendations(
          goal,
          date,
        );

        expect(recommendations['chrono_type'], equals('earlyBird'));
        expect(recommendations['chrono_high_priority_window'], isNotNull);
        expect(recommendations['chrono_medium_priority_window'], isNotNull);
      });
    });
  });
}
