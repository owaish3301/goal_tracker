import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';
import '../services/rule_based_scheduler.dart';
import '../services/pattern_based_ml_service.dart';
import '../services/hybrid_scheduler.dart';

/// Provider for the rule-based scheduler
final ruleBasedSchedulerProvider = Provider<RuleBasedScheduler>((ref) {
  final isar = ref.watch(isarProvider);
  final goalRepo = ref.watch(goalRepositoryProvider);
  final oneTimeTaskRepo = ref.watch(oneTimeTaskRepositoryProvider);
  final scheduledTaskRepo = ref.watch(scheduledTaskRepositoryProvider);

  return RuleBasedScheduler(
    isar: isar,
    goalRepository: goalRepo,
    oneTimeTaskRepository: oneTimeTaskRepo,
    scheduledTaskRepository: scheduledTaskRepo,
  );
});

/// Provider for the pattern-based ML service
final patternBasedMLServiceProvider = Provider<PatternBasedMLService>((ref) {
  final isar = ref.watch(isarProvider);
  final productivityDataRepo = ref.watch(productivityDataRepositoryProvider);

  return PatternBasedMLService(
    isar: isar,
    productivityDataRepository: productivityDataRepo,
  );
});

/// Provider for the hybrid scheduler (ML + Rules)
final hybridSchedulerProvider = Provider<HybridScheduler>((ref) {
  final isar = ref.watch(isarProvider);
  final goalRepo = ref.watch(goalRepositoryProvider);
  final oneTimeTaskRepo = ref.watch(oneTimeTaskRepositoryProvider);
  final scheduledTaskRepo = ref.watch(scheduledTaskRepositoryProvider);
  final ruleBasedScheduler = ref.watch(ruleBasedSchedulerProvider);
  final mlPredictor = ref.watch(patternBasedMLServiceProvider);

  return HybridScheduler(
    isar: isar,
    goalRepository: goalRepo,
    oneTimeTaskRepository: oneTimeTaskRepo,
    scheduledTaskRepository: scheduledTaskRepo,
    ruleBasedScheduler: ruleBasedScheduler,
    mlPredictor: mlPredictor,
  );
});

/// Provider to generate schedule for a specific date
final scheduleForDateProvider = FutureProvider.family<List<dynamic>, DateTime>((
  ref,
  date,
) async {
  final scheduler = ref.watch(ruleBasedSchedulerProvider);
  return await scheduler.scheduleForDate(date);
});

/// Provider for scheduling statistics
final schedulingStatsProvider =
    FutureProvider.family<Map<String, dynamic>, DateTime>((ref, date) async {
      final scheduler = ref.watch(ruleBasedSchedulerProvider);
      return await scheduler.getSchedulingStats(date);
    });

/// Provider to generate schedule for a specific date using hybrid scheduler
final hybridScheduleForDateProvider =
    FutureProvider.family<List<dynamic>, DateTime>((ref, date) async {
      final scheduler = ref.watch(hybridSchedulerProvider);
      return await scheduler.scheduleForDate(date);
    });

/// Provider for scheduling statistics with ML insights
final hybridSchedulingStatsProvider =
    FutureProvider.family<Map<String, dynamic>, DateTime>((ref, date) async {
      final scheduler = ref.watch(hybridSchedulerProvider);
      return await scheduler.getSchedulingStats(date);
    });
