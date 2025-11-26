import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:goal_tracker/core/services/pattern_based_ml_service.dart';
import 'package:goal_tracker/data/models/productivity_data.dart';
import 'package:goal_tracker/data/repositories/productivity_data_repository.dart';

void main() {
  late Isar isar;
  late ProductivityDataRepository repository;
  late PatternBasedMLService mlService;

  setUpAll(() async {
    // Initialize Isar for testing
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    // Create in-memory Isar instance for each test
    isar = await Isar.open(
      [ProductivityDataSchema],
      directory: '',
      name: 'test_${DateTime.now().millisecondsSinceEpoch}',
    );

    repository = ProductivityDataRepository(isar);
    mlService = PatternBasedMLService(
      isar: isar,
      productivityDataRepository: repository,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('PatternBasedMLService', () {
    test('hasEnoughData returns false with insufficient data', () async {
      final result = await mlService.hasEnoughData(1);
      expect(result, false);
    });

    test('hasEnoughData returns true with sufficient data', () async {
      // Add 10 productivity data points in a single transaction
      await isar.writeTxn(() async {
        for (int i = 0; i < 10; i++) {
          final data = ProductivityData()
            ..goalId = 1
            ..hourOfDay = 9 + (i % 3)
            ..dayOfWeek = i % 7
            ..duration = 30
            ..productivityScore = 4.0 + (i % 2) * 0.5
            ..wasRescheduled = false
            ..wasCompleted = true
            ..actualDurationMinutes = 30
            ..minutesFromScheduled = 0
            ..scheduledTaskId = i;

          await isar.productivityDatas.put(data);
        }
      });

      final result = await mlService.hasEnoughData(1);
      expect(result, true);
    });

    test('predictProductivity returns null with insufficient data', () async {
      final prediction = await mlService.predictProductivity(
        goalId: 1,
        hourOfDay: 9,
        dayOfWeek: 1,
        duration: 30,
      );

      expect(prediction, isNull);
    });

    test(
      'predictProductivity returns prediction with sufficient data',
      () async {
        // Add training data
        for (int i = 0; i < 15; i++) {
          final data = ProductivityData()
            ..goalId = 1
            ..hourOfDay = 9
            ..dayOfWeek = 1
            ..duration = 30
            ..productivityScore = 4.0
            ..wasRescheduled = false
            ..wasCompleted = true
            ..actualDurationMinutes = 30
            ..minutesFromScheduled = 0
            ..scheduledTaskId = i;

          await repository.createProductivityData(data);
        }

        final prediction = await mlService.predictProductivity(
          goalId: 1,
          hourOfDay: 9,
          dayOfWeek: 1,
          duration: 30,
        );

        expect(prediction, isNotNull);
        expect(prediction!.score, greaterThan(0));
        expect(prediction.confidence, greaterThan(0));
        expect(prediction.method, 'pattern-based');
      },
    );

    test('getBestTimeForGoal returns null with insufficient data', () async {
      final result = await mlService.getBestTimeForGoal(1);
      expect(result, isNull);
    });

    test('getBestTimeForGoal returns best time with sufficient data', () async {
      // Add data with varying productivity scores
      for (int hour = 8; hour <= 10; hour++) {
        for (int i = 0; i < 5; i++) {
          final data = ProductivityData()
            ..goalId = 1
            ..hourOfDay = hour
            ..dayOfWeek = 1
            ..duration = 30
            ..productivityScore = hour == 9
                ? 5.0
                : 3.0 // Hour 9 is best
            ..wasRescheduled = false
            ..wasCompleted = true
            ..actualDurationMinutes = 30
            ..minutesFromScheduled = 0
            ..scheduledTaskId = hour * 10 + i;

          await repository.createProductivityData(data);
        }
      }

      final result = await mlService.getBestTimeForGoal(1);

      expect(result, isNotNull);
      expect(result!['best_hour'], 9);
      expect(result['avg_score'], 5.0);
    });

    test('getProductivityHeatmap returns empty for no data', () async {
      final result = await mlService.getProductivityHeatmap(1);

      expect(result['has_data'], false);
    });

    test('getProductivityHeatmap returns heatmap with data', () async {
      // Add some productivity data
      for (int i = 0; i < 10; i++) {
        final data = ProductivityData()
          ..goalId = 1
          ..hourOfDay = 9
          ..dayOfWeek = 1
          ..duration = 30
          ..productivityScore = 4.5
          ..wasRescheduled = false
          ..wasCompleted = true
          ..actualDurationMinutes = 30
          ..minutesFromScheduled = 0
          ..scheduledTaskId = i;

        await repository.createProductivityData(data);
      }

      final result = await mlService.getProductivityHeatmap(1);

      expect(result['has_data'], true);
      expect(result['heatmap'], isNotEmpty);
      expect(result['total_data_points'], 10);
    });
  });
}
