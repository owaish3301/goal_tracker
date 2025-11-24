import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = Isar.autoIncrement;

  // Scheduling preferences
  late int dayStartHour; // Default: 6 (6 AM)
  late int dayEndHour; // Default: 23 (11 PM)

  // ML settings
  late bool mlEnabled;
  late int minTrainingDataPoints; // Default: 10

  // UI preferences
  late bool darkMode;
  late String accentColor;

  // Notifications
  late bool notificationsEnabled;
  late int reminderMinutesBefore; // Default: 15

  late DateTime updatedAt;
}
