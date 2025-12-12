import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../data/models/daily_activity_log.dart';

/// EMERGENCY SCRIPT: Clear all corrupted activity logs
///
/// This script should be run ONCE to fix the database after the sleep calculation bug.
/// The bug caused incorrect sleep/wake time averaging, which corrupted the learned patterns.
///
/// Running this script will:
/// 1. Delete all existing daily activity logs
/// 2. Force the system to start fresh learning from correct activity tracking
/// 3. Restore scheduling to use profile baseline until new patterns are learned
///
/// After running this, the app will:
/// - Use your profile sleep schedule (from onboarding) immediately
/// - Start recording activity correctly via AppLifecycleObserver
/// - Re-learn your actual wake/sleep patterns over the next 7-14 days
/// - Gradually shift from profile to learned patterns as data accumulates
///
/// HOW TO RUN:
/// Add this to main.dart after DatabaseService.initialize():
/// ```dart
/// final isar = await DatabaseService.getIsarInstance();
/// await clearCorruptedActivityData(isar);
/// ```

Future<void> clearCorruptedActivityData(Isar isar) async {
  try {
    final count = await isar.dailyActivityLogs.count();
    debugPrint('📊 Found $count activity logs to delete');

    if (count == 0) {
      debugPrint('✅ No activity logs to clear');
      return;
    }

    await isar.writeTxn(() async {
      await isar.dailyActivityLogs.clear();
    });

    debugPrint('✅ Successfully cleared all activity logs');
    debugPrint(
      '📅 System will now use your profile schedule and re-learn patterns',
    );
  } catch (e) {
    debugPrint('❌ ERROR clearing activity data: $e');
  }
}
