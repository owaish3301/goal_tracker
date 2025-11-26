import 'package:isar/isar.dart';

part 'habit_metrics.g.dart';

/// Tracks habit formation metrics for each goal
/// Used for streak tracking, consistency scoring, and habit formation insights
@collection
class HabitMetrics {
  Id id = Isar.autoIncrement;

  /// The goal this metrics record belongs to
  @Index(unique: true)
  late int goalId;

  // === Streak Tracking ===
  
  /// Current consecutive days streak
  late int currentStreak;

  /// Longest ever streak for this goal
  late int longestStreak;

  /// Date of last completion (for streak calculation)
  DateTime? lastCompletedDate;

  /// Whether the streak is at risk (scheduled today but not completed)
  @ignore
  bool get streakAtRisk {
    if (lastCompletedDate == null) return false;
    if (currentStreak == 0) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCompletion = DateTime(
      lastCompletedDate!.year,
      lastCompletedDate!.month,
      lastCompletedDate!.day,
    );
    // At risk if last completion was yesterday
    return today.difference(lastCompletion).inDays == 1;
  }

  // === Consistency Metrics ===
  
  /// Percentage of scheduled days that were completed (0.0 - 1.0)
  late double consistencyScore;

  /// Percentage of completions at the same hour (0.0 - 1.0)
  /// High value = habit forming at consistent time
  late double timeConsistency;

  /// The hour of day where most completions occur (0-23)
  /// null if not enough data
  int? stickyHour;

  /// The day of week where completions are most consistent (0=Mon, 6=Sun)
  /// null if not enough data
  int? stickyDayOfWeek;

  // === Completion Counts ===
  
  /// Total number of times this goal was completed
  late int totalCompletions;

  /// Total number of times this goal was scheduled
  late int totalScheduled;

  // === Timestamps ===
  
  /// When this metrics record was created
  late DateTime createdAt;

  /// When this metrics record was last updated
  late DateTime updatedAt;

  // === Computed Properties ===

  /// Completion rate as a decimal (0.0 - 1.0)
  @ignore
  double get completionRate {
    if (totalScheduled == 0) return 0.0;
    return totalCompletions / totalScheduled;
  }

  /// Whether this goal has achieved "habit lock" (21+ day streak)
  @ignore
  bool get isHabitLocked => currentStreak >= 21;

  /// Whether this is a strong habit (14+ day streak, 70%+ consistency)
  @ignore
  bool get isStrongHabit => currentStreak >= 14 && consistencyScore >= 0.7;

  /// Whether this is a forming habit (7+ day streak, 50%+ consistency)
  @ignore
  bool get isFormingHabit => currentStreak >= 7 && consistencyScore >= 0.5;

  /// Habit formation stage description
  @ignore
  String get habitStage {
    if (currentStreak >= 21) return 'Habit Locked';
    if (currentStreak >= 7) return 'Almost There';
    if (currentStreak >= 3) return 'Building';
    return 'Starting';
  }

  /// Days until habit lock (21-day rule)
  @ignore
  int get daysUntilHabitLock => (21 - currentStreak).clamp(0, 21);

  /// Formatted sticky time string (e.g. "9 AM")
  @ignore
  String? get formattedStickyTime {
    if (stickyHour == null) return null;
    final hour = stickyHour!;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour $period';
  }

  /// Create default metrics for a new goal
  static HabitMetrics createDefault(int goalId) {
    final now = DateTime.now();
    return HabitMetrics()
      ..goalId = goalId
      ..currentStreak = 0
      ..longestStreak = 0
      ..lastCompletedDate = null
      ..consistencyScore = 0.0
      ..timeConsistency = 0.0
      ..stickyHour = null
      ..stickyDayOfWeek = null
      ..totalCompletions = 0
      ..totalScheduled = 0
      ..createdAt = now
      ..updatedAt = now;
  }

  @override
  String toString() {
    return 'HabitMetrics(goalId: $goalId, streak: $currentStreak/$longestStreak, '
        'consistency: ${(consistencyScore * 100).toStringAsFixed(1)}%, '
        'completed: $totalCompletions/$totalScheduled)';
  }
}
