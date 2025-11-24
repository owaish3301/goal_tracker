import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/repositories/goal_repository.dart';
import 'package:goal_tracker/core/services/database_service.dart';

// Goals list provider - streams all goals sorted by priority
final goalsProvider = StreamProvider<List<Goal>>((ref) async* {
  final repository = ref.watch(goalRepositoryProvider);

  // Initial load
  yield await repository.getGoalsByPriority();

  // Watch for changes (polling every second for now)
  // In a real app, you'd use Isar's watch() feature
  await for (final _ in Stream.periodic(const Duration(seconds: 1))) {
    yield await repository.getGoalsByPriority();
  }
});

// Active goals only provider
final activeGoalsProvider = StreamProvider<List<Goal>>((ref) async* {
  final repository = ref.watch(goalRepositoryProvider);

  yield await repository.getActiveGoals();

  await for (final _ in Stream.periodic(const Duration(seconds: 1))) {
    yield await repository.getActiveGoals();
  }
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

  GoalNotifier(this._repository) : super(const GoalState());

  Future<void> createGoal(Goal goal) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.createGoal(goal);
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
  return GoalNotifier(repository);
});
