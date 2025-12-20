import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/productivity_providers.dart';

/// Observer that tracks app lifecycle events and records user activity
/// This enables the system to learn actual wake/sleep patterns
class AppLifecycleObserver extends WidgetsBindingObserver {
  final Ref ref;
  DateTime? _lastRecordedActivity;

  AppLifecycleObserver(this.ref);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recordActivity();
    }
  }

  /// Record user activity (app open/resume)
  Future<void> _recordActivity() async {
    final now = DateTime.now();

    // Debounce: only record if no activity recorded in last 5 minutes
    if (_lastRecordedActivity != null) {
      final diff = now.difference(_lastRecordedActivity!);
      if (diff.inMinutes < 5) {
        return;
      }
    }

    try {
      final activityService = ref.read(dailyActivityServiceProvider);
      await activityService.recordActivity(now);
      _lastRecordedActivity = now;
      debugPrint('📊 Activity recorded at ${now.hour}:${now.minute}');
    } catch (e) {
      debugPrint('⚠️ Failed to record activity: $e');
    }
  }

  /// Call this when app first launches (before lifecycle events)
  Future<void> recordInitialActivity() async {
    await _recordActivity();
  }

  /// Record user interaction (call from UI for key interactions)
  /// This helps track actual app usage beyond just app resume events
  Future<void> recordUserInteraction() async {
    await _recordActivity();
  }
}

/// Provider for app lifecycle observer
final appLifecycleObserverProvider = Provider<AppLifecycleObserver>((ref) {
  return AppLifecycleObserver(ref);
});
