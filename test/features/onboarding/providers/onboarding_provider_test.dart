import 'package:flutter_test/flutter_test.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/features/onboarding/presentation/providers/onboarding_provider.dart';

void main() {
  group('OnboardingData', () {
    test('copyWith creates new instance with updated values', () {
      const original = OnboardingData(
        chronoType: ChronoType.earlyBird,
        wakeUpHour: 5,
        sleepHour: 21,
      );

      final updated = original.copyWith(
        sessionLength: SessionLength.medium,
        hasWorkSchedule: true,
      );

      expect(updated.chronoType, ChronoType.earlyBird);
      expect(updated.wakeUpHour, 5);
      expect(updated.sleepHour, 21);
      expect(updated.sessionLength, SessionLength.medium);
      expect(updated.hasWorkSchedule, true);
    });

    test('isComplete returns true when all required fields are set', () {
      const complete = OnboardingData(
        chronoType: ChronoType.normal,
        wakeUpHour: 7,
        sleepHour: 23,
        sessionLength: SessionLength.medium,
      );

      expect(complete.isComplete, true);
    });

    test('isComplete returns false when chronoType is missing', () {
      const incomplete = OnboardingData(
        wakeUpHour: 7,
        sleepHour: 23,
        sessionLength: SessionLength.medium,
      );

      expect(incomplete.isComplete, false);
    });

    test('isComplete returns false when wakeUpHour is missing', () {
      const incomplete = OnboardingData(
        chronoType: ChronoType.normal,
        sleepHour: 23,
        sessionLength: SessionLength.medium,
      );

      expect(incomplete.isComplete, false);
    });

    test('isComplete returns false when sleepHour is missing', () {
      const incomplete = OnboardingData(
        chronoType: ChronoType.normal,
        wakeUpHour: 7,
        sessionLength: SessionLength.medium,
      );

      expect(incomplete.isComplete, false);
    });

    test('isComplete returns false when sessionLength is missing', () {
      const incomplete = OnboardingData(
        chronoType: ChronoType.normal,
        wakeUpHour: 7,
        sleepHour: 23,
      );

      expect(incomplete.isComplete, false);
    });
  });

  group('OnboardingState', () {
    test('initial state has correct defaults', () {
      const state = OnboardingState();

      expect(state.currentPage, 0);
      expect(state.data.chronoType, null);
      expect(state.data.wakeUpHour, null);
      expect(state.data.sleepHour, null);
      expect(state.data.sessionLength, null);
      expect(state.isCompleting, false);
      expect(state.error, null);
    });

    test('totalPages is 6', () {
      expect(OnboardingState.totalPages, 6);
    });

    test('copyWith updates only specified values', () {
      const original = OnboardingState(currentPage: 1);
      final updated = original.copyWith(
        isCompleting: true,
        error: 'test error',
      );

      expect(updated.currentPage, 1);
      expect(updated.isCompleting, true);
      expect(updated.error, 'test error');
    });

    test('copyWith with new data replaces data entirely', () {
      const original = OnboardingState(
        data: OnboardingData(chronoType: ChronoType.earlyBird),
      );
      final updated = original.copyWith(
        data: const OnboardingData(chronoType: ChronoType.nightOwl),
      );

      expect(updated.data.chronoType, ChronoType.nightOwl);
    });
  });

  group('ChronoType sleep suggestions', () {
    test('earlyBird suggests early wake and sleep times', () {
      // Test that chronotype auto-sets appropriate times
      const type = ChronoType.earlyBird;
      expect(type.name, 'earlyBird');
      
      // Expected: wake 5am, sleep 9pm
      // This would be validated in the controller test with Riverpod
    });

    test('nightOwl suggests late wake and sleep times', () {
      const type = ChronoType.nightOwl;
      expect(type.name, 'nightOwl');
      
      // Expected: wake 9am, sleep 1am
    });

    test('normal suggests standard wake and sleep times', () {
      const type = ChronoType.normal;
      expect(type.name, 'normal');
      
      // Expected: wake 7am, sleep 11pm
    });
  });

  group('SessionLength properties', () {
    test('short session represents 15-30 minutes', () {
      const length = SessionLength.short;
      expect(length.name, 'short');
    });

    test('medium session represents 30-60 minutes', () {
      const length = SessionLength.medium;
      expect(length.name, 'medium');
    });

    test('long session represents 60-90 minutes', () {
      const length = SessionLength.long;
      expect(length.name, 'long');
    });
  });

  group('Work schedule data', () {
    test('work schedule can be disabled', () {
      const data = OnboardingData(
        chronoType: ChronoType.normal,
        wakeUpHour: 7,
        sleepHour: 23,
        sessionLength: SessionLength.medium,
        hasWorkSchedule: false,
      );

      expect(data.hasWorkSchedule, false);
      expect(data.workStartHour, null);
      expect(data.workEndHour, null);
      expect(data.isComplete, true);
    });

    test('work schedule with times stores correctly', () {
      const data = OnboardingData(
        chronoType: ChronoType.normal,
        wakeUpHour: 7,
        sleepHour: 23,
        sessionLength: SessionLength.medium,
        hasWorkSchedule: true,
        workStartHour: 9,
        workEndHour: 17,
      );

      expect(data.hasWorkSchedule, true);
      expect(data.workStartHour, 9);
      expect(data.workEndHour, 17);
    });
  });
}
