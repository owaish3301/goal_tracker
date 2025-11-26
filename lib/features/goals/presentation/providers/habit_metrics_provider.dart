import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_tracker/core/services/habit_formation_service.dart';

/// Provider to get streak status for a specific goal
final goalStreakStatusProvider = FutureProvider.family<StreakStatus, int>((
  ref,
  goalId,
) async {
  final service = ref.watch(habitFormationServiceProvider);
  return await service.getStreakStatus(goalId);
});

/// Provider to get sticky time for a specific goal
final goalStickyTimeProvider = FutureProvider.family<StickyTime?, int>((
  ref,
  goalId,
) async {
  final service = ref.watch(habitFormationServiceProvider);
  return await service.findStickyTime(goalId);
});

/// Provider to get all goals with their streak info, sorted by streak
final allGoalStreaksProvider = FutureProvider<List<GoalStreakInfo>>((ref) async {
  final service = ref.watch(habitFormationServiceProvider);
  return await service.getAllGoalStreaks();
});

/// Provider to get goals at risk of losing their streak
final goalsAtRiskProvider = FutureProvider<List<int>>((ref) async {
  final service = ref.watch(habitFormationServiceProvider);
  return await service.getGoalsAtRisk();
});

/// Combined data class for goal display with habit info
class GoalWithHabits {
  final int goalId;
  final StreakStatus streakStatus;
  final StickyTime? stickyTime;

  GoalWithHabits({
    required this.goalId,
    required this.streakStatus,
    this.stickyTime,
  });
}

/// Provider that combines goal data with habit metrics
final goalWithHabitsProvider = FutureProvider.family<GoalWithHabits, int>((
  ref,
  goalId,
) async {
  final streakStatus = await ref.watch(goalStreakStatusProvider(goalId).future);
  final stickyTime = await ref.watch(goalStickyTimeProvider(goalId).future);

  return GoalWithHabits(
    goalId: goalId,
    streakStatus: streakStatus,
    stickyTime: stickyTime,
  );
});
