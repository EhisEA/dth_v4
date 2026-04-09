import "package:dth_v4/core/utils/utils.dart";
import "package:flutter/foundation.dart";

class AppConstants {}

class AppLink {
  static const String privacyPolicy = "https://dth.ng/#";
  static const String termsAndConditions = "https://dth.ng/#";
}

class AppInfo {
  // static String get appVersion => "";
  static String get deviceOS {
    if (kIsWeb) return "web";
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return "ios";
      case TargetPlatform.android:
        return "android";
      default:
        return "UNSET";
    }
  }

  /// Gets the actual app version from the device
  // static Future<String> getAppVersion() async {
  //   return await AppVersion.getAppVersion();
  // }

  /// Gets the app version synchronously (returns cached value or fallback)
  static String getAppVersionSync() {
    return AppVersion.getAppVersionSync();
  }

  static Map<String, dynamic> get payload {
    return {
      "x-Device-OS": deviceOS,
      "X-App-Version": getAppVersionSync(),
      // appVersion,
    };
  }
}
