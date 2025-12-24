import 'package:flutter/foundation.dart';
import 'package:usage_stats/usage_stats.dart';

/// Service to interact with Android Usage Stats API
/// Used to detect actual sleep and wake times based on device usage
class DeviceUsageService {
  /// Check if usage stats permission is granted
  Future<bool> checkPermission() async {
    try {
      final result = await UsageStats.checkUsagePermission();
      return result ?? false;
    } catch (e) {
      debugPrint('DeviceUsageService: Error checking permission: $e');
      return false;
    }
  }

  /// Request usage stats permission
  /// Opens the system settings page
  Future<void> requestPermission() async {
    try {
      await UsageStats.grantUsagePermission();
    } catch (e) {
      debugPrint('DeviceUsageService: Error requesting permission: $e');
    }
  }

  /// Get the time the user woke up on a specific date
  /// Logic: First usage event between 4:00 AM and 12:00 PM
  Future<DateTime?> getWakeTime(DateTime date) async {
    if (!await checkPermission()) return null;

    try {
      final start = DateTime(date.year, date.month, date.day, 4, 0);
      final end = DateTime(date.year, date.month, date.day, 12, 0);

      final events = await UsageStats.queryEvents(start, end);

      if (events.isEmpty) return null;

      // Filter for MOVE_TO_FOREGROUND events (eventType "1" or "2" typically)
      // Sort by timestamp ascending to find the first one
      final sortedEvents =
          events
              .where(
                (e) => e.timeStamp != null && e.eventType == "1",
              ) // MOVE_TO_FOREGROUND
              .toList()
            ..sort(
              (a, b) =>
                  int.parse(a.timeStamp!).compareTo(int.parse(b.timeStamp!)),
            );

      if (sortedEvents.isNotEmpty) {
        final timestamp = int.parse(sortedEvents.first.timeStamp!);
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      debugPrint('DeviceUsageService: Error getting wake time: $e');
      return null;
    }
  }

  /// Get the time the user went to sleep on a specific date
  /// Logic: Last usage event between 6:00 PM (this day) and 4:00 AM (next day)
  Future<DateTime?> getSleepTime(DateTime date) async {
    if (!await checkPermission()) return null;

    try {
      final start = DateTime(date.year, date.month, date.day, 18, 0);
      final end = DateTime(
        date.year,
        date.month,
        date.day,
      ).add(const Duration(days: 1, hours: 4));

      final events = await UsageStats.queryEvents(start, end);

      if (events.isEmpty) return null;

      // Sort by timestamp descending to find the last one
      final sortedEvents =
          events
              .where(
                (e) =>
                    e.timeStamp != null &&
                    (e.eventType == "1" || e.eventType == "2"),
              )
              .toList()
            ..sort(
              (a, b) =>
                  int.parse(b.timeStamp!).compareTo(int.parse(a.timeStamp!)),
            );

      if (sortedEvents.isNotEmpty) {
        final timestamp = int.parse(sortedEvents.first.timeStamp!);
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      debugPrint('DeviceUsageService: Error getting sleep time: $e');
      return null;
    }
  }
}
