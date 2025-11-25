import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/data/repositories/user_profile_repository.dart';

void main() {
  late Isar isar;
  late UserProfileRepository repository;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [UserProfileSchema],
      directory: '',
      name: 'user_profile_test_${DateTime.now().millisecondsSinceEpoch}',
    );
    repository = UserProfileRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('UserProfileRepository', () {
    group('initializeProfile', () {
      test('creates default profile when none exists', () async {
        final profile = await repository.initializeProfile();

        expect(profile, isNotNull);
        expect(profile.id, isNotNull);
        expect(profile.chronoType, ChronoType.normal);
        expect(profile.wakeUpHour, 7);
        expect(profile.sleepHour, 23);
        expect(profile.preferredSessionLength, SessionLength.medium);
        expect(profile.onboardingCompleted, false);
      });

      test('returns existing profile when one exists', () async {
        // Create a custom profile
        final customProfile = UserProfile()
          ..chronoType = ChronoType.earlyBird
          ..wakeUpHour = 5
          ..sleepHour = 21
          ..hasWorkSchedule = false
          ..preferredSessionLength = SessionLength.short
          ..prefersRoutine = true
          ..onboardingCompleted = true
          ..createdAt = DateTime.now();

        await isar.writeTxn(() async {
          await isar.userProfiles.put(customProfile);
        });

        final profile = await repository.initializeProfile();

        expect(profile.chronoType, ChronoType.earlyBird);
        expect(profile.wakeUpHour, 5);
        expect(profile.sleepHour, 21);
        expect(profile.onboardingCompleted, true);
      });
    });

    group('saveProfile', () {
      test('saves a new profile', () async {
        final profile = UserProfile()
          ..chronoType = ChronoType.nightOwl
          ..wakeUpHour = 10
          ..sleepHour = 2
          ..hasWorkSchedule = false
          ..preferredSessionLength = SessionLength.long
          ..prefersRoutine = false
          ..onboardingCompleted = false
          ..createdAt = DateTime.now();

        final id = await repository.saveProfile(profile);

        expect(id, isNotNull);
        expect(id, greaterThan(0));

        final saved = await isar.userProfiles.get(id);
        expect(saved, isNotNull);
        expect(saved!.chronoType, ChronoType.nightOwl);
        expect(saved.wakeUpHour, 10);
        expect(saved.sleepHour, 2);
      });

      test('updates an existing profile', () async {
        final profile = UserProfile()
          ..chronoType = ChronoType.normal
          ..wakeUpHour = 7
          ..sleepHour = 23
          ..hasWorkSchedule = false
          ..preferredSessionLength = SessionLength.medium
          ..prefersRoutine = true
          ..onboardingCompleted = false
          ..createdAt = DateTime.now();

        final id = await repository.saveProfile(profile);
        profile.id = id;
        profile.chronoType = ChronoType.flexible;

        await repository.saveProfile(profile);

        final updated = await isar.userProfiles.get(id);
        expect(updated!.chronoType, ChronoType.flexible);
      });
    });

    group('getProfile', () {
      test('returns null when no profile exists', () async {
        final profile = await repository.getProfile();
        expect(profile, isNull);
      });

      test('returns profile when one exists', () async {
        await repository.initializeProfile();
        final profile = await repository.getProfile();
        expect(profile, isNotNull);
      });
    });

    group('hasCompletedOnboarding', () {
      test('returns false when no profile exists', () async {
        final completed = await repository.hasCompletedOnboarding();
        expect(completed, false);
      });

      test('returns false when profile exists but onboarding not completed',
          () async {
        await repository.initializeProfile();
        final completed = await repository.hasCompletedOnboarding();
        expect(completed, false);
      });

      test('returns true when onboarding is completed', () async {
        await repository.initializeProfile();
        await repository.completeOnboarding();

        final completed = await repository.hasCompletedOnboarding();
        expect(completed, true);
      });
    });

    group('updateChronoType', () {
      test('updates chronotype of existing profile', () async {
        await repository.initializeProfile();
        await repository.updateChronoType(ChronoType.nightOwl);

        final profile = await repository.getProfile();
        expect(profile!.chronoType, ChronoType.nightOwl);
      });
    });

    group('updateSleepSchedule', () {
      test('updates wake and sleep hours', () async {
        await repository.initializeProfile();
        await repository.updateSleepSchedule(6, 22);

        final profile = await repository.getProfile();
        expect(profile!.wakeUpHour, 6);
        expect(profile.sleepHour, 22);
      });
    });

    group('updateWorkSchedule', () {
      test('updates work schedule', () async {
        await repository.initializeProfile();
        await repository.updateWorkSchedule(
          hasWorkSchedule: true,
          workStartHour: 9,
          workEndHour: 17,
        );

        final profile = await repository.getProfile();
        expect(profile!.hasWorkSchedule, true);
        expect(profile.workStartHour, 9);
        expect(profile.workEndHour, 17);
      });

      test('clears work hours when no work schedule', () async {
        await repository.initializeProfile();
        await repository.updateWorkSchedule(hasWorkSchedule: false);

        final profile = await repository.getProfile();
        expect(profile!.hasWorkSchedule, false);
        expect(profile.workStartHour, isNull);
        expect(profile.workEndHour, isNull);
      });
    });

    group('updateSessionLength', () {
      test('updates session length preference', () async {
        await repository.initializeProfile();
        await repository.updateSessionLength(SessionLength.long);

        final profile = await repository.getProfile();
        expect(profile!.preferredSessionLength, SessionLength.long);
      });
    });

    group('updateRoutinePreference', () {
      test('updates routine preference', () async {
        await repository.initializeProfile();
        await repository.updateRoutinePreference(false);

        final profile = await repository.getProfile();
        expect(profile!.prefersRoutine, false);
      });
    });

    group('completeOnboarding', () {
      test('marks onboarding as completed', () async {
        await repository.initializeProfile();
        await repository.completeOnboarding();

        final profile = await repository.getProfile();
        expect(profile!.onboardingCompleted, true);
      });
    });

    group('saveOnboardingData', () {
      test('saves complete onboarding data', () async {
        await repository.initializeProfile();
        await repository.saveOnboardingData(
          chronoType: ChronoType.earlyBird,
          wakeUpHour: 5,
          sleepHour: 21,
          hasWorkSchedule: true,
          workStartHour: 8,
          workEndHour: 16,
          sessionLength: SessionLength.short,
          prefersRoutine: true,
        );

        final profile = await repository.getProfile();
        expect(profile!.chronoType, ChronoType.earlyBird);
        expect(profile.wakeUpHour, 5);
        expect(profile.sleepHour, 21);
        expect(profile.hasWorkSchedule, true);
        expect(profile.workStartHour, 8);
        expect(profile.workEndHour, 16);
        expect(profile.preferredSessionLength, SessionLength.short);
        expect(profile.prefersRoutine, true);
        expect(profile.onboardingCompleted, true);
      });
    });

    group('getActiveHours', () {
      test('returns null when no profile', () async {
        final hours = await repository.getActiveHours();
        expect(hours, isNull);
      });

      test('returns active hours tuple', () async {
        await repository.initializeProfile();
        final hours = await repository.getActiveHours();
        expect(hours, isNotNull);
        expect(hours!.$1, 7); // wake
        expect(hours.$2, 23); // sleep
      });
    });

    group('getChronoTypeWindows', () {
      test('returns null when no profile', () async {
        final windows = await repository.getChronoTypeWindows();
        expect(windows, isNull);
      });

      test('returns chrono windows for profile', () async {
        await repository.initializeProfile();
        final windows = await repository.getChronoTypeWindows();
        expect(windows, isNotNull);
        expect(windows!.containsKey('high'), true);
        expect(windows.containsKey('medium'), true);
        expect(windows.containsKey('low'), true);
      });
    });
  });

  group('UserProfile model', () {
    test('createDefault creates profile with correct defaults', () {
      final profile = UserProfile.createDefault();

      expect(profile.chronoType, ChronoType.normal);
      expect(profile.wakeUpHour, 7);
      expect(profile.sleepHour, 23);
      expect(profile.preferredSessionLength, SessionLength.medium);
      expect(profile.hasWorkSchedule, false);
      expect(profile.prefersRoutine, true);
      expect(profile.onboardingCompleted, false);
    });

    test('getActiveHours returns correct tuple', () {
      final profile = UserProfile()
        ..wakeUpHour = 7
        ..sleepHour = 23;

      final hours = profile.getActiveHours();
      expect(hours.$1, 7);
      expect(hours.$2, 23);
    });

    test('getChronoTypeWindows returns correct windows for earlyBird', () {
      final profile = UserProfile()
        ..chronoType = ChronoType.earlyBird
        ..wakeUpHour = 5
        ..sleepHour = 21;

      final windows = profile.getChronoTypeWindows();

      expect(windows.containsKey('high'), true);
      expect(windows.containsKey('medium'), true);
      expect(windows.containsKey('low'), true);
      // Early bird peak is 6-10
      expect(windows['high']!.$1, 6);
      expect(windows['high']!.$2, 10);
    });

    test('getChronoTypeWindows returns correct windows for nightOwl', () {
      final profile = UserProfile()
        ..chronoType = ChronoType.nightOwl
        ..wakeUpHour = 10
        ..sleepHour = 2;

      final windows = profile.getChronoTypeWindows();

      // Night owl peak is 20-24
      expect(windows['high']!.$1, 20);
      expect(windows['high']!.$2, 24);
    });

    test('getChronoTypeWindows returns correct windows for normal', () {
      final profile = UserProfile()..chronoType = ChronoType.normal;

      final windows = profile.getChronoTypeWindows();

      // Normal peak is 9-12
      expect(windows['high']!.$1, 9);
      expect(windows['high']!.$2, 12);
    });

    test('getChronoTypeWindows returns correct windows for flexible', () {
      final profile = UserProfile()..chronoType = ChronoType.flexible;

      final windows = profile.getChronoTypeWindows();

      // Flexible has wide ranges
      expect(windows.containsKey('high'), true);
    });
  });

  group('ChronoType enum', () {
    test('all values are available', () {
      expect(ChronoType.values.length, 4);
      expect(ChronoType.values, contains(ChronoType.earlyBird));
      expect(ChronoType.values, contains(ChronoType.normal));
      expect(ChronoType.values, contains(ChronoType.nightOwl));
      expect(ChronoType.values, contains(ChronoType.flexible));
    });
  });

  group('SessionLength enum', () {
    test('all values are available', () {
      expect(SessionLength.values.length, 3);
      expect(SessionLength.values, contains(SessionLength.short));
      expect(SessionLength.values, contains(SessionLength.medium));
      expect(SessionLength.values, contains(SessionLength.long));
    });
  });
}
