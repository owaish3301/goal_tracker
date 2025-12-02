import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/timeline/presentation/pages/timeline_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/goals/presentation/pages/add_edit_goal_page.dart';
import '../../features/one_time_tasks/presentation/pages/add_edit_one_time_task_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../../features/shell/presentation/pages/main_shell.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';

// Navigation keys for each branch
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) async {
      // Check if going to onboarding
      final isOnboarding = state.matchedLocation == '/onboarding';
      
      // Check onboarding completion status
      final isCompleted = await ref.read(isOnboardingCompletedProvider.future);
      
      // If onboarding is not completed and not on onboarding page, redirect to onboarding
      if (!isCompleted && !isOnboarding) {
        return '/onboarding';
      }
      
      // If onboarding is completed and on onboarding page, redirect to home
      if (isCompleted && isOnboarding) {
        return '/';
      }
      
      return null; // No redirect needed
    },
    routes: [
      // Onboarding (outside shell)
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Main app with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Today/Timeline
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const TimelinePage(),
              ),
            ],
          ),
          
          // Branch 1: Calendar
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarPage(),
              ),
            ],
          ),
          
          // Branch 2: Analytics
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsPage(),
              ),
            ],
          ),
          
          // Branch 3: Goals
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/goals',
                builder: (context, state) => const GoalsPage(),
              ),
            ],
          ),
        ],
      ),
      
      // Routes outside the shell (full screen)
      GoRoute(
        path: '/goals/add',
        builder: (context, state) => const AddEditGoalPage(),
      ),
      GoRoute(
        path: '/goals/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AddEditGoalPage(goalId: id);
        },
      ),

      // One-time tasks
      GoRoute(
        path: '/events/add',
        builder: (context, state) {
          final dateStr = state.uri.queryParameters['date'];
          final initialDate = dateStr != null
              ? DateTime.tryParse(dateStr)
              : null;
          return AddEditOneTimeTaskPage(initialDate: initialDate);
        },
      ),
      GoRoute(
        path: '/events/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AddEditOneTimeTaskPage(taskId: id);
        },
      ),
    ],
  );
});
