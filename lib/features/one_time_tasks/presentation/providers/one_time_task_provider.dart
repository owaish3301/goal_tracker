import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/database_service.dart';
import '../../../../data/repositories/one_time_task_repository.dart';
import '../../../../data/models/one_time_task.dart';

// Provider for the repository
final oneTimeTaskRepositoryProvider = Provider<OneTimeTaskRepository>((ref) {
  return OneTimeTaskRepository(DatabaseService.instance);
});

// Provider for tasks on a specific date
final tasksForDateProvider = FutureProvider.family<List<OneTimeTask>, DateTime>(
  (ref, date) async {
    final repository = ref.watch(oneTimeTaskRepositoryProvider);
    return repository.getOneTimeTasksForDate(date);
  },
);

// Provider for all pending tasks
final allPendingTasksProvider = FutureProvider<List<OneTimeTask>>((ref) async {
  final repository = ref.watch(oneTimeTaskRepositoryProvider);
  return repository.getAllPendingOneTimeTasks();
});

// StateNotifier for managing task operations
class OneTimeTaskNotifier extends StateNotifier<AsyncValue<void>> {
  final OneTimeTaskRepository repository;

  OneTimeTaskNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> toggleComplete(int taskId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final task = await repository.getOneTimeTask(taskId);
      if (task != null) {
        if (task.isCompleted) {
          await repository.markAsIncomplete(taskId);
        } else {
          await repository.markAsCompleted(taskId);
        }
      }
    });
  }

  Future<void> deleteTask(int taskId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.deleteOneTimeTask(taskId);
    });
  }
}

// Provider for the notifier
final oneTimeTaskNotifierProvider =
    StateNotifierProvider<OneTimeTaskNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(oneTimeTaskRepositoryProvider);
      return OneTimeTaskNotifier(repository);
    });
