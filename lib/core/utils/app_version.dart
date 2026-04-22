import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  static String? _cachedVersion;

  /// Call this in main() before runApp() to load version from the platform.
  static Future<void> init() async {
    try {
      final info = await PackageInfo.fromPlatform();
      print("Package Info: $info");
      _cachedVersion = info.buildNumber.isNotEmpty && info.buildNumber != "0"
          ? info.version
          : info.version;
    } catch (_) {
      _cachedVersion = null;
    }
  }

  static String get appVersion => _cachedVersion ?? "1.0.0";

  static String getAppVersionSync() {
    print("cachedVersion: $_cachedVersion, appVersion: $appVersion");
    return appVersion;
  }
}
