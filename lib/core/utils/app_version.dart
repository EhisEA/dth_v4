import "package:package_info_plus/package_info_plus.dart";

class AppVersion {
  static String _cached = "0.0.0";
  static String _buildNumber = "";

  static Future<void> initialize() async {
    final info = await PackageInfo.fromPlatform();
    _cached = info.version;
    _buildNumber = info.buildNumber;
  }

  static String getAppVersionSync() => _cached;

  static String get buildNumber => _buildNumber;
}
