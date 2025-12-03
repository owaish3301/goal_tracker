import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/scheduler_providers.dart';
import '../../../../core/services/database_service.dart';
import '../../../../data/models/goal.dart';
import '../providers/timeline_providers.dart';
import '../widgets/unified_timeline_card.dart';
import '../../../one_time_tasks/presentation/providers/one_time_task_provider.dart';
import '../../../scheduled_tasks/presentation/providers/scheduled_task_providers.dart';
import '../../../goals/presentation/providers/goal_provider.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Normalize date to midnight immediately
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);

    // Trigger auto-generation on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Re-calculate today in case midnight passed during app startup
      final currentNow = DateTime.now();
      final currentToday = DateTime(currentNow.year, currentNow.month, currentNow.day);
      
      // If selectedDate is now in the past (midnight crossed), update it
      if (selectedDate.isBefore(currentToday)) {
        setState(() {
          selectedDate = currentToday;
        });
      }
      
      _generateScheduleIfNeeded(selectedDate);
    });
  }

  /// Generate schedule only for TODAY (not future dates)
  /// Future dates show previews only, schedule is generated at midnight
  Future<void> _generateScheduleIfNeeded(DateTime date) async {
    try {
      final normalized = DateTime(date.year, date.month, date.day);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Only generate schedules for today or past dates, NOT future dates
      // Future dates will show goal previews instead
      if (normalized.isAfter(today)) {
        return;
      }

      // Check if schedule exists
      final repo = ref.read(scheduledTaskRepositoryProvider);
      final existing = await repo.getScheduledTasksForDate(normalized);

      if (existing.isEmpty) {
        // Generate new schedule
        final hybridScheduler = ref.read(hybridSchedulerProvider);
        final newTasks = await hybridScheduler.scheduleForDate(normalized);

        // Save to database, checking for duplicates before each save
        // This handles race conditions where multiple callers try to generate simultaneously
        for (final task in newTasks) {
          final existingForGoal = await repo.getTaskForGoalOnDate(task.goalId, normalized);
          if (existingForGoal == null) {
            await repo.createScheduledTask(task, allowDuplicates: false);
          }
        }

        // Refresh UI
        ref.invalidate(scheduledTasksForDateProvider(normalized));
        ref.invalidate(unifiedTimelineProvider(normalized));
      }
    } catch (e) {
      debugPrint('Error generating schedule: $e');
    }
  }

  /// Smart incremental update for goal changes
  /// - Preserves rescheduled tasks
  /// - Only adds tasks for NEW goals
  /// - Doesn't touch existing scheduled tasks
  /// - Only updates today or past dates (not future dates - they show previews)
  Future<void> _incrementalUpdateForDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Skip future dates - they show goal previews, not scheduled tasks
    if (normalized.isAfter(today)) {
      // Just refresh the preview
      ref.invalidate(unifiedTimelineProvider(normalized));
      return;
    }

    final repo = ref.read(scheduledTaskRepositoryProvider);
    final hybridScheduler = ref.read(hybridSchedulerProvider);

    // Get existing tasks for this date
    final existingTasks = await repo.getScheduledTasksForDate(normalized);
    final existingGoalIds = existingTasks.map((t) => t.goalId).toSet();

    // Get goals that should be scheduled for this date
    final goals = await ref.read(goalRepositoryProvider).getGoalsByPriority();
    final dayOfWeek = normalized.weekday; // 1=Monday, 7=Sunday

    // Filter goals active on this day and created before/on this date
    // Note: frequency uses 0=Monday, 7=Sunday; weekday uses 1=Monday, 7=Sunday
    // Wait, frequency usually uses 0-6. Let's check rule_based_scheduler.dart.
    // In rule_based_scheduler: final dayOfWeek = date.weekday - 1;
    // Here: final dayOfWeek = normalized.weekday;
    // And frequencyIndex = dayOfWeek - 1;
    // So it matches.

    final frequencyIndex =
        dayOfWeek - 1; // Convert weekday (1-7) to frequency index (0-6)
    final goalsForDate = goals.where((goal) {
      final isActiveOnDay = goal.frequency.contains(frequencyIndex);
      final createdDate = DateTime(
        goal.createdAt.year,
        goal.createdAt.month,
        goal.createdAt.day,
      );
      final isCreatedBeforeOrOn = !normalized.isBefore(createdDate);
      return goal.isActive && isActiveOnDay && isCreatedBeforeOrOn;
    }).toList();

    // Find NEW goals that don't have tasks yet
    final newGoals = goalsForDate
        .where((g) => !existingGoalIds.contains(g.id))
        .toList();

    if (newGoals.isEmpty) {
      ref.invalidate(unifiedTimelineProvider(normalized));
      return;
    }

    // Schedule only the new goals
    for (final goal in newGoals) {
      final task = await hybridScheduler.scheduleGoalForDate(
        goal,
        normalized,
        existingTasks,
      );
      if (task != null) {
        await repo.createScheduledTask(task, allowDuplicates: false);
        existingTasks.add(task); // Add to list so next goal sees it as blocker
      }
    }

    // Refresh UI
    ref.invalidate(scheduledTasksForDateProvider(normalized));
    ref.invalidate(unifiedTimelineProvider(normalized));
  }

  // Get 7 days: 3 before today, today, 3 after today
  List<DateTime> _getSevenDays() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(const Duration(days: 3));
    return List.generate(7, (index) => startDate.add(Duration(days: index)));
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    return date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
  }

  @override
  Widget build(BuildContext context) {
    final sevenDays = _getSevenDays();

    // Listen for goal changes and do incremental updates (not full regeneration)
    ref.listen<AsyncValue<List<Goal>>>(goalsProvider, (previous, next) async {
      // Only update if the list content actually changed
      final previousList = previous?.valueOrNull ?? [];
      final nextList = next.valueOrNull ?? [];

      if (!listEquals(previousList, nextList)) {
        // Check if a goal was ADDED (not deleted - deletion is handled in goal_provider)
        if (nextList.length > previousList.length) {
          // Goal added - do incremental update for today and future
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final datesToUpdate = {
            selectedDate,
            today,
            today.add(const Duration(days: 1)),
            today.add(const Duration(days: 2)),
          };

          for (final date in datesToUpdate) {
            await _incrementalUpdateForDate(date);
          }
        } else {
          // Goal deleted or modified - just refresh UI (deletion already handled)
          ref.invalidate(unifiedTimelineProvider(selectedDate));
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Today'),
        actions: const [
          CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
            radius: 16,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Top Section - Week Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'THIS WEEK',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textInversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'NEXT WEEK',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textInversePrimary.withValues(
                            alpha: 0.4,
                          ),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 7 Days Grid (3 before, today, 3 after)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: sevenDays.map((date) {
                      return _buildDayItem(
                        context,
                        date.day.toString(),
                        DateFormat('E').format(date)[0],
                        _isSelected(date),
                        _isToday(date),
                        () {
                          setState(() {
                            selectedDate = date;
                          });
                          _generateScheduleIfNeeded(date);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Section - Tasks List
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // Header with Add Button
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'INCOMING EVENTS',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            await context.push(
                              '/events/add?date=${selectedDate.toIso8601String()}',
                            );
                            // Refresh tasks after returning from add page
                            ref.invalidate(tasksForDateProvider(selectedDate));
                            ref.invalidate(
                              scheduledTasksForDateProvider(selectedDate),
                            );
                            ref.invalidate(
                              unifiedTimelineProvider(selectedDate),
                            );
                          },
                          mini: true,
                          backgroundColor: AppColors.primary,
                          child: const Icon(
                            Icons.add,
                            color: AppColors.textInversePrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tasks List
                  Expanded(child: _buildTasksList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(
    BuildContext context,
    String day,
    String label,
    bool isSelected,
    bool isToday,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.textInversePrimary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                color: AppColors.textInversePrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textInversePrimary.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
            if (isToday) ...[
              const SizedBox(height: 4),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.textInversePrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    final tasksAsync = ref.watch(unifiedTimelineProvider(selectedDate));

    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          itemCount: tasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = tasks[index];
            return UnifiedTimelineCard(
              item: item,
              onCompleted: () {
                // Refresh timeline after completion
                // Must invalidate the underlying providers too
                ref.invalidate(tasksForDateProvider(selectedDate));
                ref.invalidate(scheduledTasksForDateProvider(selectedDate));
                ref.invalidate(unifiedTimelineProvider(selectedDate));
              },
            );
          },
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
            const Text(
              'Error loading tasks',
              style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.invalidate(unifiedTimelineProvider(selectedDate));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tasks scheduled',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMM d').format(selectedDate),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
