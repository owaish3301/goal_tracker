import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/backup_restore_service.dart';
import '../../../../core/services/database_service.dart';

/// Provider for BackupRestoreService
final backupRestoreServiceProvider = Provider<BackupRestoreService>((ref) {
  final isar = ref.watch(isarProvider);
  return BackupRestoreService(isar);
});

/// State for backup/restore operations
enum BackupOperationStatus { idle, inProgress, success, error }

class BackupState {
  final BackupOperationStatus status;
  final String? message;
  final BackupMetadata? currentDataCounts;
  final List<FileSystemEntity> availableBackups;
  final String? lastBackupPath;

  BackupState({
    this.status = BackupOperationStatus.idle,
    this.message,
    this.currentDataCounts,
    this.availableBackups = const [],
    this.lastBackupPath,
  });

  BackupState copyWith({
    BackupOperationStatus? status,
    String? message,
    BackupMetadata? currentDataCounts,
    List<FileSystemEntity>? availableBackups,
    String? lastBackupPath,
  }) {
    return BackupState(
      status: status ?? this.status,
      message: message ?? this.message,
      currentDataCounts: currentDataCounts ?? this.currentDataCounts,
      availableBackups: availableBackups ?? this.availableBackups,
      lastBackupPath: lastBackupPath ?? this.lastBackupPath,
    );
  }
}

/// StateNotifier for backup operations
class BackupStateNotifier extends StateNotifier<BackupState> {
  final BackupRestoreService _service;

  BackupStateNotifier(this._service) : super(BackupState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final counts = await _service.getCurrentDataCounts();
    final backups = await _service.listBackups();
    state = state.copyWith(
      currentDataCounts: counts,
      availableBackups: backups,
    );
  }

  Future<void> refresh() async {
    await _loadInitialData();
  }

  Future<BackupResult> createBackup() async {
    state = state.copyWith(
      status: BackupOperationStatus.inProgress,
      message: 'Creating backup...',
    );

    final result = await _service.exportBackup();

    state = state.copyWith(
      status: result.success
          ? BackupOperationStatus.success
          : BackupOperationStatus.error,
      message: result.message,
      lastBackupPath: result.filePath,
    );

    // Refresh backup list
    await _loadInitialData();

    return result;
  }

  /// Create a backup and share it so user can save to external location
  /// (public Downloads, Google Drive, etc.) that persists after app uninstall
  Future<BackupResult> createAndShareBackup() async {
    state = state.copyWith(
      status: BackupOperationStatus.inProgress,
      message: 'Creating backup...',
    );

    final result = await _service.exportAndShareBackup();

    state = state.copyWith(
      status: result.success
          ? BackupOperationStatus.success
          : BackupOperationStatus.error,
      message: result.message,
      lastBackupPath: result.filePath,
    );

    // Refresh backup list
    await _loadInitialData();

    return result;
  }

  Future<BackupResult> restoreBackup(String filePath) async {
    state = state.copyWith(
      status: BackupOperationStatus.inProgress,
      message: 'Restoring backup...',
    );

    final result = await _service.importBackup(filePath);

    state = state.copyWith(
      status: result.success
          ? BackupOperationStatus.success
          : BackupOperationStatus.error,
      message: result.message,
    );

    // Refresh data counts
    await _loadInitialData();

    return result;
  }

  /// Restore from an external backup file using file picker
  /// This allows restoring from public Downloads, cloud storage, etc.
  Future<BackupResult> restoreFromExternalFile() async {
    state = state.copyWith(
      status: BackupOperationStatus.inProgress,
      message: 'Selecting backup file...',
    );

    final result = await _service.pickAndRestoreBackup();

    state = state.copyWith(
      status: result.success
          ? BackupOperationStatus.success
          : BackupOperationStatus.error,
      message: result.message,
    );

    // Refresh data counts
    await _loadInitialData();

    return result;
  }

  Future<bool> deleteBackup(String filePath) async {
    final success = await _service.deleteBackup(filePath);
    if (success) {
      await _loadInitialData();
    }
    return success;
  }

  Future<BackupResult> clearAllData() async {
    state = state.copyWith(
      status: BackupOperationStatus.inProgress,
      message: 'Clearing all data...',
    );

    final result = await _service.clearAllData();

    state = state.copyWith(
      status: result.success
          ? BackupOperationStatus.success
          : BackupOperationStatus.error,
      message: result.message,
    );

    await _loadInitialData();

    return result;
  }

  void resetStatus() {
    state = state.copyWith(status: BackupOperationStatus.idle, message: null);
  }

  /// Reset user profile to force re-onboarding
  Future<void> resetUserProfile() async {
    await _service.resetUserProfile();
    await _loadInitialData();
  }
}

/// Provider for backup state
final backupStateProvider =
    StateNotifierProvider<BackupStateNotifier, BackupState>((ref) {
      final service = ref.watch(backupRestoreServiceProvider);
      return BackupStateNotifier(service);
    });

/// Provider for current data counts
final currentDataCountsProvider = FutureProvider<BackupMetadata>((ref) async {
  final service = ref.watch(backupRestoreServiceProvider);
  return await service.getCurrentDataCounts();
});

/// Provider for available backups
final availableBackupsProvider = FutureProvider<List<FileSystemEntity>>((
  ref,
) async {
  final service = ref.watch(backupRestoreServiceProvider);
  return await service.listBackups();
});
