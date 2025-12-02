import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/goal.dart';
import '../../data/models/milestone.dart';
import '../../data/models/task.dart';
import '../../data/models/one_time_task.dart';
import '../../data/models/scheduled_task.dart';
import '../../data/models/productivity_data.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/habit_metrics.dart';
import '../../data/models/daily_activity_log.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/one_time_task_repository.dart';
import '../../data/repositories/scheduled_task_repository.dart';
import '../../data/repositories/productivity_data_repository.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../data/repositories/habit_metrics_repository.dart';
import '../../data/repositories/daily_activity_log_repository.dart';
import 'rule_based_scheduler.dart';
import 'pattern_based_ml_service.dart';
import 'hybrid_scheduler.dart';
import 'profile_based_scheduler.dart';
import 'dynamic_time_window_service.dart';
import 'daily_activity_service.dart';

/// Unique task name for the midnight schedule generation
const String midnightScheduleTask = 'com.goaltracker.midnightSchedule';

/// Notification channel for schedule notifications
const String scheduleNotificationChannelId = 'schedule_notifications';
const String scheduleNotificationChannelName = 'Schedule Notifications';

/// Initialize the FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Top-level callback function for WorkManager (must be top-level or static)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      debugPrint('Background task started: $task');
      
      if (task == midnightScheduleTask || task == Workmanager.iOSBackgroundTask) {
        await _generateScheduleInBackground();
        return true;
      }
      
      return true;
    } catch (e) {
      debugPrint('Background task error: $e');
      return false;
    }
  });
}

/// Generate schedule in the background
Future<void> _generateScheduleInBackground() async {
  try {
    // Initialize database
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        GoalSchema,
        MilestoneSchema,
        TaskSchema,
        OneTimeTaskSchema,
        ScheduledTaskSchema,
        ProductivityDataSchema,
        AppSettingsSchema,
        UserProfileSchema,
        HabitMetricsSchema,
        DailyActivityLogSchema,
      ],
      directory: dir.path,
      name: 'goal_tracker',
    );

    // Get today's date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Initialize repositories
    final goalRepo = GoalRepository(isar);
    final oneTimeTaskRepo = OneTimeTaskRepository(isar);
    final scheduledTaskRepo = ScheduledTaskRepository(isar);
    final productivityDataRepo = ProductivityDataRepository(isar);
    final userProfileRepo = UserProfileRepository(isar);
    final habitMetricsRepo = HabitMetricsRepository(isar);
    final activityLogRepo = DailyActivityLogRepository(isar);

    // Check if schedule already exists for today
    final existingTasks = await scheduledTaskRepo.getScheduledTasksForDate(today);
    
    if (existingTasks.isNotEmpty) {
      debugPrint('Schedule already exists for today, skipping generation');
      await _showNotification(
        'Schedule Ready',
        'Your schedule for today is already set up!',
      );
      await isar.close();
      return;
    }

    // Initialize services
    final dailyActivityService = DailyActivityService(activityLogRepo, userProfileRepo);
    
    final ruleBasedScheduler = RuleBasedScheduler(
      isar: isar,
      goalRepository: goalRepo,
      oneTimeTaskRepository: oneTimeTaskRepo,
      scheduledTaskRepository: scheduledTaskRepo,
      dailyActivityService: dailyActivityService,
    );

    final mlPredictor = PatternBasedMLService(
      isar: isar,
      productivityDataRepository: productivityDataRepo,
      dailyActivityService: dailyActivityService,
      habitMetricsRepository: habitMetricsRepo,
    );

    final profileBasedScheduler = ProfileBasedScheduler(userProfileRepo);
    
    final dynamicTimeWindowService = DynamicTimeWindowService(
      activityRepo: activityLogRepo,
      productivityRepo: productivityDataRepo,
      profileRepo: userProfileRepo,
      activityService: dailyActivityService,
    );

    final hybridScheduler = HybridScheduler(
      isar: isar,
      goalRepository: goalRepo,
      oneTimeTaskRepository: oneTimeTaskRepo,
      scheduledTaskRepository: scheduledTaskRepo,
      ruleBasedScheduler: ruleBasedScheduler,
      mlPredictor: mlPredictor,
      profileBasedScheduler: profileBasedScheduler,
      dynamicTimeWindowService: dynamicTimeWindowService,
      habitMetricsRepository: habitMetricsRepo,
      userProfileRepository: userProfileRepo,
    );

    // Generate schedule
    final newTasks = await hybridScheduler.scheduleForDate(today);

    // Save tasks to database
    int savedCount = 0;
    for (final task in newTasks) {
      final existingForGoal = await scheduledTaskRepo.getTaskForGoalOnDate(
        task.goalId,
        today,
      );
      if (existingForGoal == null) {
        await scheduledTaskRepo.createScheduledTask(task, allowDuplicates: false);
        savedCount++;
      }
    }

    debugPrint('Background schedule generation complete: $savedCount tasks created');

    // Show notification
    await _showNotification(
      'Schedule Generated! 🎯',
      savedCount > 0 
          ? '$savedCount task${savedCount > 1 ? 's' : ''} scheduled for today. Open the app to view!'
          : 'No tasks scheduled for today.',
    );

    await isar.close();
  } catch (e) {
    debugPrint('Error in background schedule generation: $e');
    await _showNotification(
      'Schedule Generation Failed',
      'Could not generate today\'s schedule. Please open the app.',
    );
  }
}

/// Show a local notification (Android only)
Future<void> _showNotification(String title, String body) async {
  // Initialize notifications if not already done
  const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
  const initSettings = InitializationSettings(android: androidSettings);
  
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const androidDetails = AndroidNotificationDetails(
    scheduleNotificationChannelId,
    scheduleNotificationChannelName,
    channelDescription: 'Notifications for schedule generation',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: true,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title,
    body,
    notificationDetails,
  );
}

/// Service to manage background schedule generation (Android only)
class BackgroundScheduleService {
  static final BackgroundScheduleService _instance = BackgroundScheduleService._internal();
  factory BackgroundScheduleService() => _instance;
  BackgroundScheduleService._internal();

  bool _isInitialized = false;

  /// Initialize the background service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize WorkManager
    await Workmanager().initialize(
      callbackDispatcher,
    );

    // Initialize notifications
    await _initializeNotifications();

    // Schedule the midnight task
    await scheduleMidnightTask();

    _isInitialized = true;
    debugPrint('BackgroundScheduleService initialized');
  }

  /// Initialize local notifications (Android only)
  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification tapped: ${response.payload}');
      },
    );

    // Request permissions on Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Schedule the midnight task
  Future<void> scheduleMidnightTask() async {
    // Cancel any existing task first
    await Workmanager().cancelByUniqueName(midnightScheduleTask);

    // Calculate initial delay until next midnight
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 5); // 5 seconds past midnight
    final initialDelay = nextMidnight.difference(now);

    debugPrint('Scheduling midnight task. Next run in: ${initialDelay.inMinutes} minutes');

    // Register periodic task (runs approximately every 24 hours)
    await Workmanager().registerPeriodicTask(
      midnightScheduleTask,
      midnightScheduleTask,
      frequency: const Duration(hours: 24),
      initialDelay: initialDelay,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 15),
    );

    debugPrint('Midnight schedule task registered');
  }

  /// Cancel the midnight task
  Future<void> cancelMidnightTask() async {
    await Workmanager().cancelByUniqueName(midnightScheduleTask);
    debugPrint('Midnight schedule task cancelled');
  }

  /// Trigger immediate schedule generation (for testing)
  Future<void> triggerImmediateGeneration() async {
    await Workmanager().registerOneOffTask(
      '${midnightScheduleTask}_immediate',
      midnightScheduleTask,
      initialDelay: const Duration(seconds: 5),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );
    debugPrint('Immediate schedule generation triggered');
  }

  /// Show a test notification (for debugging)
  Future<void> showTestNotification() async {
    await _showNotification(
      'Test Notification 🔔',
      'Background schedule service is working!',
    );
  }
}
