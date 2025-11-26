import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/repositories/goal_repository.dart';
import 'package:goal_tracker/core/services/database_service.dart';

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

  Future<void> createGoal(Goal goal) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.createGoal(goal);
      _invalidateGoalProviders();
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Goal created successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create goal: $e',
      );
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
      await _repository.deleteGoal(id);
      _invalidateGoalProviders();
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
