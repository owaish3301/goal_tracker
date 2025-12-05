import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/data/repositories/milestone_repository.dart';
import 'package:goal_tracker/core/services/database_service.dart';

// Milestone repository provider

// Get all milestones for a specific goal
final milestonesForGoalProvider = FutureProvider.family<List<Milestone>, int>((ref, goalId) async {
  final repository = ref.watch(milestoneRepositoryProvider);
  return await repository.getMilestonesForGoal(goalId);
});

// Get first incomplete milestone for a goal
final firstIncompleteMilestoneProvider = FutureProvider.family<Milestone?, int>((ref, goalId) async {
  final repository = ref.watch(milestoneRepositoryProvider);
  final milestones = await repository.getPendingMilestones(goalId);
  return milestones.isEmpty ? null : milestones.first;
});

// Get completed milestones count for a goal
final completedMilestoneCountProvider = FutureProvider.family<int, int>((ref, goalId) async {
  final repository = ref.watch(milestoneRepositoryProvider);
  return await repository.getCompletedMilestoneCount(goalId);
});

// Milestone CRUD state
class MilestoneState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const MilestoneState({this.isLoading = false, this.error, this.successMessage});

  MilestoneState copyWith({bool? isLoading, String? error, String? successMessage}) {
    return MilestoneState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

// Milestone notifier for CRUD operations
class MilestoneNotifier extends StateNotifier<MilestoneState> {
  final MilestoneRepository _repository;
  final Ref _ref;

  MilestoneNotifier(this._repository, this._ref) : super(const MilestoneState());

  void _invalidateMilestoneProviders(int goalId) {
    _ref.invalidate(milestonesForGoalProvider(goalId));
    _ref.invalidate(firstIncompleteMilestoneProvider(goalId));
    _ref.invalidate(completedMilestoneCountProvider(goalId));
  }

  Future<void> createMilestone(Milestone milestone, int goalId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.createMilestone(milestone, goalId);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Milestone added',
      );
      _invalidateMilestoneProviders(goalId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleMilestoneCompletion(int milestoneId, int goalId, bool isCompleted) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      if (isCompleted) {
        await _repository.markAsCompleted(milestoneId);
      } else {
        await _repository.markAsIncomplete(milestoneId);
      }
      state = state.copyWith(
        isLoading: false,
        successMessage: isCompleted ? 'Milestone completed! 🎉' : 'Milestone marked incomplete',
      );
      _invalidateMilestoneProviders(goalId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateMilestone(Milestone milestone, int goalId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateMilestone(milestone);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Milestone updated',
      );
      _invalidateMilestoneProviders(goalId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteMilestone(int milestoneId, int goalId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteMilestone(milestoneId);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Milestone deleted',
      );
      _invalidateMilestoneProviders(goalId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> reorderMilestones(List<Milestone> milestones, int goalId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.reorderMilestones(milestones);
      state = state.copyWith(isLoading: false);
      _invalidateMilestoneProviders(goalId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

// Milestone notifier provider
final milestoneNotifierProvider = StateNotifierProvider<MilestoneNotifier, MilestoneState>((ref) {
  final repository = ref.watch(milestoneRepositoryProvider);
  return MilestoneNotifier(repository, ref);
});
