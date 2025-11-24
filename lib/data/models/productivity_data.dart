import 'package:isar/isar.dart';

part 'productivity_data.g.dart';

/// Stores training data for the ML model
/// Each record represents one completed task session
@collection
class ProductivityData {
  Id id = Isar.autoIncrement;

  // === FEATURES (Input to ML model) ===

  // Goal identification
  @Index(composite: [CompositeIndex('hourOfDay'), CompositeIndex('dayOfWeek')])
  late int goalId;

  // Time features
  late int hourOfDay; // 0-23
  late int dayOfWeek; // 0-6 (0=Monday, 6=Sunday)
  late int duration; // Planned duration in minutes

  // Context features
  late int
  timeSlotType; // 0=morning(6-12), 1=afternoon(12-18), 2=evening(18-22), 3=night(22-6)
  late bool hadPriorTask; // Was there a task scheduled before this?
  late bool hadFollowingTask; // Was there a task scheduled after this?

  // Additional context
  late int weekOfYear; // 1-52 (for seasonal patterns)
  late bool isWeekend; // true if Saturday or Sunday

  // === LABEL (Output from ML model) ===
  late double productivityScore; // 1.0 - 5.0 (user's rating)

  // === BEHAVIORAL SIGNALS ===
  late bool wasRescheduled; // Very important signal!
  late bool wasCompleted; // Did user complete it or skip it?
  late int actualDurationMinutes; // How long it actually took

  // Deviation from schedule (important for learning)
  late int
  minutesFromScheduled; // Difference between scheduled and actual start

  // === METADATA ===
  @Index()
  late DateTime recordedAt; // When this data was recorded
  late int scheduledTaskId; // Link back to the scheduled task

  // For tracking model performance
  double? predictedScore; // What the model predicted (if ML was used)
  double? predictionError; // |predicted - actual| for model evaluation

  // Constructor
  ProductivityData() {
    wasRescheduled = false;
    wasCompleted = true;
    hadPriorTask = false;
    hadFollowingTask = false;
    recordedAt = DateTime.now();
    timeSlotType = 0;
    weekOfYear = 1;
    isWeekend = false;
    minutesFromScheduled = 0;
    actualDurationMinutes = 0;
  }

  // Helper to calculate time slot type
  static int calculateTimeSlotType(int hour) {
    if (hour >= 6 && hour < 12) return 0; // Morning
    if (hour >= 12 && hour < 18) return 1; // Afternoon
    if (hour >= 18 && hour < 22) return 2; // Evening
    return 3; // Night
  }
}
