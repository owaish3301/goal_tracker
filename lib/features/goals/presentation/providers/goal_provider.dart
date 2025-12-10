import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/repositories/goal_repository.dart';
import 'package:goal_tracker/core/services/database_service.dart';
import 'package:goal_tracker/features/scheduled_tasks/presentation/providers/scheduled_task_providers.dart';
import 'package:goal_tracker/features/timeline/presentation/providers/timeline_providers.dart';

// Goals list provider - fetches all goals sorted by priority
// Uses FutureProvider instead of polling StreamProvider for better performance
final goalsProvider = FutureProvider<List<Goal>>((ref) async {
  final repository = ref.watch(goalRepositoryProvider);
  return await repository.getGoalsByPriority();
});

// Active goals only provider
// Invalidate this provider after CRUD operations via GoalNotifier
final activeGoalsProvider = FutureProvider<List<Goal>>((ref) async {
  final repository = ref.watch(goalRepositoryProvider);
  return await repository.getActiveGoals();
});

// Goal CRUD state
class GoalState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const GoalState({this.isLoading = false, this.error, this.successMessage});

  GoalState copyWith({bool? isLoading, String? error, String? successMessage}) {
    return GoalState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

// Goal notifier for CRUD operations
class GoalNotifier extends StateNotifier<GoalState> {
  final GoalRepository _repository;
  final Ref _ref;

  GoalNotifier(this._repository, this._ref) : super(const GoalState());

  void _invalidateGoalProviders() {
    _ref.invalidate(goalsProvider);
    _ref.invalidate(activeGoalsProvider);
  }

  Future<int?> createGoal(Goal goal) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final goalId = await _repository.createGoal(goal);
      _invalidateGoalProviders();
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Goal created successfully',
      );
      return goalId;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create goal: $e',
      );
      return null;
    }
  }

  Future<void> updateGoal(Goal goal) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateGoal(goal);
      _invalidateGoalProviders();
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Goal updated successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update goal: $e',
      );
    }
  }

  Future<void> deleteGoal(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // First delete all scheduled tasks for this goal
      final scheduledTaskRepo = _ref.read(scheduledTaskRepositoryProvider);
      await scheduledTaskRepo.deleteScheduledTasksByGoal(id);

      // Then delete the goal itself
      await _repository.deleteGoal(id);

      // Invalidate all related providers
      _invalidateGoalProviders();
      _invalidateTimelineProviders();

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Goal deleted successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete goal: $e',
      );
    }
  }

  /// Invalidate timeline providers to refresh UI after goal changes
  void _invalidateTimelineProviders() {
    // Invalidate the last 7 days and next 7 days of timeline data
    final now = DateTime.now();
    for (int i = -7; i <= 7; i++) {
      final date = DateTime(now.year, now.month, now.day + i);
      _ref.invalidate(scheduledTasksForDateProvider(date));
      _ref.invalidate(unifiedTimelineProvider(date));
    }
  }

  Future<void> reorderGoals(List<Goal> goals) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updatePriorityIndexes(goals);
      _invalidateGoalProviders();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to reorder goals: $e',
      );
    }
  }

  Future<void> toggleGoalActive(int id, bool isActive) async {
    try {
      await _repository.toggleGoalActive(id, isActive);
      _invalidateGoalProviders();
    } catch (e) {
      state = state.copyWith(error: 'Failed to toggle goal: $e');
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

// Goal notifier provider
final goalNotifierProvider = StateNotifierProvider<GoalNotifier, GoalState>((
  ref,
) {
  final repository = ref.watch(goalRepositoryProvider);
  return GoalNotifier(repository, ref);
});
