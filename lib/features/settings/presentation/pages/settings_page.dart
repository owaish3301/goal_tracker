import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/backup_restore_service.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Load data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backupStateProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final backupState = ref.watch(backupStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          if (backupState.status == BackupOperationStatus.inProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader('Data & Backup'),
              _buildDataSummaryCard(backupState.currentDataCounts),
              const SizedBox(height: 16),
              _buildBackupActions(backupState),
              const SizedBox(height: 24),
              _buildAvailableBackups(backupState),

              const SizedBox(height: 32),
              _buildSectionHeader('Preferences'),
              _buildSettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Coming soon',
                trailing: const Switch(
                  value: false,
                  onChanged: null,
                  activeTrackColor: AppColors.primary,
                ),
                onTap: () => _showComingSoonSnackbar('Notifications'),
              ),
              _buildSettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Always on',
                trailing: const Switch(
                  value: true,
                  onChanged: null,
                  activeTrackColor: AppColors.primary,
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('Account'),
              _buildSettingsTile(
                icon: Icons.restart_alt,
                title: 'Redo Onboarding',
                subtitle: 'Reset your profile preferences',
                onTap: _showRedoOnboardingConfirmation,
              ),
              _buildSettingsTile(
                icon: Icons.delete_forever,
                title: 'Clear All Data',
                subtitle: 'Permanently delete everything',
                titleColor: AppColors.error,
                onTap: _showClearDataConfirmation,
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('About'),
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: '0.1.0 (Beta)',
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Offline-first & Private',
                onTap: _showPrivacyInfo,
              ),

              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDataSummaryCard(BackupMetadata? metadata) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.storage,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      metadata != null
                          ? '${metadata.totalItems} items stored locally'
                          : 'Loading...',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (metadata != null) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildDataChip('Goals', metadata.goalsCount),
                _buildDataChip(
                  'Tasks',
                  metadata.scheduledTasksCount + metadata.oneTimeTasksCount,
                ),
                _buildDataChip('Streaks', metadata.habitMetricsCount),
                _buildDataChip('ML Data', metadata.productivityDataCount),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataChip(String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupActions(BackupState backupState) {
    final isLoading = backupState.status == BackupOperationStatus.inProgress;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.backup,
                label: 'Create Backup',
                onPressed: isLoading ? null : _createBackup,
                isLoading:
                    isLoading &&
                    backupState.message?.contains('Creating') == true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.folder_open,
                label: 'Restore From File',
                onPressed: isLoading ? null : _restoreFromExternalFile,
                isOutlined: true,
                isLoading:
                    isLoading &&
                    backupState.message?.contains('Selecting') == true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Hint text explaining where backups are saved
        const Text(
          'Tip: Use "Create Backup" to save to Downloads/Cloud for persistence after uninstall',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isOutlined = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.transparent : AppColors.primary,
        foregroundColor: isOutlined
            ? AppColors.primary
            : AppColors.textInversePrimary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isOutlined
              ? const BorderSide(color: AppColors.primary)
              : BorderSide.none,
        ),
        elevation: isOutlined ? 0 : 2,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.textInversePrimary,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAvailableBackups(BackupState backupState) {
    if (backupState.availableBackups.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              size: 20,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'No backups yet. Create one to protect your data.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(
                  Icons.folder_open,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Available Backups (${backupState.availableBackups.length})',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.background),
          ...backupState.availableBackups
              .take(3)
              .map((file) => _buildBackupItem(file)),
          if (backupState.availableBackups.length > 3)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '+${backupState.availableBackups.length - 3} more backups',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackupItem(FileSystemEntity file) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final stats = File(file.path).statSync();
    final dateFormatter = DateFormat('MMM d, yyyy • h:mm a');

    return InkWell(
      onTap: () => _showBackupOptions(file.path),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.description, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName.replaceAll('.json', ''),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    dateFormatter.format(stats.modified),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _formatFileSize(stats.size),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: titleColor ?? AppColors.textSecondary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: titleColor ?? AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing:
            trailing ??
            (onTap != null
                ? const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  )
                : null),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _createBackup() async {
    HapticFeedback.mediumImpact();

    final result = await ref
        .read(backupStateProvider.notifier)
        .createAndShareBackup();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              result.success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(result.message)),
          ],
        ),
        backgroundColor: result.success ? Colors.green : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _restoreFromExternalFile() async {
    HapticFeedback.mediumImpact();

    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Restore from File',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Select a backup file from your Downloads folder or cloud storage.\n\nWarning: This will replace ALL your current data with the backup. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Select File'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final result = await ref
        .read(backupStateProvider.notifier)
        .restoreFromExternalFile();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              result.success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(result.message)),
          ],
        ),
        backgroundColor: result.success ? Colors.green : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _confirmRestore(String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Confirm Restore',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This will replace ALL your current data with the backup. This action cannot be undone.\n\nAre you sure you want to continue?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performRestore(filePath);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  Future<void> _performRestore(String filePath) async {
    HapticFeedback.mediumImpact();

    final result = await ref
        .read(backupStateProvider.notifier)
        .restoreBackup(filePath);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              result.success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(result.message)),
          ],
        ),
        backgroundColor: result.success ? Colors.green : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showBackupOptions(String filePath) {
    final fileName = filePath.split(Platform.pathSeparator).last;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              fileName.replaceAll('.json', ''),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.restore, color: AppColors.primary),
              title: const Text(
                'Restore from this backup',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmRestore(filePath);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text(
                'Delete backup',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteBackup(filePath);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteBackup(String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete Backup?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This backup file will be permanently deleted.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              await ref
                  .read(backupStateProvider.notifier)
                  .deleteBackup(filePath);
              if (!mounted) return;
              scaffoldMessenger.showSnackBar(
                const SnackBar(content: Text('Backup deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            SizedBox(width: 12),
            Text(
              'Clear All Data?',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: const Text(
          'This will permanently delete:\n\n'
          '• All your goals and milestones\n'
          '• All tasks and schedules\n'
          '• All streaks and progress\n'
          '• All ML training data\n'
          '• Your profile settings\n\n'
          'This action CANNOT be undone!',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final router = GoRouter.of(context);
              Navigator.pop(context);
              final result = await ref
                  .read(backupStateProvider.notifier)
                  .clearAllData();
              if (!mounted) return;

              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(result.message),
                  backgroundColor: result.success
                      ? Colors.green
                      : AppColors.error,
                ),
              );
              // Navigate to onboarding after clearing data
              if (result.success) {
                router.go('/onboarding');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  void _showRedoOnboardingConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Redo Onboarding?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This will reset your profile settings (wake/sleep times, chronotype, etc.) and take you through the onboarding again.\n\nYour goals and tasks will NOT be deleted.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performRedoOnboarding();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Redo Onboarding'),
          ),
        ],
      ),
    );
  }

  Future<void> _performRedoOnboarding() async {
    HapticFeedback.mediumImpact();

    try {
      // Reset the user profile
      final profileRepo = ref.read(backupStateProvider.notifier);
      await profileRepo.resetUserProfile();

      if (!mounted) return;

      // Navigate to onboarding
      context.go('/onboarding');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile reset. Please complete onboarding again.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  void _showComingSoonSnackbar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showPrivacyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Privacy First',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          '🔒 Your data never leaves your device\n\n'
          '• All data is stored locally using Isar database\n'
          '• No cloud sync or third-party servers\n'
          '• ML learning happens on-device\n'
          '• Backups are stored in your app\'s private directory\n\n'
          'We believe your productivity data is personal and should stay with you.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
