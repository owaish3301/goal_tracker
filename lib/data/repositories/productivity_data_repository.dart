import 'package:isar/isar.dart';
import '../models/productivity_data.dart';

class ProductivityDataRepository {
  final Isar isar;

  ProductivityDataRepository(this.isar);

  // Create
  Future<int> createProductivityData(ProductivityData data) async {
    return await isar.writeTxn(() async {
      return await isar.productivityDatas.put(data);
    });
  }

  // Read
  Future<ProductivityData?> getProductivityData(int id) async {
    return await isar.productivityDatas.get(id);
  }

  Future<List<ProductivityData>> getDataForGoal(int goalId) async {
    return await isar.productivityDatas
        .filter()
        .goalIdEqualTo(goalId)
        .sortByRecordedAtDesc()
        .findAll();
  }

  Future<List<ProductivityData>> getDataForTimeSlot({
    required int goalId,
    required int hourOfDay,
    required int dayOfWeek,
  }) async {
    return await isar.productivityDatas
        .filter()
        .goalIdEqualTo(goalId)
        .hourOfDayEqualTo(hourOfDay)
        .dayOfWeekEqualTo(dayOfWeek)
        .findAll();
  }

  Future<List<ProductivityData>> getDataForGoalAndHour({
    required int goalId,
    required int hourOfDay,
  }) async {
    return await isar.productivityDatas
        .filter()
        .goalIdEqualTo(goalId)
        .hourOfDayEqualTo(hourOfDay)
        .findAll();
  }

  Future<List<ProductivityData>> getDataForGoalAndDay({
    required int goalId,
    required int dayOfWeek,
  }) async {
    return await isar.productivityDatas
        .filter()
        .goalIdEqualTo(goalId)
        .dayOfWeekEqualTo(dayOfWeek)
        .findAll();
  }

  Future<List<ProductivityData>> getRecentData({int limit = 100}) async {
    return await isar.productivityDatas
        .where()
        .sortByRecordedAtDesc()
        .limit(limit)
        .findAll();
  }

  Future<List<ProductivityData>> getDataInDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await isar.productivityDatas
        .filter()
        .recordedAtBetween(startDate, endDate)
        .sortByRecordedAt()
        .findAll();
  }

  // Statistics
  Future<double?> getAverageProductivityForGoal(int goalId) async {
    final data = await getDataForGoal(goalId);
    if (data.isEmpty) return null;

    final sum = data.fold<double>(
      0,
      (sum, item) => sum + item.productivityScore,
    );
    return sum / data.length;
  }

  Future<double?> getAverageProductivityForTimeSlot({
    required int goalId,
    required int hourOfDay,
    required int dayOfWeek,
  }) async {
    final data = await getDataForTimeSlot(
      goalId: goalId,
      hourOfDay: hourOfDay,
      dayOfWeek: dayOfWeek,
    );

    if (data.isEmpty) return null;

    final sum = data.fold<double>(
      0,
      (sum, item) => sum + item.productivityScore,
    );
    return sum / data.length;
  }

  // Delete
  Future<bool> deleteProductivityData(int id) async {
    return await isar.writeTxn(() async {
      return await isar.productivityDatas.delete(id);
    });
  }

  Future<void> deleteDataForGoal(int goalId) async {
    final data = await getDataForGoal(goalId);
    await isar.writeTxn(() async {
      await isar.productivityDatas.deleteAll(data.map((d) => d.id).toList());
    });
  }

  // Count
  Future<int> getDataCount() async {
    return await isar.productivityDatas.count();
  }

  Future<int> getDataCountForGoal(int goalId) async {
    return await isar.productivityDatas.filter().goalIdEqualTo(goalId).count();
  }

  // === ML-SPECIFIC METHODS ===

  // Get all training data for ML model
  Future<Map<int, List<ProductivityData>>> getAllTrainingData() async {
    final allData = await isar.productivityDatas.where().findAll();

    // Group by goal ID
    final Map<int, List<ProductivityData>> grouped = {};
    for (final data in allData) {
      if (!grouped.containsKey(data.goalId)) {
        grouped[data.goalId] = [];
      }
      grouped[data.goalId]!.add(data);
    }

    return grouped;
  }

  // Get training data for a specific goal (for ML model)
  Future<List<ProductivityData>> getTrainingData(int goalId) async {
    return await isar.productivityDatas
        .filter()
        .goalIdEqualTo(goalId)
        .sortByRecordedAt()
        .findAll();
  }

  // Get rescheduled tasks data (important signal!)
  Future<List<ProductivityData>> getRescheduledData() async {
    return await isar.productivityDatas
        .filter()
        .wasRescheduledEqualTo(true)
        .findAll();
  }

  // Get completed vs skipped tasks
  Future<Map<String, int>> getCompletionStats() async {
    final allData = await isar.productivityDatas.where().findAll();

    final completed = allData.where((d) => d.wasCompleted).length;
    final skipped = allData.where((d) => !d.wasCompleted).length;

    return {
      'completed': completed,
      'skipped': skipped,
      'total': allData.length,
    };
  }

  // Get productivity by time slot
  Future<Map<int, double>> getProductivityByTimeSlot(int goalId) async {
    final data = await getDataForGoal(goalId);

    final Map<int, List<double>> slotScores = {
      0: [], // Morning
      1: [], // Afternoon
      2: [], // Evening
      3: [], // Night
    };

    for (final item in data) {
      slotScores[item.timeSlotType]!.add(item.productivityScore);
    }

    final Map<int, double> averages = {};
    for (final entry in slotScores.entries) {
      if (entry.value.isNotEmpty) {
        averages[entry.key] =
            entry.value.reduce((a, b) => a + b) / entry.value.length;
      }
    }

    return averages;
  }

  // Get productivity by day of week
  Future<Map<int, double>> getProductivityByDayOfWeek(int goalId) async {
    final data = await getDataForGoal(goalId);

    final Map<int, List<double>> dayScores = {};
    for (int i = 0; i < 7; i++) {
      dayScores[i] = [];
    }

    for (final item in data) {
      dayScores[item.dayOfWeek]!.add(item.productivityScore);
    }

    final Map<int, double> averages = {};
    for (final entry in dayScores.entries) {
      if (entry.value.isNotEmpty) {
        averages[entry.key] =
            entry.value.reduce((a, b) => a + b) / entry.value.length;
      }
    }

    return averages;
  }

  // Get best time for a goal (highest avg productivity)
  Future<Map<String, dynamic>?> getBestTimeForGoal(int goalId) async {
    final data = await getDataForGoal(goalId);
    if (data.isEmpty) return null;

    // Group by hour
    final Map<int, List<double>> hourScores = {};
    for (final item in data) {
      if (!hourScores.containsKey(item.hourOfDay)) {
        hourScores[item.hourOfDay] = [];
      }
      hourScores[item.hourOfDay]!.add(item.productivityScore);
    }

    // Find hour with highest average
    double bestScore = 0;
    int bestHour = 0;

    for (final entry in hourScores.entries) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      if (avg > bestScore) {
        bestScore = avg;
        bestHour = entry.key;
      }
    }

    return {
      'hour': bestHour,
      'score': bestScore,
      'sample_size': hourScores[bestHour]!.length,
    };
  }

  // Export data for external ML training (CSV format)
  Future<String> exportToCSV() async {
    final data = await isar.productivityDatas.where().findAll();

    final buffer = StringBuffer();
    buffer.writeln(
      'goalId,hourOfDay,dayOfWeek,duration,timeSlotType,hadPriorTask,hadFollowingTask,weekOfYear,isWeekend,productivityScore,wasRescheduled,wasCompleted,actualDurationMinutes,minutesFromScheduled',
    );

    for (final item in data) {
      buffer.writeln(
        '${item.goalId},${item.hourOfDay},${item.dayOfWeek},${item.duration},${item.timeSlotType},${item.hadPriorTask},${item.hadFollowingTask},${item.weekOfYear},${item.isWeekend},${item.productivityScore},${item.wasRescheduled},${item.wasCompleted},${item.actualDurationMinutes},${item.minutesFromScheduled}',
      );
    }

    return buffer.toString();
  }

  // Get model performance metrics
  Future<Map<String, dynamic>> getModelPerformanceMetrics() async {
    final dataWithPredictions = await isar.productivityDatas
        .filter()
        .predictedScoreIsNotNull()
        .findAll();

    if (dataWithPredictions.isEmpty) {
      return {'has_predictions': false, 'sample_size': 0};
    }

    final errors = dataWithPredictions
        .map((d) => d.predictionError ?? 0.0)
        .toList();

    final avgError = errors.reduce((a, b) => a + b) / errors.length;
    final maxError = errors.reduce((a, b) => a > b ? a : b);
    final minError = errors.reduce((a, b) => a < b ? a : b);

    return {
      'has_predictions': true,
      'sample_size': dataWithPredictions.length,
      'avg_error': avgError,
      'max_error': maxError,
      'min_error': minError,
    };
  }
}
