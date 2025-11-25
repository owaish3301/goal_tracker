import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/goal.dart';
import '../../data/models/milestone.dart';
import '../../data/models/task.dart';
import '../../data/models/one_time_task.dart';
import '../../data/models/scheduled_task.dart';
import '../../data/models/productivity_data.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/milestone_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/one_time_task_repository.dart';
import '../../data/repositories/scheduled_task_repository.dart';
import '../../data/repositories/productivity_data_repository.dart';
import '../../data/repositories/app_settings_repository.dart';
import '../../data/repositories/user_profile_repository.dart';

class DatabaseService {
  static Isar? _isar;

  // Initialize the database
  static Future<Isar> initialize() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        GoalSchema,
        MilestoneSchema,
        TaskSchema,
        OneTimeTaskSchema,
        ScheduledTaskSchema,
        ProductivityDataSchema,
        AppSettingsSchema,
        UserProfileSchema,
      ],
      directory: dir.path,
      name: 'goal_tracker',
    );

    return _isar!;
  }

  // Get the database instance
  static Isar get instance {
    if (_isar == null || !_isar!.isOpen) {
      throw Exception(
        'Database not initialized. Call DatabaseService.initialize() first.',
      );
    }
    return _isar!;
  }

  // Close the database
  static Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }
}

// Riverpod Providers

// Database instance provider
final isarProvider = Provider<Isar>((ref) {
  return DatabaseService.instance;
});

// Repository providers
final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return GoalRepository(isar);
});

final milestoneRepositoryProvider = Provider<MilestoneRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return MilestoneRepository(isar);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return TaskRepository(isar);
});

final oneTimeTaskRepositoryProvider = Provider<OneTimeTaskRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return OneTimeTaskRepository(isar);
});

final scheduledTaskRepositoryProvider = Provider<ScheduledTaskRepository>((
  ref,
) {
  final isar = ref.watch(isarProvider);
  return ScheduledTaskRepository(isar);
});

final productivityDataRepositoryProvider = Provider<ProductivityDataRepository>(
  (ref) {
    final isar = ref.watch(isarProvider);
    return ProductivityDataRepository(isar);
  },
);

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return AppSettingsRepository(isar);
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return UserProfileRepository(isar);
});
