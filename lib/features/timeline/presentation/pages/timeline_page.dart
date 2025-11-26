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
      _generateScheduleIfNeeded(selectedDate);
    });
  }

  /// Generate schedule only if it doesn't exist (for date changes)
  Future<void> _generateScheduleIfNeeded(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);

    // Check if schedule exists
    final repo = ref.read(scheduledTaskRepositoryProvider);
    final existing = await repo.getScheduledTasksForDate(normalized);

    if (existing.isEmpty) {
      // Generate new schedule
      print(
        '📅 Generating schedule for ${normalized.toIso8601String().split('T')[0]}',
      );
      final hybridScheduler = ref.read(hybridSchedulerProvider);
      final newTasks = await hybridScheduler.scheduleForDate(normalized);

      // Save to database
      for (final task in newTasks) {
        await repo.createScheduledTask(task);
      }
      print('✅ Created ${newTasks.length} tasks');

      // Refresh UI
      ref.invalidate(scheduledTasksForDateProvider(normalized));
      ref.invalidate(unifiedTimelineProvider(normalized));
    } else {
      print(
        '📅 Schedule already exists for ${normalized.toIso8601String().split('T')[0]} (${existing.length} tasks)',
      );
    }
  }

  /// Regenerate schedule by deleting old tasks and creating new ones (for goal changes)
  Future<void> _regenerateScheduleForDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);

    print(
      '🔄 Regenerating schedule for ${normalized.toIso8601String().split('T')[0]}',
    );

    // 1. Delete existing scheduled tasks for this date
    final repo = ref.read(scheduledTaskRepositoryProvider);
    final existingTasks = await repo.getScheduledTasksForDate(normalized);
    for (final task in existingTasks) {
      await repo.deleteScheduledTask(task.id);
    }
    print('🗑️ Deleted ${existingTasks.length} old tasks');

    // 2. Invalidate providers to clear cache
    ref.invalidate(generateScheduleProvider(normalized));
    ref.invalidate(scheduledTasksForDateProvider(normalized));
    ref.invalidate(tasksForDateProvider(normalized));
    ref.invalidate(unifiedTimelineProvider(normalized));

    // 3. Generate fresh schedule
    final hybridScheduler = ref.read(hybridSchedulerProvider);
    final newTasks = await hybridScheduler.scheduleForDate(normalized);

    // 4. Save new tasks to database
    for (final task in newTasks) {
      await repo.createScheduledTask(task);
    }
    print('✅ Created ${newTasks.length} new tasks');

    // Wait for database to settle
    await Future.delayed(const Duration(milliseconds: 100));

    // 5. Force refresh the timeline
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

    // Listen for goal changes and auto-regenerate schedule
    ref.listen<AsyncValue<List<Goal>>>(goalsProvider, (previous, next) async {
      // Only regenerate if the list content actually changed
      // This prevents infinite loops from polling providers emitting new list instances
      final previousList = previous?.valueOrNull ?? [];
      final nextList = next.valueOrNull ?? [];

      if (!listEquals(previousList, nextList)) {
        print('🔄 Goals changed (content diff) - auto-regenerating schedule');

        // Regenerate for Selected Date, Today, Tomorrow, and Day After Tomorrow
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final datesToRegenerate = {
          selectedDate, // Priority
          today,
          today.add(const Duration(days: 1)),
          today.add(const Duration(days: 2)),
        };

        // Regenerate sequentially to avoid overwhelming the system
        for (final date in datesToRegenerate) {
          await _regenerateScheduleForDate(date);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.checklist_rounded),
          onPressed: () {
            context.push('/goals');
          },
          tooltip: 'Manage Goals',
        ),
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
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
            Text(
              'Error loading tasks',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
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
          Text(
            'No tasks scheduled',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
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
