import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/backup_models.dart';
import '../../data/models/goal.dart';
import '../../data/models/milestone.dart';
import '../../data/models/one_time_task.dart';
import '../../data/models/scheduled_task.dart';
import '../../data/models/task.dart';
import '../../data/models/productivity_data.dart';
import '../../data/models/habit_metrics.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/daily_activity_log.dart';

/// Result of a backup/restore operation
class BackupResult {
  final bool success;
  final String message;
  final String? filePath;
  final BackupMetadata? metadata;

  BackupResult({
    required this.success,
    required this.message,
    this.filePath,
    this.metadata,
  });
}

/// Metadata about a backup
class BackupMetadata {
  final DateTime createdAt;
  final int goalsCount;
  final int milestonesCount;
  final int oneTimeTasksCount;
  final int scheduledTasksCount;
  final int tasksCount;
  final int productivityDataCount;
  final int habitMetricsCount;
  final bool hasUserProfile;
  final bool hasAppSettings;
  final int dailyActivityLogsCount;

  BackupMetadata({
    required this.createdAt,
    required this.goalsCount,
    required this.milestonesCount,
    required this.oneTimeTasksCount,
    required this.scheduledTasksCount,
    required this.tasksCount,
    required this.productivityDataCount,
    required this.habitMetricsCount,
    required this.hasUserProfile,
    required this.hasAppSettings,
    required this.dailyActivityLogsCount,
  });

  int get totalItems =>
      goalsCount +
      milestonesCount +
      oneTimeTasksCount +
      scheduledTasksCount +
      tasksCount +
      productivityDataCount +
      habitMetricsCount +
      (hasUserProfile ? 1 : 0) +
      (hasAppSettings ? 1 : 0) +
      dailyActivityLogsCount;
}

/// Service for backup and restore operations
class BackupRestoreService {
  final Isar isar;

  BackupRestoreService(this.isar);

  static const String backupVersion = '1.0.0';

  /// Get the backup directory (Downloads folder for persistence)
  Future<Directory> _getBackupDirectory() async {
    // Try to get Downloads directory first (persists after app uninstall)
    Directory? downloadsDir = await getDownloadsDirectory();

    // Fallback to external storage if Downloads is not available
    if (downloadsDir == null) {
      downloadsDir = await getExternalStorageDirectory();
    }

    // Final fallback to app documents (won't persist after uninstall)
    if (downloadsDir == null) {
      final appDir = await getApplicationDocumentsDirectory();
      downloadsDir = appDir;
    }

    // Create a dedicated folder for goal tracker backups
    final backupDir = Directory('${downloadsDir.path}/GoalTrackerBackups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  /// Generate a backup filename
  String _generateBackupFilename() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
    return 'goal_tracker_backup_${formatter.format(now)}.json';
  }

  /// Get current data counts for display
  Future<BackupMetadata> getCurrentDataCounts() async {
    final goals = await isar.goals.count();
    final milestones = await isar.milestones.count();
    final oneTimeTasks = await isar.oneTimeTasks.count();
    final scheduledTasks = await isar.scheduledTasks.count();
    final tasks = await isar.tasks.count();
    final productivityData = await isar.productivityDatas.count();
    final habitMetrics = await isar.habitMetrics.count();
    final userProfile = await isar.userProfiles.count();
    final appSettings = await isar.appSettings.count();
    final dailyActivityLogs = await isar.dailyActivityLogs.count();

    return BackupMetadata(
      createdAt: DateTime.now(),
      goalsCount: goals,
      milestonesCount: milestones,
      oneTimeTasksCount: oneTimeTasks,
      scheduledTasksCount: scheduledTasks,
      tasksCount: tasks,
      productivityDataCount: productivityData,
      habitMetricsCount: habitMetrics,
      hasUserProfile: userProfile > 0,
      hasAppSettings: appSettings > 0,
      dailyActivityLogsCount: dailyActivityLogs,
    );
  }

  /// Export all data to a JSON backup file
  Future<BackupResult> exportBackup() async {
    try {
      debugPrint('BackupRestoreService: Starting backup export...');

      // Collect all data
      final goals = await isar.goals.where().findAll();
      final milestones = await isar.milestones.where().findAll();
      final oneTimeTasks = await isar.oneTimeTasks.where().findAll();
      final scheduledTasks = await isar.scheduledTasks.where().findAll();
      final tasks = await isar.tasks.where().findAll();
      final productivityData = await isar.productivityDatas.where().findAll();
      final habitMetrics = await isar.habitMetrics.where().findAll();
      final userProfiles = await isar.userProfiles.where().findAll();
      final appSettingsList = await isar.appSettings.where().findAll();
      final dailyActivityLogs = await isar.dailyActivityLogs.where().findAll();

      debugPrint(
        'BackupRestoreService: Collected ${goals.length} goals, ${milestones.length} milestones...',
      );

      // Create backup data object
      final backupData = BackupData(
        version: backupVersion,
        createdAt: DateTime.now(),
        goals: goals.map((g) => GoalBackup.fromModel(g)).toList(),
        milestones: milestones
            .map((m) => MilestoneBackup.fromModel(m))
            .toList(),
        oneTimeTasks: oneTimeTasks
            .map((t) => OneTimeTaskBackup.fromModel(t))
            .toList(),
        scheduledTasks: scheduledTasks
            .map((t) => ScheduledTaskBackup.fromModel(t))
            .toList(),
        tasks: tasks.map((t) => TaskBackup.fromModel(t)).toList(),
        productivityData: productivityData
            .map((p) => ProductivityDataBackup.fromModel(p))
            .toList(),
        habitMetrics: habitMetrics
            .map((h) => HabitMetricsBackup.fromModel(h))
            .toList(),
        userProfile: userProfiles.isNotEmpty
            ? UserProfileBackup.fromModel(userProfiles.first)
            : null,
        appSettings: appSettingsList.isNotEmpty
            ? AppSettingsBackup.fromModel(appSettingsList.first)
            : null,
        dailyActivityLogs: dailyActivityLogs
            .map((d) => DailyActivityLogBackup.fromModel(d))
            .toList(),
      );

      // Write to file
      final backupDir = await _getBackupDirectory();
      final filename = _generateBackupFilename();
      final file = File('${backupDir.path}/$filename');

      await file.writeAsString(backupData.toJsonString());

      debugPrint('BackupRestoreService: Backup saved to ${file.path}');

      final metadata = BackupMetadata(
        createdAt: backupData.createdAt,
        goalsCount: goals.length,
        milestonesCount: milestones.length,
        oneTimeTasksCount: oneTimeTasks.length,
        scheduledTasksCount: scheduledTasks.length,
        tasksCount: tasks.length,
        productivityDataCount: productivityData.length,
        habitMetricsCount: habitMetrics.length,
        hasUserProfile: userProfiles.isNotEmpty,
        hasAppSettings: appSettingsList.isNotEmpty,
        dailyActivityLogsCount: dailyActivityLogs.length,
      );

      return BackupResult(
        success: true,
        message:
            'Backup created successfully with ${metadata.totalItems} items',
        filePath: file.path,
        metadata: metadata,
      );
    } catch (e, stack) {
      debugPrint('BackupRestoreService: Export failed: $e\n$stack');
      return BackupResult(
        success: false,
        message: 'Backup failed: ${e.toString()}',
      );
    }
  }

  /// Import data from a backup file
  Future<BackupResult> importBackup(String filePath) async {
    try {
      debugPrint(
        'BackupRestoreService: Starting backup import from $filePath...',
      );

      final file = File(filePath);
      if (!await file.exists()) {
        return BackupResult(success: false, message: 'Backup file not found');
      }

      final jsonString = await file.readAsString();
      final backupData = BackupData.fromJsonString(jsonString);

      debugPrint(
        'BackupRestoreService: Parsed backup version ${backupData.version} from ${backupData.createdAt}',
      );

      // Clear existing data and restore from backup
      await isar.writeTxn(() async {
        // Clear all collections
        await isar.goals.clear();
        await isar.milestones.clear();
        await isar.oneTimeTasks.clear();
        await isar.scheduledTasks.clear();
        await isar.tasks.clear();
        await isar.productivityDatas.clear();
        await isar.habitMetrics.clear();
        await isar.userProfiles.clear();
        await isar.appSettings.clear();
        await isar.dailyActivityLogs.clear();

        debugPrint('BackupRestoreService: Cleared existing data');

        // Restore goals first (they are referenced by other collections)
        final goalModels = backupData.goals.map((g) => g.toModel()).toList();
        await isar.goals.putAll(goalModels);
        debugPrint('BackupRestoreService: Restored ${goalModels.length} goals');

        // Restore milestones with goal links
        for (final milestoneBackup in backupData.milestones) {
          final milestone = milestoneBackup.toModel();
          if (milestoneBackup.goalId != null) {
            final goal = await isar.goals.get(milestoneBackup.goalId!);
            if (goal != null) {
              milestone.goal.value = goal;
            }
          }
          await isar.milestones.put(milestone);
          await milestone.goal.save();
        }
        debugPrint(
          'BackupRestoreService: Restored ${backupData.milestones.length} milestones',
        );

        // Restore one-time tasks
        final oneTimeTaskModels = backupData.oneTimeTasks
            .map((t) => t.toModel())
            .toList();
        await isar.oneTimeTasks.putAll(oneTimeTaskModels);

        // Restore scheduled tasks
        final scheduledTaskModels = backupData.scheduledTasks
            .map((t) => t.toModel())
            .toList();
        await isar.scheduledTasks.putAll(scheduledTaskModels);

        // Restore tasks with goal links
        for (final taskBackup in backupData.tasks) {
          final task = taskBackup.toModel();
          if (taskBackup.goalId != null) {
            final goal = await isar.goals.get(taskBackup.goalId!);
            if (goal != null) {
              task.goal.value = goal;
            }
          }
          await isar.tasks.put(task);
          await task.goal.save();
        }

        // Restore productivity data
        final productivityModels = backupData.productivityData
            .map((p) => p.toModel())
            .toList();
        await isar.productivityDatas.putAll(productivityModels);

        // Restore habit metrics
        final habitMetricsModels = backupData.habitMetrics
            .map((h) => h.toModel())
            .toList();
        await isar.habitMetrics.putAll(habitMetricsModels);

        // Restore user profile
        if (backupData.userProfile != null) {
          await isar.userProfiles.put(backupData.userProfile!.toModel());
        }

        // Restore app settings
        if (backupData.appSettings != null) {
          await isar.appSettings.put(backupData.appSettings!.toModel());
        }

        // Restore daily activity logs
        final dailyLogModels = backupData.dailyActivityLogs
            .map((d) => d.toModel())
            .toList();
        await isar.dailyActivityLogs.putAll(dailyLogModels);
      });

      final metadata = BackupMetadata(
        createdAt: backupData.createdAt,
        goalsCount: backupData.goals.length,
        milestonesCount: backupData.milestones.length,
        oneTimeTasksCount: backupData.oneTimeTasks.length,
        scheduledTasksCount: backupData.scheduledTasks.length,
        tasksCount: backupData.tasks.length,
        productivityDataCount: backupData.productivityData.length,
        habitMetricsCount: backupData.habitMetrics.length,
        hasUserProfile: backupData.userProfile != null,
        hasAppSettings: backupData.appSettings != null,
        dailyActivityLogsCount: backupData.dailyActivityLogs.length,
      );

      debugPrint('BackupRestoreService: Import completed successfully');

      return BackupResult(
        success: true,
        message: 'Restored ${metadata.totalItems} items from backup',
        metadata: metadata,
      );
    } catch (e, stack) {
      debugPrint('BackupRestoreService: Import failed: $e\n$stack');
      return BackupResult(
        success: false,
        message: 'Restore failed: ${e.toString()}',
      );
    }
  }

  /// List available backup files
  Future<List<FileSystemEntity>> listBackups() async {
    try {
      final backupDir = await _getBackupDirectory();
      final files = await backupDir
          .list()
          .where((entity) => entity.path.endsWith('.json'))
          .toList();

      // Sort by modification time (newest first)
      files.sort((a, b) {
        final aStats = File(a.path).statSync();
        final bStats = File(b.path).statSync();
        return bStats.modified.compareTo(aStats.modified);
      });

      return files;
    } catch (e) {
      debugPrint('BackupRestoreService: Failed to list backups: $e');
      return [];
    }
  }

  /// Delete a backup file
  Future<bool> deleteBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('BackupRestoreService: Failed to delete backup: $e');
      return false;
    }
  }

  /// Get metadata from a backup file without fully loading it
  Future<BackupMetadata?> getBackupFileMetadata(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final jsonString = await file.readAsString();
      final backupData = BackupData.fromJsonString(jsonString);

      return BackupMetadata(
        createdAt: backupData.createdAt,
        goalsCount: backupData.goals.length,
        milestonesCount: backupData.milestones.length,
        oneTimeTasksCount: backupData.oneTimeTasks.length,
        scheduledTasksCount: backupData.scheduledTasks.length,
        tasksCount: backupData.tasks.length,
        productivityDataCount: backupData.productivityData.length,
        habitMetricsCount: backupData.habitMetrics.length,
        hasUserProfile: backupData.userProfile != null,
        hasAppSettings: backupData.appSettings != null,
        dailyActivityLogsCount: backupData.dailyActivityLogs.length,
      );
    } catch (e) {
      debugPrint('BackupRestoreService: Failed to read backup metadata: $e');
      return null;
    }
  }

  /// Clear all app data (factory reset)
  Future<BackupResult> clearAllData() async {
    try {
      await isar.writeTxn(() async {
        await isar.goals.clear();
        await isar.milestones.clear();
        await isar.oneTimeTasks.clear();
        await isar.scheduledTasks.clear();
        await isar.tasks.clear();
        await isar.productivityDatas.clear();
        await isar.habitMetrics.clear();
        await isar.userProfiles.clear();
        await isar.appSettings.clear();
        await isar.dailyActivityLogs.clear();
      });

      return BackupResult(
        success: true,
        message: 'All data cleared successfully',
      );
    } catch (e) {
      return BackupResult(
        success: false,
        message: 'Failed to clear data: ${e.toString()}',
      );
    }
  }
}
