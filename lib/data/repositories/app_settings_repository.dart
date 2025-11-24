import 'package:isar/isar.dart';
import '../models/app_settings.dart';

class AppSettingsRepository {
  final Isar isar;

  AppSettingsRepository(this.isar);

  // Get or create settings
  Future<AppSettings> getSettings() async {
    final settings = await isar.appSettings.where().findFirst();

    if (settings != null) {
      return settings;
    }

    // Create default settings if none exist
    return await _createDefaultSettings();
  }

  // Create default settings
  Future<AppSettings> _createDefaultSettings() async {
    final settings = AppSettings()
      ..dayStartHour = 6
      ..dayEndHour = 23
      ..mlEnabled = false
      ..minTrainingDataPoints = 10
      ..darkMode = true
      ..accentColor = '#BB86FC'
      ..notificationsEnabled = false
      ..reminderMinutesBefore = 15
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.appSettings.put(settings);
    });

    return settings;
  }

  // Update settings
  Future<void> updateSettings(AppSettings settings) async {
    await isar.writeTxn(() async {
      settings.updatedAt = DateTime.now();
      await isar.appSettings.put(settings);
    });
  }

  // Update specific fields
  Future<void> updateDayStartHour(int hour) async {
    final settings = await getSettings();
    settings.dayStartHour = hour;
    await updateSettings(settings);
  }

  Future<void> updateDayEndHour(int hour) async {
    final settings = await getSettings();
    settings.dayEndHour = hour;
    await updateSettings(settings);
  }

  Future<void> toggleMlEnabled(bool enabled) async {
    final settings = await getSettings();
    settings.mlEnabled = enabled;
    await updateSettings(settings);
  }

  Future<void> updateMinTrainingDataPoints(int points) async {
    final settings = await getSettings();
    settings.minTrainingDataPoints = points;
    await updateSettings(settings);
  }

  Future<void> toggleDarkMode(bool enabled) async {
    final settings = await getSettings();
    settings.darkMode = enabled;
    await updateSettings(settings);
  }

  Future<void> updateAccentColor(String color) async {
    final settings = await getSettings();
    settings.accentColor = color;
    await updateSettings(settings);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final settings = await getSettings();
    settings.notificationsEnabled = enabled;
    await updateSettings(settings);
  }

  Future<void> updateReminderMinutes(int minutes) async {
    final settings = await getSettings();
    settings.reminderMinutesBefore = minutes;
    await updateSettings(settings);
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    final settings = await getSettings();
    await isar.writeTxn(() async {
      await isar.appSettings.delete(settings.id);
    });
    await _createDefaultSettings();
  }
}
