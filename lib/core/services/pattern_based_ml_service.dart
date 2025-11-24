import 'package:isar/isar.dart';
import 'ml_predictor.dart';
import '../../data/models/productivity_data.dart';
import '../../data/repositories/productivity_data_repository.dart';

/// Pattern-based ML service using statistical analysis
/// This can be easily replaced with TFLiteMLService later
class PatternBasedMLService implements MLPredictor {
  final Isar isar;
  final ProductivityDataRepository productivityDataRepository;

  @override
  final int minDataPoints = 10; // Need at least 10 completions

  @override
  String get predictorName => 'Pattern-Based ML';

  PatternBasedMLService({
    required this.isar,
    required this.productivityDataRepository,
  });

  @override
  Future<bool> hasEnoughData(int goalId) async {
    final count = await productivityDataRepository.getDataCountForGoal(goalId);
    return count >= minDataPoints;
  }

  @override
  Future<MLPrediction?> predictProductivity({
    required int goalId,
    required int hourOfDay,
    required int dayOfWeek,
    required int duration,
  }) async {
    // Check if we have enough data
    if (!await hasEnoughData(goalId)) {
      return null;
    }

    // Get all training data for this goal
    final trainingData = await productivityDataRepository.getTrainingData(
      goalId,
    );

    if (trainingData.isEmpty) {
      return null;
    }

    // Calculate weighted score based on multiple factors
    final scores = <double>[];
    final weights = <double>[];

    // 1. Exact time slot match (hour + day)
    final exactMatches = trainingData
        .where((d) => d.hourOfDay == hourOfDay && d.dayOfWeek == dayOfWeek)
        .toList();

    if (exactMatches.isNotEmpty) {
      final avgScore = _calculateAverage(
        exactMatches.map((d) => d.productivityScore).toList(),
      );
      scores.add(avgScore);
      weights.add(3.0); // Highest weight - exact match
    }

    // 2. Same hour, any day
    final hourMatches = trainingData
        .where((d) => d.hourOfDay == hourOfDay)
        .toList();

    if (hourMatches.isNotEmpty) {
      final avgScore = _calculateAverage(
        hourMatches.map((d) => d.productivityScore).toList(),
      );
      scores.add(avgScore);
      weights.add(2.0); // Medium weight
    }

    // 3. Same day of week, any hour
    final dayMatches = trainingData
        .where((d) => d.dayOfWeek == dayOfWeek)
        .toList();

    if (dayMatches.isNotEmpty) {
      final avgScore = _calculateAverage(
        dayMatches.map((d) => d.productivityScore).toList(),
      );
      scores.add(avgScore);
      weights.add(1.5); // Lower weight
    }

    // 4. Same time slot type (morning/afternoon/evening/night)
    final timeSlotType = ProductivityData.calculateTimeSlotType(hourOfDay);
    final slotMatches = trainingData
        .where((d) => d.timeSlotType == timeSlotType)
        .toList();

    if (slotMatches.isNotEmpty) {
      final avgScore = _calculateAverage(
        slotMatches.map((d) => d.productivityScore).toList(),
      );
      scores.add(avgScore);
      weights.add(1.0); // Lowest weight
    }

    // 5. Overall average (baseline)
    final overallAvg = _calculateAverage(
      trainingData.map((d) => d.productivityScore).toList(),
    );
    scores.add(overallAvg);
    weights.add(0.5); // Very low weight

    // Calculate weighted average
    final weightedScore = _calculateWeightedAverage(scores, weights);

    // Calculate confidence based on data availability
    final confidence = _calculateConfidence(
      dataCount: trainingData.length,
      exactMatches: exactMatches.length,
      hourMatches: hourMatches.length,
    );

    // Penalize if user frequently reschedules this goal
    final rescheduleRate =
        trainingData.where((d) => d.wasRescheduled).length /
        trainingData.length;

    final adjustedScore = weightedScore * (1.0 - (rescheduleRate * 0.2));

    return MLPrediction(
      score: adjustedScore.clamp(0.0, 5.0),
      confidence: confidence,
      method: 'pattern-based',
      metadata: {
        'data_count': trainingData.length,
        'exact_matches': exactMatches.length,
        'hour_matches': hourMatches.length,
        'day_matches': dayMatches.length,
        'reschedule_rate': rescheduleRate,
        'raw_score': weightedScore,
      },
    );
  }

  /// Calculate simple average
  double _calculateAverage(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Calculate weighted average
  double _calculateWeightedAverage(List<double> scores, List<double> weights) {
    if (scores.isEmpty || weights.isEmpty) return 0.0;

    double weightedSum = 0.0;
    double totalWeight = 0.0;

    for (int i = 0; i < scores.length; i++) {
      weightedSum += scores[i] * weights[i];
      totalWeight += weights[i];
    }

    return totalWeight > 0 ? weightedSum / totalWeight : 0.0;
  }

  /// Calculate confidence score (0.0 - 1.0)
  double _calculateConfidence({
    required int dataCount,
    required int exactMatches,
    required int hourMatches,
  }) {
    // Base confidence from data count
    double confidence = (dataCount / 50).clamp(
      0.0,
      1.0,
    ); // Max at 50 data points

    // Boost if we have exact matches
    if (exactMatches > 0) {
      confidence = (confidence + 0.3).clamp(0.0, 1.0);
    }

    // Boost if we have hour matches
    if (hourMatches >= 3) {
      confidence = (confidence + 0.2).clamp(0.0, 1.0);
    }

    return confidence;
  }

  /// Get best time recommendation for a goal
  Future<Map<String, dynamic>?> getBestTimeForGoal(int goalId) async {
    if (!await hasEnoughData(goalId)) {
      return null;
    }

    final trainingData = await productivityDataRepository.getTrainingData(
      goalId,
    );

    // Group by hour and calculate average productivity
    final Map<int, List<double>> hourScores = {};

    for (final data in trainingData) {
      if (!hourScores.containsKey(data.hourOfDay)) {
        hourScores[data.hourOfDay] = [];
      }
      hourScores[data.hourOfDay]!.add(data.productivityScore);
    }

    // Find hour with highest average
    double bestScore = 0.0;
    int bestHour = 0;
    int sampleSize = 0;

    for (final entry in hourScores.entries) {
      final avg = _calculateAverage(entry.value);
      if (avg > bestScore) {
        bestScore = avg;
        bestHour = entry.key;
        sampleSize = entry.value.length;
      }
    }

    return {
      'best_hour': bestHour,
      'avg_score': bestScore,
      'sample_size': sampleSize,
      'confidence': _calculateConfidence(
        dataCount: trainingData.length,
        exactMatches: sampleSize,
        hourMatches: sampleSize,
      ),
    };
  }

  /// Get productivity heatmap (hour x day matrix)
  Future<Map<String, dynamic>> getProductivityHeatmap(int goalId) async {
    final trainingData = await productivityDataRepository.getTrainingData(
      goalId,
    );

    if (trainingData.isEmpty) {
      return {'has_data': false};
    }

    // Create 7x24 matrix (days x hours)
    final Map<String, double> heatmap = {};

    for (int day = 0; day < 7; day++) {
      for (int hour = 0; hour < 24; hour++) {
        final matches = trainingData
            .where((d) => d.dayOfWeek == day && d.hourOfDay == hour)
            .toList();

        if (matches.isNotEmpty) {
          final avg = _calculateAverage(
            matches.map((d) => d.productivityScore).toList(),
          );
          heatmap['$day-$hour'] = avg;
        }
      }
    }

    return {
      'has_data': true,
      'heatmap': heatmap,
      'total_data_points': trainingData.length,
    };
  }
}
