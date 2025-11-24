import 'package:isar/isar.dart';

part 'one_time_task.g.dart';

@collection
class OneTimeTask {
  Id id = Isar.autoIncrement;

  late String title; // e.g., "Laundry", "Doctor Appointment"

  @Index()
  late DateTime scheduledDate;
  late DateTime scheduledStartTime;
  late int duration; // In minutes

  // Optional
  String? notes;
  String? colorHex;

  @Index()
  late bool isCompleted;

  late DateTime createdAt;
  DateTime? completedAt;
}
