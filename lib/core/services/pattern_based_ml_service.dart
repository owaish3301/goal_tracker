import 'package:isar/isar.dart';
import 'ml_predictor.dart';
import 'daily_activity_service.dart';
import '../../data/models/productivity_data.dart';
import '../../data/repositories/productivity_data_repository.dart';
import '../../data/repositories/habit_metrics_repository.dart';

/// Pattern-based ML service using statistical analysis
/// This can be easily replaced with TFLiteMLService later
class PatternBasedMLService implements MLPredictor {
  final Isar isar;
  final ProductivityDataRepository productivityDataRepository;
  final DailyActivityService? dailyActivityService;
  final HabitMetricsRepository? habitMetricsRepository;

  @override
  final int minDataPoints = 10; // Need at least 10 completions

  @override
  String get predictorName => 'Pattern-Based ML';

  PatternBasedMLService({
    required this.isar,
    required this.productivityDataRepository,
    this.dailyActivityService,
    this.habitMetricsRepository,
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
    // Use contextual prediction if services are available
    return predictWithContext(
      goalId: goalId,
      hourOfDay: hourOfDay,
      dayOfWeek: dayOfWeek,
      duration: duration,
      scheduledTime: DateTime.now(),
    );
  }
  
  /// Enhanced prediction using contextual features
  /// This is the main entry point for predictions with dynamic wake/sleep handling
  Future<MLPrediction?> predictWithContext({
    required int goalId,
    required int hourOfDay,
    required int dayOfWeek,
    required int duration,
    required DateTime scheduledTime,
    int? taskOrderInDay,
    double? relativeTimeInDay,
    int? currentStreak,
    double? completionRateLast7Days,
    int? consecutiveTasksToday,
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
    
    // Get contextual data if not provided and services are available
    double effectiveRelativeTime = relativeTimeInDay ?? 0.5;
    int effectiveStreak = currentStreak ?? 0;
    double effective7DayRate = completionRateLast7Days ?? 0.0;
    int effectiveTaskOrder = taskOrderInDay ?? 1;
    
    if (dailyActivityService != null) {
      effectiveRelativeTime = relativeTimeInDay ?? 
          await dailyActivityService!.calculateRelativeTimeInDay(scheduledTime);
      
      if (completionRateLast7Days == null) {
        final context = await dailyActivityService!.getTodayContext(scheduledTime);
        effective7DayRate = context.completionRateLast7Days;
        effectiveTaskOrder = taskOrderInDay ?? context.taskOrderInDay;
      }
    }
    
    if (habitMetricsRepository != null && currentStreak == null) {
      final metrics = await habitMetricsRepository!.getMetricsForGoal(goalId);
      effectiveStreak = metrics?.currentStreak ?? 0;
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

    double adjustedScore = weightedScore * (1.0 - (rescheduleRate * 0.2));
    
    // === Phase 8: Contextual Adjustments ===
    
    // Get context score adjustment
    final contextAdjustment = _getContextScoreAdjustment(
      trainingData: trainingData,
      relativeTimeInDay: effectiveRelativeTime,
      currentStreak: effectiveStreak,
      completionRateLast7Days: effective7DayRate,
      taskOrderInDay: effectiveTaskOrder,
    );
    
    // Apply contextual adjustment (max ±15% adjustment)
    adjustedScore = adjustedScore * (1.0 + contextAdjustment);

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
        'context_adjustment': contextAdjustment,
        'relative_time': effectiveRelativeTime,
        'streak': effectiveStreak,
        'completion_rate_7d': effective7DayRate,
        'task_order': effectiveTaskOrder,
      },
    );
  }
  
  /// Calculate contextual score adjustment based on Phase 8 features
  /// Returns a value between -0.15 and +0.15 (±15% adjustment)
  double _getContextScoreAdjustment({
    required List<ProductivityData> trainingData,
    required double relativeTimeInDay,
    required int currentStreak,
    required double completionRateLast7Days,
    required int taskOrderInDay,
  }) {
    double adjustment = 0.0;
    
    // 1. Streak momentum boost (up to +5%)
    // Users with longer streaks tend to maintain performance
    if (currentStreak > 0) {
      final streakFactor = (currentStreak / 21.0).clamp(0.0, 1.0); // Max at 21 days (habit locked)
      adjustment += streakFactor * 0.05;
    }
    
    // 2. Recent momentum boost (up to +5%)
    // High 7-day completion rate suggests good momentum
    if (completionRateLast7Days > 0.7) {
      adjustment += (completionRateLast7Days - 0.7) * 0.15; // 0.7-1.0 maps to 0-0.045
    } else if (completionRateLast7Days < 0.3) {
      // Low completion rate suggests struggles
      adjustment -= 0.03;
    }
    
    // 3. Task order effect
    // Learn from historical data: does productivity change by task order?
    adjustment += _getTaskOrderAdjustment(trainingData, taskOrderInDay);
    
    // 4. Relative time in day effect
    // Learn if user performs differently at different parts of their day
    adjustment += _getRelativeTimeAdjustment(trainingData, relativeTimeInDay);
    
    // Clamp total adjustment to ±15%
    return adjustment.clamp(-0.15, 0.15);
  }
  
  /// Calculate adjustment based on historical task order patterns
  double _getTaskOrderAdjustment(List<ProductivityData> trainingData, int taskOrderInDay) {
    // Filter training data that has task order info
    final dataWithOrder = trainingData.where((d) => d.taskOrderInDay > 0).toList();
    if (dataWithOrder.isEmpty) return 0.0;
    
    // Group by task order and calculate averages
    final Map<int, List<double>> orderScores = {};
    for (final data in dataWithOrder) {
      orderScores.putIfAbsent(data.taskOrderInDay, () => []).add(data.productivityScore);
    }
    
    // Get average for target order
    final targetScores = orderScores[taskOrderInDay];
    if (targetScores == null || targetScores.isEmpty) return 0.0;
    
    final targetAvg = _calculateAverage(targetScores);
    final overallAvg = _calculateAverage(dataWithOrder.map((d) => d.productivityScore).toList());
    
    // Calculate relative difference (capped at ±5%)
    if (overallAvg > 0) {
      return ((targetAvg - overallAvg) / overallAvg).clamp(-0.05, 0.05);
    }
    return 0.0;
  }
  
  /// Calculate adjustment based on relative time in user's day
  double _getRelativeTimeAdjustment(List<ProductivityData> trainingData, double relativeTimeInDay) {
    // Filter training data that has relative time info
    final dataWithTime = trainingData.where((d) => d.relativeTimeInDay > 0).toList();
    if (dataWithTime.isEmpty) return 0.0;
    
    // Define time buckets: early (0-0.25), mid-morning (0.25-0.5), afternoon (0.5-0.75), evening (0.75-1.0)
    int getBucket(double time) {
      if (time < 0.25) return 0;
      if (time < 0.5) return 1;
      if (time < 0.75) return 2;
      return 3;
    }
    
    final targetBucket = getBucket(relativeTimeInDay);
    
    // Group by bucket and calculate averages
    final Map<int, List<double>> bucketScores = {};
    for (final data in dataWithTime) {
      final bucket = getBucket(data.relativeTimeInDay);
      bucketScores.putIfAbsent(bucket, () => []).add(data.productivityScore);
    }
    
    // Get average for target bucket
    final targetScores = bucketScores[targetBucket];
    if (targetScores == null || targetScores.isEmpty) return 0.0;
    
    final targetAvg = _calculateAverage(targetScores);
    final overallAvg = _calculateAverage(dataWithTime.map((d) => d.productivityScore).toList());
    
    // Calculate relative difference (capped at ±5%)
    if (overallAvg > 0) {
      return ((targetAvg - overallAvg) / overallAvg).clamp(-0.05, 0.05);
    }
    return 0.0;
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
