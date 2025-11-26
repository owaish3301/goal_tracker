import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';
import '../services/productivity_data_collector.dart';
import '../services/habit_formation_service.dart';
import '../services/daily_activity_service.dart';

/// Provider for the DailyActivityService
final dailyActivityServiceProvider = Provider<DailyActivityService>((ref) {
  final dailyActivityLogRepo = ref.watch(dailyActivityLogRepositoryProvider);
  final userProfileRepo = ref.watch(userProfileRepositoryProvider);
  
  return DailyActivityService(dailyActivityLogRepo, userProfileRepo);
});

/// Provider for the productivity data collector
final productivityDataCollectorProvider = Provider<ProductivityDataCollector>((
  ref,
) {
  final isar = ref.watch(isarProvider);
  final scheduledTaskRepo = ref.watch(scheduledTaskRepositoryProvider);
  final productivityDataRepo = ref.watch(productivityDataRepositoryProvider);
  final habitFormationService = ref.watch(habitFormationServiceProvider);
  final dailyActivityService = ref.watch(dailyActivityServiceProvider);
  final habitMetricsRepo = ref.watch(habitMetricsRepositoryProvider);

  return ProductivityDataCollector(
    isar: isar,
    scheduledTaskRepository: scheduledTaskRepo,
    productivityDataRepository: productivityDataRepo,
    habitFormationService: habitFormationService,
    dailyActivityService: dailyActivityService,
    habitMetricsRepository: habitMetricsRepo,
  );
});

/// Provider to get productivity stats for a goal
final productivityStatsProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, goalId) async {
      final collector = ref.watch(productivityDataCollectorProvider);
      return await collector.getProductivityStats(goalId);
    });
