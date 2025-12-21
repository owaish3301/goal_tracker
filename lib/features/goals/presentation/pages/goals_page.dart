import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/features/goals/presentation/providers/goal_provider.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/empty_goals_state.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/expandable_goal_card.dart';
import 'package:goal_tracker/features/goals/presentation/providers/habit_metrics_provider.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(activeGoalsProvider);
    final goalNotifier = ref.watch(goalNotifierProvider.notifier);

    // Show snackbar for success/error messages
    ref.listen<GoalState>(goalNotifierProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        goalNotifier.clearMessages();
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        goalNotifier.clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Goal',
            onPressed: () {
              context.push('/goals/add');
            },
          ),
        ],
      ),
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return const EmptyGoalsState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(activeGoalsProvider);
            },
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              buildDefaultDragHandles: false, // We'll use custom drag handles
              onReorder: (oldIndex, newIndex) {
                final items = List.of(goals);
                if (newIndex > oldIndex) {
                  newIndex--;
                }
                final item = items.removeAt(oldIndex);
                items.insert(newIndex, item);
                goalNotifier.reorderGoals(items);
              },
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final double elevation = Tween<double>(
                      begin: 0,
                      end: 6,
                    ).evaluate(animation);
                    return Material(
                      elevation: elevation,
                      color: Colors.transparent,
                      shadowColor: AppColors.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(32),
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final goal = goals[index];
                final streakAsync = ref.watch(
                  goalStreakStatusProvider(goal.id),
                );

                return Padding(
                  key: ValueKey(goal.id),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: streakAsync.when(
                    data: (streakStatus) => _buildGoalCard(
                      context,
                      goal: goal,
                      index: index,
                      goalNotifier: goalNotifier,
                      currentStreak: streakStatus.currentStreak,
                      isStreakAtRisk: streakStatus.isAtRisk,
                    ),
                    loading: () => _buildGoalCard(
                      context,
                      goal: goal,
                      index: index,
                      goalNotifier: goalNotifier,
                    ),
                    error: (_, __) => _buildGoalCard(
                      context,
                      goal: goal,
                      index: index,
                      goalNotifier: goalNotifier,
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Error loading goals',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(activeGoalsProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build ExpandableGoalCard with optional streak data
  Widget _buildGoalCard(
    BuildContext context, {
    required Goal goal,
    required int index,
    required GoalNotifier goalNotifier,
    int? currentStreak,
    bool isStreakAtRisk = false,
  }) {
    return ExpandableGoalCard(
      goal: goal,
      priorityIndex: index + 1,
      currentStreak: currentStreak,
      isStreakAtRisk: isStreakAtRisk,
      onTap: () {
        context.push('/goals/${goal.id}/edit');
      },
      onDelete: () {
        goalNotifier.deleteGoal(goal.id);
      },
      dragHandle: ReorderableDragStartListener(
        index: index,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.drag_handle, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
