import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';
import '../services/rule_based_scheduler.dart';
import '../services/pattern_based_ml_service.dart';
import '../services/hybrid_scheduler.dart';
import '../services/profile_based_scheduler.dart';
import '../services/dynamic_time_window_service.dart';
import '../services/habit_formation_service.dart';
import 'productivity_providers.dart';

/// Provider for the rule-based scheduler
final ruleBasedSchedulerProvider = Provider<RuleBasedScheduler>((ref) {
  final isar = ref.watch(isarProvider);
  final goalRepo = ref.watch(goalRepositoryProvider);
  final oneTimeTaskRepo = ref.watch(oneTimeTaskRepositoryProvider);
  final scheduledTaskRepo = ref.watch(scheduledTaskRepositoryProvider);
  final dailyActivityService = ref.watch(dailyActivityServiceProvider);

  return RuleBasedScheduler(
    isar: isar,
    goalRepository: goalRepo,
    oneTimeTaskRepository: oneTimeTaskRepo,
    scheduledTaskRepository: scheduledTaskRepo,
    dailyActivityService: dailyActivityService,
  );
});

/// Provider for the pattern-based ML service
final patternBasedMLServiceProvider = Provider<PatternBasedMLService>((ref) {
  final isar = ref.watch(isarProvider);
  final productivityDataRepo = ref.watch(productivityDataRepositoryProvider);
  final dailyActivityService = ref.watch(dailyActivityServiceProvider);
  final habitMetricsRepo = ref.watch(habitMetricsRepositoryProvider);

  return PatternBasedMLService(
    isar: isar,
    productivityDataRepository: productivityDataRepo,
    dailyActivityService: dailyActivityService,
    habitMetricsRepository: habitMetricsRepo,
  );
});

/// Provider for the profile-based scheduler (Tier 2)
final profileBasedSchedulerProvider = Provider<ProfileBasedScheduler>((ref) {
  final profileRepo = ref.watch(userProfileRepositoryProvider);
  return ProfileBasedScheduler(profileRepo);
});

/// Provider for the dynamic time window service
final dynamicTimeWindowServiceProvider = Provider<DynamicTimeWindowService>((
  ref,
) {
  final activityRepo = ref.watch(dailyActivityLogRepositoryProvider);
  final productivityRepo = ref.watch(productivityDataRepositoryProvider);
  final profileRepo = ref.watch(userProfileRepositoryProvider);
  final activityService = ref.watch(dailyActivityServiceProvider);

  return DynamicTimeWindowService(
    activityRepo: activityRepo,
    productivityRepo: productivityRepo,
    profileRepo: profileRepo,
    activityService: activityService,
  );
});

/// Provider for the hybrid scheduler v2 (ML + Profile + Rules + Habit Overlay)
final hybridSchedulerProvider = Provider<HybridScheduler>((ref) {
  final isar = ref.watch(isarProvider);
  final goalRepo = ref.watch(goalRepositoryProvider);
  final oneTimeTaskRepo = ref.watch(oneTimeTaskRepositoryProvider);
  final scheduledTaskRepo = ref.watch(scheduledTaskRepositoryProvider);
  final ruleBasedScheduler = ref.watch(ruleBasedSchedulerProvider);
  final mlPredictor = ref.watch(patternBasedMLServiceProvider);
  final profileBasedScheduler = ref.watch(profileBasedSchedulerProvider);
  final dynamicTimeWindowService = ref.watch(dynamicTimeWindowServiceProvider);
  final habitMetricsRepo = ref.watch(habitMetricsRepositoryProvider);
  final userProfileRepo = ref.watch(userProfileRepositoryProvider);
  final habitFormationService = ref.watch(habitFormationServiceProvider);

  return HybridScheduler(
    isar: isar,
    goalRepository: goalRepo,
    oneTimeTaskRepository: oneTimeTaskRepo,
    scheduledTaskRepository: scheduledTaskRepo,
    ruleBasedScheduler: ruleBasedScheduler,
    mlPredictor: mlPredictor,
    profileBasedScheduler: profileBasedScheduler,
    dynamicTimeWindowService: dynamicTimeWindowService,
    habitMetricsRepository: habitMetricsRepo,
    userProfileRepository: userProfileRepo,
    habitFormationService: habitFormationService,
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
