import 'package:isar/isar.dart';

part 'user_profile.g.dart';

/// User chronotype - when they are most productive
enum ChronoType {
  earlyBird,  // Peak productivity: 6-10 AM
  normal,     // Peak productivity: 9 AM - 12 PM
  nightOwl,   // Peak productivity: 8 PM - 12 AM
  flexible,   // No strong preference
}

/// User's preferred session length
enum SessionLength {
  short,   // 15-30 minutes
  medium,  // 30-60 minutes
  long,    // 60+ minutes
}

/// User profile for personalized scheduling
@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  // === CHRONOTYPE (from onboarding) ===
  
  /// User's chronotype (0=earlyBird, 1=normal, 2=nightOwl, 3=flexible)
  @enumerated
  late ChronoType chronoType;

  // === SLEEP SCHEDULE ===
  
  /// Typical wake-up hour (0-23)
  late int wakeUpHour;
  
  /// Typical sleep hour (0-23)
  late int sleepHour;

  // === WORK/LIFE BOUNDARIES (optional) ===
  
  /// Whether user has fixed work hours
  late bool hasWorkSchedule;
  
  /// Work start hour (0-23), null if no fixed schedule
  int? workStartHour;
  
  /// Work end hour (0-23), null if no fixed schedule
  int? workEndHour;
  
  /// Days with less free time (0=Monday, 6=Sunday)
  List<int> busyDays = [];

  // === PREFERENCES ===
  
  /// Preferred session length (0=short, 1=medium, 2=long)
  @enumerated
  late SessionLength preferredSessionLength;
  
  /// Whether user prefers same time daily (routine) vs variety
  late bool prefersRoutine;

  // === ONBOARDING STATUS ===
  
  /// Whether user has completed onboarding
  @Index()
  late bool onboardingCompleted;

  // === TIMESTAMPS ===
  
  late DateTime createdAt;
  DateTime? updatedAt;

  // === HELPER METHODS ===

  /// Get the active hours window based on profile
  (int startHour, int endHour) getActiveHours() {
    return (wakeUpHour, sleepHour);
  }

  /// Get preferred time windows based on chronotype
  /// Returns (highPriorityStart, highPriorityEnd, mediumStart, mediumEnd, lowStart, lowEnd)
  Map<String, (int, int)> getChronoTypeWindows() {
    switch (chronoType) {
      case ChronoType.earlyBird:
        return {
          'high': (6, 10),      // Peak focus: early morning
          'medium': (10, 14),   // Good focus: late morning/early afternoon
          'low': (14, 20),      // Lower energy: afternoon/evening
        };
      case ChronoType.normal:
        return {
          'high': (9, 12),      // Peak focus: mid-morning
          'medium': (14, 18),   // Good focus: afternoon
          'low': (18, 22),      // Lower energy: evening
        };
      case ChronoType.nightOwl:
        return {
          'high': (20, 24),     // Peak focus: evening/night
          'medium': (16, 20),   // Good focus: late afternoon
          'low': (10, 16),      // Lower energy: daytime
        };
      case ChronoType.flexible:
        return {
          'high': (9, 12),      // Default to normal pattern
          'medium': (14, 18),
          'low': (18, 22),
        };
    }
  }

  /// Check if a given hour is during work hours
  bool isDuringWorkHours(int hour) {
    if (!hasWorkSchedule || workStartHour == null || workEndHour == null) {
      return false;
    }
    return hour >= workStartHour! && hour < workEndHour!;
  }

  /// Get the preferred session duration in minutes
  int getPreferredDurationMinutes() {
    switch (preferredSessionLength) {
      case SessionLength.short:
        return 25; // Pomodoro-style
      case SessionLength.medium:
        return 45;
      case SessionLength.long:
        return 90; // Deep work block
    }
  }

  /// Create default profile (used before onboarding)
  static UserProfile createDefault() {
    return UserProfile()
      ..chronoType = ChronoType.normal
      ..wakeUpHour = 7
      ..sleepHour = 23
      ..hasWorkSchedule = false
      ..workStartHour = null
      ..workEndHour = null
      ..busyDays = []
      ..preferredSessionLength = SessionLength.medium
      ..prefersRoutine = true
      ..onboardingCompleted = false
      ..createdAt = DateTime.now();
  }
}
