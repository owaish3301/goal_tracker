import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A provider that detects when midnight crosses while the app is in the foreground.
///
/// This solves the issue where background WorkManager tasks don't run when the app
/// is actively open. When the app is in foreground at midnight, this provider
/// detects the day change and notifies listeners.
final midnightDetectionProvider =
    StateNotifierProvider<MidnightDetectionNotifier, DateTime>((ref) {
      return MidnightDetectionNotifier();
    });

/// Notifier that tracks the current date and detects midnight crossing.
class MidnightDetectionNotifier extends StateNotifier<DateTime> {
  Timer? _midnightTimer;

  MidnightDetectionNotifier() : super(_normalizedToday()) {
    _scheduleMidnightTimer();
  }

  /// Returns today's date normalized to midnight (00:00:00)
  static DateTime _normalizedToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Schedules a timer to fire at the next midnight
  void _scheduleMidnightTimer() {
    _cancelTimer();

    final now = DateTime.now();
    // Calculate next midnight (add 5 seconds buffer to ensure we're past midnight)
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 5);
    final durationUntilMidnight = nextMidnight.difference(now);

    debugPrint(
      'MidnightDetection: Scheduling timer for ${durationUntilMidnight.inMinutes} minutes from now',
    );

    _midnightTimer = Timer(durationUntilMidnight, _onMidnightReached);
  }

  /// Called when midnight is reached
  void _onMidnightReached() {
    final newDate = _normalizedToday();
    debugPrint('MidnightDetection: Midnight reached! New date: $newDate');

    // Update state to trigger listeners
    state = newDate;

    // Schedule the next midnight timer
    _scheduleMidnightTimer();
  }

  /// Manually check if the date has changed (useful for app resume scenarios)
  void checkDateChange() {
    final currentDate = _normalizedToday();
    if (currentDate != state) {
      debugPrint('MidnightDetection: Date changed from $state to $currentDate');
      state = currentDate;

      // Reschedule timer since date changed
      _scheduleMidnightTimer();
    }
  }

  void _cancelTimer() {
    _midnightTimer?.cancel();
    _midnightTimer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
