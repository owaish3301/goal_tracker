import 'package:isar/isar.dart';
import 'goal.dart';
import 'milestone.dart';

part 'task.g.dart';

enum TaskStatus { pending, completed, skipped, rescheduled }

@collection
class Task {
  Id id = Isar.autoIncrement;

  // Scheduling
  @Index()
  late DateTime scheduledDate; // Date only (normalized to midnight)
  late DateTime scheduledStartTime; // Full datetime
  late int scheduledDuration; // In minutes

  // Actual completion data
  DateTime? actualStartTime;
  int? actualDuration; // In minutes

  // Productivity feedback
  double? productivityScore; // 1.0 to 5.0
  String? notes;

  // Status
  @Index()
  @Enumerated(EnumType.name)
  late TaskStatus status; // pending, completed, skipped, rescheduled

  // Relationships
  final goal = IsarLink<Goal>();
  final completedMilestone = IsarLink<Milestone>(); // Optional

  // Timestamps
  late DateTime createdAt;
  DateTime? completedAt;

  // ML tracking
  late bool wasManuallyRescheduled;
  DateTime? originalScheduledTime; // If rescheduled
}
