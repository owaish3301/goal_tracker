import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/app_update_service.dart';
import '../theme/app_colors.dart';

/// Provider for the app update service
final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService();
});

/// Provider for checking updates
final updateCheckProvider = FutureProvider.autoDispose<UpdateInfo?>((
  ref,
) async {
  final service = ref.read(appUpdateServiceProvider);
  return service.checkForUpdate();
});

/// A dialog that shows update availability and handles download/install
class UpdateDialog extends ConsumerStatefulWidget {
  final UpdateInfo updateInfo;

  const UpdateDialog({super.key, required this.updateInfo});

  @override
  ConsumerState<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends ConsumerState<UpdateDialog> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _downloadedFilePath;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.system_update,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Update Available',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Version info
            _buildVersionRow(
              'Current Version',
              widget.updateInfo.currentVersion,
              AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            _buildVersionRow(
              'New Version',
              widget.updateInfo.latestVersion,
              AppColors.primary,
            ),
            const SizedBox(height: 8),
            _buildVersionRow(
              'Download Size',
              widget.updateInfo.formattedFileSize,
              AppColors.textSecondary,
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.surfaceDark),
            const SizedBox(height: 16),

            // Release notes
            const Text(
              "What's New",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(maxHeight: 150),
              child: SingleChildScrollView(
                child: Text(
                  widget.updateInfo.releaseNotes,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ),

            // Download progress
            if (_isDownloading) ...[
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Downloading...',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${(_downloadProgress * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _downloadProgress,
                      backgroundColor: AppColors.surfaceDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ],

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isDownloading ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Later',
            style: TextStyle(
              color: _isDownloading
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
          ),
        ),
        if (_downloadedFilePath != null)
          ElevatedButton.icon(
            onPressed: _installUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.install_mobile, size: 18),
            label: const Text('Install'),
          )
        else
          ElevatedButton.icon(
            onPressed: _isDownloading ? null : _downloadUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: _isDownloading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.download, size: 18),
            label: Text(_isDownloading ? 'Downloading...' : 'Download'),
          ),
      ],
    );
  }

  Widget _buildVersionRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _downloadUpdate() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _errorMessage = null;
    });

    final service = ref.read(appUpdateServiceProvider);
    final filePath = await service.downloadUpdate(
      widget.updateInfo,
      onProgress: (received, total) {
        if (total > 0) {
          setState(() {
            _downloadProgress = received / total;
          });
        }
      },
    );

    if (filePath != null) {
      setState(() {
        _isDownloading = false;
        _downloadedFilePath = filePath;
      });
    } else {
      setState(() {
        _isDownloading = false;
        _errorMessage = 'Failed to download update. Please try again.';
      });
    }
  }

  Future<void> _installUpdate() async {
    if (_downloadedFilePath == null) return;

    final service = ref.read(appUpdateServiceProvider);
    final success = await service.installUpdate(_downloadedFilePath!);

    if (!success && mounted) {
      setState(() {
        _errorMessage = 'Failed to open installer. Please install manually.';
      });
    }
  }
}

/// Helper function to show the update dialog
Future<void> showUpdateDialog(BuildContext context, UpdateInfo updateInfo) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => UpdateDialog(updateInfo: updateInfo),
  );
}

/// Helper function to check for updates and show dialog if available
Future<void> checkAndShowUpdateDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final updateInfo = await ref.read(updateCheckProvider.future);
  if (updateInfo != null && context.mounted) {
    await showUpdateDialog(context, updateInfo);
  }
}
