import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/streak_badge.dart';

void main() {
  group('StreakBadge', () {
    Widget buildWidget({
      required int streak,
      bool isAtRisk = false,
      bool showLabel = true,
      double size = 24.0,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: StreakBadge(
            streak: streak,
            isAtRisk: isAtRisk,
            showLabel: showLabel,
            size: size,
          ),
        ),
      );
    }

    testWidgets('renders nothing when streak is 0', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 0));

      expect(find.byType(StreakBadge), findsOneWidget);
      expect(find.byType(Container), findsNothing);
    });

    testWidgets('renders nothing when streak is negative', (tester) async {
      await tester.pumpWidget(buildWidget(streak: -5));

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('shows streak count', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 7));

      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('shows "day" label for streak of 1', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 1, showLabel: true));

      expect(find.text('day'), findsOneWidget);
    });

    testWidgets('shows "days" label for streak > 1', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 5, showLabel: true));

      expect(find.text('days'), findsOneWidget);
    });

    testWidgets('hides label when showLabel is false', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 5, showLabel: false));

      expect(find.text('days'), findsNothing);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('shows fire emoji for regular streaks', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 5));

      expect(find.text('🔥'), findsOneWidget);
    });

    testWidgets('shows lock emoji for habit-locked streaks (21+)', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 21));

      expect(find.text('🔒'), findsOneWidget);
    });

    testWidgets('shows star emoji for 50+ streaks', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 50));

      expect(find.text('⭐'), findsOneWidget);
    });

    testWidgets('shows trophy emoji for 100+ streaks', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 100));

      expect(find.text('🏆'), findsOneWidget);
    });
  });

  group('MiniStreakBadge', () {
    Widget buildWidget({
      required int streak,
      bool isAtRisk = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: MiniStreakBadge(
            streak: streak,
            isAtRisk: isAtRisk,
          ),
        ),
      );
    }

    testWidgets('renders nothing when streak is 0', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 0));

      expect(find.text('🔥'), findsNothing);
    });

    testWidgets('shows compact streak info', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 7));

      expect(find.text('🔥'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('shows lock emoji for 21+ streak', (tester) async {
      await tester.pumpWidget(buildWidget(streak: 25));

      expect(find.text('🔒'), findsOneWidget);
    });
  });

  group('StreakDisplay', () {
    Widget buildWidget({
      required int currentStreak,
      required int longestStreak,
      bool isAtRisk = false,
      String habitStage = 'Starting',
    }) {
      return MaterialApp(
        home: Scaffold(
          body: StreakDisplay(
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            isAtRisk: isAtRisk,
            habitStage: habitStage,
          ),
        ),
      );
    }

    testWidgets('shows current and longest streak', (tester) async {
      await tester.pumpWidget(buildWidget(
        currentStreak: 7,
        longestStreak: 15,
      ));

      expect(find.text('7'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('Current'), findsOneWidget);
      expect(find.text('Longest'), findsOneWidget);
    });

    testWidgets('shows at risk warning when isAtRisk is true', (tester) async {
      await tester.pumpWidget(buildWidget(
        currentStreak: 7,
        longestStreak: 15,
        isAtRisk: true,
      ));

      expect(find.text('⚠️'), findsOneWidget);
      expect(find.textContaining('Complete today'), findsOneWidget);
    });

    testWidgets('hides at risk warning when isAtRisk is false', (tester) async {
      await tester.pumpWidget(buildWidget(
        currentStreak: 7,
        longestStreak: 15,
        isAtRisk: false,
      ));

      expect(find.text('⚠️'), findsNothing);
    });

    testWidgets('shows habit stage', (tester) async {
      await tester.pumpWidget(buildWidget(
        currentStreak: 7,
        longestStreak: 15,
        habitStage: 'Almost There',
      ));

      expect(find.text('Almost There'), findsOneWidget);
    });

    testWidgets('shows progress bar for habit lock', (tester) async {
      await tester.pumpWidget(buildWidget(
        currentStreak: 10,
        longestStreak: 15,
      ));

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
