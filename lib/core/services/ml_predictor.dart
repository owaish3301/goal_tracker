/// Abstract interface for ML prediction
/// This allows easy swapping between different ML implementations
/// (e.g., PatternBasedMLService now, TFLiteMLService later)
abstract class MLPredictor {
  /// Predict productivity score for a goal at a specific time
  /// Returns a score between 0.0 and 5.0
  /// Returns null if insufficient data
  Future<MLPrediction?> predictProductivity({
    required int goalId,
    required int hourOfDay,
    required int dayOfWeek,
    required int duration,
  });

  /// Check if there's enough data to make predictions for a goal
  Future<bool> hasEnoughData(int goalId);

  /// Get the minimum number of data points required
  int get minDataPoints;

  /// Get the name of this predictor (for logging/debugging)
  String get predictorName;
}

/// Represents a productivity prediction
class MLPrediction {
  final double score; // 0.0 - 5.0
  final double confidence; // 0.0 - 1.0
  final String method; // 'pattern-based', 'tflite', etc.
  final Map<String, dynamic>? metadata; // Additional info

  MLPrediction({
    required this.score,
    required this.confidence,
    required this.method,
    this.metadata,
  });

  @override
  String toString() =>
      'MLPrediction(score: ${score.toStringAsFixed(2)}, confidence: ${confidence.toStringAsFixed(2)}, method: $method)';
}
