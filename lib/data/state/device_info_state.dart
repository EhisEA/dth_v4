import "package:dart_ipify/dart_ipify.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:dth_v4/data/state/base_state.dart";

class DeviceInfoState extends BaseState {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  String? _deviceName;
  String? _deviceIP;
  String? _deviceId;

  Future<void>? _initFuture;

  /// Lazily initialises all device info fields on first call.
  /// Concurrent callers share the same future. On failure the future resets
  /// so the next call retries.
  Future<void> ensureInitialized() => _initFuture ??= _doInit();

  Future<void> _doInit() async {
    try {
      final results = await Future.wait([
        _getDeviceName(),
        _getDeviceIP(),
        _getDeviceId(),
      ]);
      _deviceName = results[0];
      _deviceIP = results[1];
      _deviceId = results[2];
    } catch (e) {
      _initFuture = null; // allow retry on next call
      rethrow;
    }
  }

  Future<String> getDeviceName() async {
    await ensureInitialized();
    return _deviceName!;
  }

  Future<String> getDeviceIP() async {
    await ensureInitialized();
    return _deviceIP!;
  }

  Future<String> getDeviceId() async {
    await ensureInitialized();
    return _deviceId!;
  }

  Future<String> _getDeviceIP() async {
    return await Ipify.ipv4();
  }

  Future<String> _getDeviceName() async {
    if (kIsWeb) {
      final webInfo = await _deviceInfo.webBrowserInfo;
      return webInfo.browserName.name;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.model;
      case TargetPlatform.iOS:
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.utsname.machine;
      default:
        return "";
    }
  }

  Future<String> _getDeviceId() async {
    if (kIsWeb) {
      final webInfo = await _deviceInfo.webBrowserInfo;
      return webInfo.userAgent ?? "";
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      case TargetPlatform.iOS:
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? "";
      default:
        return "";
    }
  }
}

final deviceInfoStateProvider = Provider((ref) {
  final state = DeviceInfoState();
  ref.onDispose(() {});
  return state;
});
