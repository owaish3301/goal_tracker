import 'package:isar/isar.dart';
import '../models/user_profile.dart';

class UserProfileRepository {
  final Isar isar;

  UserProfileRepository(this.isar);

  // === CREATE ===

  /// Create or update the user profile (only one profile exists)
  Future<int> saveProfile(UserProfile profile) async {
    profile.updatedAt = DateTime.now();
    return await isar.writeTxn(() async {
      return await isar.userProfiles.put(profile);
    });
  }

  /// Initialize default profile if none exists
  Future<UserProfile> initializeProfile() async {
    final existing = await getProfile();
    if (existing != null) {
      return existing;
    }

    final defaultProfile = UserProfile.createDefault();
    await saveProfile(defaultProfile);
    return defaultProfile;
  }

  // === READ ===

  /// Get the user profile (there's only one)
  Future<UserProfile?> getProfile() async {
    return await isar.userProfiles.where().findFirst();
  }

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding() async {
    final profile = await getProfile();
    return profile?.onboardingCompleted ?? false;
  }

  /// Get user's chronotype
  Future<ChronoType?> getChronoType() async {
    final profile = await getProfile();
    return profile?.chronoType;
  }

  /// Get user's active hours (wake to sleep)
  Future<(int, int)?> getActiveHours() async {
    final profile = await getProfile();
    if (profile == null) return null;
    return profile.getActiveHours();
  }

  /// Get chrono-type based time windows
  Future<Map<String, (int, int)>?> getChronoTypeWindows() async {
    final profile = await getProfile();
    if (profile == null) return null;
    return profile.getChronoTypeWindows();
  }

  // === UPDATE ===

  /// Update chronotype from onboarding
  Future<void> updateChronoType(ChronoType chronoType) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.chronoType = chronoType;
      await saveProfile(profile);
    }
  }

  /// Update sleep schedule from onboarding
  Future<void> updateSleepSchedule(int wakeUpHour, int sleepHour) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.wakeUpHour = wakeUpHour;
      profile.sleepHour = sleepHour;
      await saveProfile(profile);
    }
  }

  /// Update work schedule from onboarding
  Future<void> updateWorkSchedule({
    required bool hasWorkSchedule,
    int? workStartHour,
    int? workEndHour,
  }) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.hasWorkSchedule = hasWorkSchedule;
      profile.workStartHour = workStartHour;
      profile.workEndHour = workEndHour;
      await saveProfile(profile);
    }
  }

  /// Update session length preference from onboarding
  Future<void> updateSessionLength(SessionLength sessionLength) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.preferredSessionLength = sessionLength;
      await saveProfile(profile);
    }
  }

  /// Update routine preference
  Future<void> updateRoutinePreference(bool prefersRoutine) async {
    final profile = await getProfile();
    if (profile != null) {
      profile.prefersRoutine = prefersRoutine;
      await saveProfile(profile);
    }
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    final profile = await getProfile();
    if (profile != null) {
      profile.onboardingCompleted = true;
      await saveProfile(profile);
    }
  }

  /// Update entire profile from onboarding completion
  Future<void> saveOnboardingData({
    required ChronoType chronoType,
    required int wakeUpHour,
    required int sleepHour,
    required bool hasWorkSchedule,
    int? workStartHour,
    int? workEndHour,
    required SessionLength sessionLength,
    required bool prefersRoutine,
  }) async {
    final profile = await getProfile() ?? UserProfile.createDefault();
    
    profile
      ..chronoType = chronoType
      ..wakeUpHour = wakeUpHour
      ..sleepHour = sleepHour
      ..hasWorkSchedule = hasWorkSchedule
      ..workStartHour = workStartHour
      ..workEndHour = workEndHour
      ..preferredSessionLength = sessionLength
      ..prefersRoutine = prefersRoutine
      ..onboardingCompleted = true
      ..updatedAt = DateTime.now();

    await saveProfile(profile);
  }

  // === DELETE ===

  /// Reset profile to defaults (useful for "redo onboarding")
  Future<void> resetProfile() async {
    await isar.writeTxn(() async {
      await isar.userProfiles.clear();
    });
    await initializeProfile();
  }

  /// Delete profile completely
  Future<void> deleteProfile() async {
    await isar.writeTxn(() async {
      await isar.userProfiles.clear();
    });
  }
}
