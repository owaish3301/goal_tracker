import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:goal_tracker/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:goal_tracker/core/services/database_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize database before tests
    await DatabaseService.initialize();
  });

  group('Goal Tracker Integration Tests', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify app launched
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Can navigate to goals page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for navigation elements or goals page indicators
      // This is a basic test - expand based on your actual UI
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
