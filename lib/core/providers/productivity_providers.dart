import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';
import '../services/productivity_data_collector.dart';

/// Provider for the productivity data collector
final productivityDataCollectorProvider = Provider<ProductivityDataCollector>((
  ref,
) {
  final isar = ref.watch(isarProvider);
  final scheduledTaskRepo = ref.watch(scheduledTaskRepositoryProvider);
  final productivityDataRepo = ref.watch(productivityDataRepositoryProvider);

  return ProductivityDataCollector(
    isar: isar,
    scheduledTaskRepository: scheduledTaskRepo,
    productivityDataRepository: productivityDataRepo,
  );
});

/// Provider to get productivity stats for a goal
final productivityStatsProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, goalId) async {
      final collector = ref.watch(productivityDataCollectorProvider);
      return await collector.getProductivityStats(goalId);
    });
