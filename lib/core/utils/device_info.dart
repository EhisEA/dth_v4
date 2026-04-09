// import 'dart:io';
// import 'package:dart_ipify/dart_ipify.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:vent/data/state/base_state.dart';

// class DeviceInfo extends BaseState {
//   final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
//   String? deviceName;
//   String? deviceIP;
//   String? deviceId;

//   static final DeviceInfo _instance = DeviceInfo();
//   static DeviceInfo get instance => _instance;
//   DeviceInfo() {
//     init();
//   }

//   Future<String> getDeviceName() async {
//     return deviceName ?? await _getDeviceName();
//   }

//   Future<String> getDeviceIP() async {
//     return deviceIP ?? await _getDeviceIP();
//   }

//   Future<String> getDeviceId() async {
//     return deviceId ?? await _getDeviceId();
//   }

//   Future<void> init() async {
//     deviceName = await _getDeviceName();
//     deviceIP = await _getDeviceIP();
//     deviceId = await _getDeviceId();
//   }

//   Future<String> _getDeviceIP() async {
//     return await Ipify.ipv4();
//   }

//   Future<String> _getDeviceName() async {
//     if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
//       return androidInfo.model; // e.g. "Moto G (4)"
//     } else if (Platform.isIOS) {
//       IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
//       return iosInfo.utsname.machine; // e.g. "iPod7,1"
//     }
//     return "";
//   }

//   Future<String> _getDeviceId() async {
//     if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
//       return androidInfo.id; // e.g. "Moto G (4)"
//     } else if (Platform.isIOS) {
//       IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
//       return iosInfo.identifierForVendor ?? ""; // e.g. "iPod7,1"
//     }
//     return "";
//   }
// }
