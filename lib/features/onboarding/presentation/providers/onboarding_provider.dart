import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/core/services/database_service.dart';

/// Onboarding data collected across screens
class OnboardingData {
  final ChronoType? chronoType;
  final int? wakeUpHour;
  final int? sleepHour;
  final SessionLength? sessionLength;
  final bool? hasWorkSchedule;
  final int? workStartHour;
  final int? workEndHour;

  const OnboardingData({
    this.chronoType,
    this.wakeUpHour,
    this.sleepHour,
    this.sessionLength,
    this.hasWorkSchedule,
    this.workStartHour,
    this.workEndHour,
  });

  OnboardingData copyWith({
    ChronoType? chronoType,
    int? wakeUpHour,
    int? sleepHour,
    SessionLength? sessionLength,
    bool? hasWorkSchedule,
    int? workStartHour,
    int? workEndHour,
  }) {
    return OnboardingData(
      chronoType: chronoType ?? this.chronoType,
      wakeUpHour: wakeUpHour ?? this.wakeUpHour,
      sleepHour: sleepHour ?? this.sleepHour,
      sessionLength: sessionLength ?? this.sessionLength,
      hasWorkSchedule: hasWorkSchedule ?? this.hasWorkSchedule,
      workStartHour: workStartHour ?? this.workStartHour,
      workEndHour: workEndHour ?? this.workEndHour,
    );
  }

  /// Check if we have minimum required data
  bool get isComplete =>
      chronoType != null &&
      wakeUpHour != null &&
      sleepHour != null &&
      sessionLength != null;
}

/// Onboarding state
class OnboardingState {
  final int currentPage;
  final OnboardingData data;
  final bool isCompleting;
  final String? error;

  const OnboardingState({
    this.currentPage = 0,
    this.data = const OnboardingData(),
    this.isCompleting = false,
    this.error,
  });

  OnboardingState copyWith({
    int? currentPage,
    OnboardingData? data,
    bool? isCompleting,
    String? error,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      isCompleting: isCompleting ?? this.isCompleting,
      error: error,
    );
  }

  /// Total pages in onboarding
  static const int totalPages = 6; // Welcome, Chronotype, Sleep, Session, Work, Complete
}

/// Onboarding controller notifier
class OnboardingController extends StateNotifier<OnboardingState> {
  final Ref ref;

  OnboardingController(this.ref) : super(const OnboardingState());

  /// Navigate to next page with animation
  void nextPage() {
    if (state.currentPage < OnboardingState.totalPages - 1) {
      final nextPageIndex = state.currentPage + 1;
      state = state.copyWith(currentPage: nextPageIndex);
    }
  }

  /// Navigate to previous page
  void previousPage() {
    if (state.currentPage > 0) {
      final prevPageIndex = state.currentPage - 1;
      state = state.copyWith(currentPage: prevPageIndex);
    }
  }

  /// Skip to completion (uses defaults)
  void skipToCompletion() {
    // Set defaults if not already set
    final data = OnboardingData(
      chronoType: state.data.chronoType ?? ChronoType.normal,
      wakeUpHour: state.data.wakeUpHour ?? 7,
      sleepHour: state.data.sleepHour ?? 23,
      sessionLength: state.data.sessionLength ?? SessionLength.medium,
      hasWorkSchedule: state.data.hasWorkSchedule ?? false,
      workStartHour: state.data.workStartHour,
      workEndHour: state.data.workEndHour,
    );
    final completionPage = OnboardingState.totalPages - 1;
    state = state.copyWith(
      data: data,
      currentPage: completionPage,
    );
  }

  /// Update chronotype
  void setChronoType(ChronoType type) {
    // Auto-set suggested sleep schedule based on chronotype
    int wakeUp = state.data.wakeUpHour ?? 7;
    int sleep = state.data.sleepHour ?? 23;

    switch (type) {
      case ChronoType.earlyBird:
        wakeUp = 5;
        sleep = 21;
        break;
      case ChronoType.normal:
        wakeUp = 7;
        sleep = 23;
        break;
      case ChronoType.nightOwl:
        wakeUp = 9;
        sleep = 1;
        break;
      case ChronoType.flexible:
        wakeUp = 7;
        sleep = 23;
        break;
    }

    state = state.copyWith(
      data: state.data.copyWith(
        chronoType: type,
        wakeUpHour: wakeUp,
        sleepHour: sleep,
      ),
    );
  }

  /// Update sleep schedule
  void setSleepSchedule(int wakeUpHour, int sleepHour) {
    state = state.copyWith(
      data: state.data.copyWith(
        wakeUpHour: wakeUpHour,
        sleepHour: sleepHour,
      ),
    );
  }

  /// Update session length
  void setSessionLength(SessionLength length) {
    state = state.copyWith(
      data: state.data.copyWith(sessionLength: length),
    );
  }

  /// Update work schedule
  void setWorkSchedule({
    required bool hasWorkSchedule,
    int? workStartHour,
    int? workEndHour,
  }) {
    state = state.copyWith(
      data: state.data.copyWith(
        hasWorkSchedule: hasWorkSchedule,
        workStartHour: hasWorkSchedule ? (workStartHour ?? 9) : null,
        workEndHour: hasWorkSchedule ? (workEndHour ?? 17) : null,
      ),
    );
  }

  /// Complete onboarding and save profile
  Future<bool> completeOnboarding() async {
    if (state.isCompleting) return false;

    state = state.copyWith(isCompleting: true, error: null);

    try {
      final repository = ref.read(userProfileRepositoryProvider);

      // Ensure we have all required data with defaults
      final data = OnboardingData(
        chronoType: state.data.chronoType ?? ChronoType.normal,
        wakeUpHour: state.data.wakeUpHour ?? 7,
        sleepHour: state.data.sleepHour ?? 23,
        sessionLength: state.data.sessionLength ?? SessionLength.medium,
        hasWorkSchedule: state.data.hasWorkSchedule ?? false,
        workStartHour: state.data.workStartHour,
        workEndHour: state.data.workEndHour,
      );

      await repository.saveOnboardingData(
        chronoType: data.chronoType!,
        wakeUpHour: data.wakeUpHour!,
        sleepHour: data.sleepHour!,
        hasWorkSchedule: data.hasWorkSchedule!,
        workStartHour: data.workStartHour,
        workEndHour: data.workEndHour,
        sessionLength: data.sessionLength!,
        prefersRoutine: true, // Default
      );

      state = state.copyWith(isCompleting: false);
      
      // Invalidate the onboarding completed provider so router gets fresh value
      ref.invalidate(isOnboardingCompletedProvider);
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isCompleting: false,
        error: 'Failed to save profile: $e',
      );
      return false;
    }
  }
}

/// Provider for onboarding controller
/// Note: Not using autoDispose to keep state during onboarding flow
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(ref),
);

/// Provider to check if onboarding is completed
final isOnboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(userProfileRepositoryProvider);
  return await repository.hasCompletedOnboarding();
});
