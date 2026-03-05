import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateResult {
  final bool required;
  final String storeUrl;

  const ForceUpdateResult({required this.required, required this.storeUrl});
}

class ForceUpdateService {
  static const _minVersionKey = 'min_required_version';
  static const _androidUrlKey = 'android_store_url';
  static const _iosUrlKey = 'ios_store_url';

  /// Checks Firebase Remote Config for a minimum required version.
  /// Returns [ForceUpdateResult.required] = false on any error (offline, timeout, etc.)
  /// so the app always works without internet.
  Future<ForceUpdateResult> fetchAndCheck() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 5),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await remoteConfig.fetchAndActivate();

      final minVersion = remoteConfig.getString(_minVersionKey);
      if (minVersion.isEmpty) return const ForceUpdateResult(required: false, storeUrl: '');

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (_isUpdateRequired(currentVersion, minVersion)) {
        final storeUrl = Platform.isIOS
            ? remoteConfig.getString(_iosUrlKey)
            : remoteConfig.getString(_androidUrlKey);
        return ForceUpdateResult(required: true, storeUrl: storeUrl);
      }

      return const ForceUpdateResult(required: false, storeUrl: '');
    } catch (_) {
      // No internet, Firebase not configured, or any other error — let the user through
      return const ForceUpdateResult(required: false, storeUrl: '');
    }
  }

  /// Returns true if [current] is strictly less than [minimum].
  /// Compares major.minor.patch tuples.
  bool _isUpdateRequired(String current, String minimum) {
    final c = _parseVersion(current);
    final m = _parseVersion(minimum);
    if (c == null || m == null) return false;
    for (int i = 0; i < 3; i++) {
      if (c[i] < m[i]) return true;
      if (c[i] > m[i]) return false;
    }
    return false; // equal — no update needed
  }

  List<int>? _parseVersion(String version) {
    // Strip build metadata (e.g. "1.2.3+4" → "1.2.3")
    final clean = version.split('+').first.trim();
    final parts = clean.split('.');
    if (parts.length < 3) return null;
    final nums = parts.take(3).map((p) => int.tryParse(p) ?? 0).toList();
    return nums;
  }
}
