import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

/// Service for checking and downloading app updates from GitHub releases
class AppUpdateService {
  static const String _githubOwner = 'owaish3301';
  static const String _githubRepo = 'goal_tracker';
  static const String _githubApiUrl =
      'https://api.github.com/repos/$_githubOwner/$_githubRepo/releases/latest';

  final Dio _dio = Dio();

  /// Represents the result of an update check
  UpdateInfo? _cachedUpdateInfo;

  /// Get the current app version
  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Get the current app build number
  Future<String> getCurrentBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  /// Check if an update is available
  /// Returns UpdateInfo if update is available, null otherwise
  Future<UpdateInfo?> checkForUpdate({bool forceCheck = false}) async {
    if (_cachedUpdateInfo != null && !forceCheck) {
      return _cachedUpdateInfo;
    }

    try {
      final response = await _dio.get(
        _githubApiUrl,
        options: Options(headers: {'Accept': 'application/vnd.github.v3+json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final latestVersion = _parseVersion(data['tag_name'] as String);
        final currentVersion = await getCurrentVersion();

        if (_isNewerVersion(latestVersion, currentVersion)) {
          final assets = data['assets'] as List<dynamic>;
          final apkAsset = _findSuitableApk(assets);

          if (apkAsset != null) {
            _cachedUpdateInfo = UpdateInfo(
              currentVersion: currentVersion,
              latestVersion: latestVersion,
              releaseNotes:
                  data['body'] as String? ?? 'Bug fixes and improvements',
              downloadUrl: apkAsset['browser_download_url'] as String,
              fileSize: apkAsset['size'] as int,
              fileName: apkAsset['name'] as String,
              releaseDate: DateTime.parse(data['published_at'] as String),
            );
            return _cachedUpdateInfo;
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }

    return null;
  }

  /// Download the update APK with progress callback
  Future<String?> downloadUpdate(
    UpdateInfo updateInfo, {
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${updateInfo.fileName}';

      // Delete existing file if present
      final existingFile = File(filePath);
      if (await existingFile.exists()) {
        await existingFile.delete();
      }

      await _dio.download(
        updateInfo.downloadUrl,
        filePath,
        onReceiveProgress: onProgress,
      );

      return filePath;
    } catch (e) {
      debugPrint('Error downloading update: $e');
      return null;
    }
  }

  /// Install the downloaded APK
  /// Note: After calling this, the app will close for installation.
  /// The APK cleanup happens on next app start via cleanupOldDownloads()
  Future<bool> installUpdate(String filePath) async {
    try {
      final result = await OpenFilex.open(filePath);
      if (result.type == ResultType.done) {
        // Clear cache so we don't prompt again after update
        clearCache();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error installing update: $e');
      return false;
    }
  }

  /// Clean up any previously downloaded APK files
  /// Call this on app startup to remove leftover update files
  Future<void> cleanupOldDownloads() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();

      for (final file in files) {
        if (file is File && file.path.endsWith('.apk')) {
          await file.delete();
          debugPrint('Cleaned up old APK: ${file.path}');
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up old downloads: $e');
    }
  }

  /// Parse version from tag (e.g., "v1.0.4.1" -> "1.0.4.1")
  String _parseVersion(String tag) {
    return tag.replaceFirst(RegExp(r'^v'), '');
  }

  /// Compare versions to check if latest is newer
  bool _isNewerVersion(String latest, String current) {
    final latestParts = latest
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
    final currentParts = current
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    // Pad shorter version with zeros
    while (latestParts.length < 4) {
      latestParts.add(0);
    }
    while (currentParts.length < 4) {
      currentParts.add(0);
    }

    for (int i = 0; i < 4; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }

    return false; // Versions are equal
  }

  /// Find the most suitable APK for the current device
  Map<String, dynamic>? _findSuitableApk(List<dynamic> assets) {
    // Get device architecture
    final deviceAbi = _getDeviceAbi();

    // Priority order: device-specific APK > universal APK
    final assetMap = <String, Map<String, dynamic>>{};

    for (final asset in assets) {
      final name = asset['name'] as String;
      if (name.endsWith('.apk')) {
        assetMap[name] = asset as Map<String, dynamic>;
      }
    }

    // Try to find architecture-specific APK first
    if (deviceAbi != null) {
      for (final name in assetMap.keys) {
        if (name.contains(deviceAbi)) {
          return assetMap[name];
        }
      }
    }

    // Fall back to universal APK
    for (final name in assetMap.keys) {
      if (name == 'app-release.apk') {
        return assetMap[name];
      }
    }

    // Return any APK if nothing else matches
    return assetMap.values.firstOrNull;
  }

  /// Get the device's ABI (architecture)
  String? _getDeviceAbi() {
    if (Platform.isAndroid) {
      // Common Android ABIs
      // Most modern phones: arm64-v8a
      // Older phones: armeabi-v7a
      // Emulators/Chromebooks: x86_64

      // On Android, we can check supported ABIs through a method channel
      // For now, we'll prioritize arm64-v8a as most devices use it
      return 'arm64-v8a';
    }
    return null;
  }

  /// Clear cached update info
  void clearCache() {
    _cachedUpdateInfo = null;
  }
}

/// Information about an available update
class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String releaseNotes;
  final String downloadUrl;
  final int fileSize;
  final String fileName;
  final DateTime releaseDate;

  UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.releaseNotes,
    required this.downloadUrl,
    required this.fileSize,
    required this.fileName,
    required this.releaseDate,
  });

  /// Get file size in MB
  double get fileSizeMB => fileSize / (1024 * 1024);

  /// Get formatted file size string
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    }
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${fileSizeMB.toStringAsFixed(1)} MB';
  }
}
