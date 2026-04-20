import "dart:async";

import "package:dio/dio.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/authentication/views/get_started_view.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/router/route_lifecycle_observer.dart";
import "package:flutter_utils/services/navigation/mobile_navigation_service.dart";
import "package:flutter_utils/utils/app_logger.dart";

class DataManipulationInterceptor extends Interceptor {
  final _log = const AppLogger(DataManipulationInterceptor);
  final Ref _ref;
  final DeviceInfoState _deviceInfoState;
  static bool _handlingLogout = false;

  DataManipulationInterceptor(this._deviceInfoState, {required Ref ref})
    : _ref = ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({
      "Content-Type": "application/json",
      "Accept": "application/json",
      ...AppInfo.payload,
    });

    try {
      // Fetch all device info in parallel
      final results = await Future.wait([
        _deviceInfoState.getDeviceName(),
        _deviceInfoState.getDeviceId(),
      ]);

      final deviceName = results[0];
      final deviceId = results[1];
      final deviceIP = await _deviceInfoState.getDeviceIP();

      // Add device details to request data
      if (options.data is Map<String, dynamic>) {
        options.data = {
          ...(options.data as Map<String, dynamic>),
          "device_name": deviceName,
          "device_ip": deviceIP,
          "device_id": deviceId,
        };
      } else if (options.data is FormData) {
        (options.data as FormData).fields.addAll([
          MapEntry("device_name", deviceName),
          MapEntry("device_ip", deviceIP),
          MapEntry("device_id", deviceId),
        ]);
      }
    } catch (e) {
      _log.e("Error fetching device info: $e");
    }

    handler.next(options); // Proceed with the request
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    // _handleVerificationEvents(response.data);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _log.e(
        "headers: ${err.requestOptions.headers}",
        functionName: "error.headers",
      );
      _log.e("res.data: ${err.response?.data}", functionName: "error.res.data");
      _log.e(
        "req.data: ${err.requestOptions.data}",
        functionName: "error.req.data",
      );
      _log.e("uri: ${err.requestOptions.uri}", functionName: "error.uri");
      _log.e(
        "status: ${err.response?.statusCode}",
        functionName: "error.status",
      );
    }

    if (err.response?.statusCode == 401) {
      if (!_handlingLogout) {
        _handlingLogout = true;

        final routes = RouteLifecycleObserver.routeObserver.activeRoutes;
        final isOnOnboarding =
            routes.isNotEmpty &&
            routes.first.settings.name == GetStartedView.path;

        if (!isOnOnboarding) {
          unawaited(_performLogout());
          MobileNavigationService.instance.navigateAndClearStack(
            GetStartedView.path,
          );
        } else {
          _handlingLogout = false;
        }
      }
      return handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          statusCode: err.response?.statusCode ?? 401,
          data: err.response?.data,
        ),
      );
    }

    // if (err.response?.data != null) {
    //   _handleVerificationEvents(err.response!.data);
    // }
    // checkIfAppUpdateRequired(err.response?.data);

    handler.next(err);
  }

  /// Clears user session data when unauthorized.
  Future<void> _performLogout() async {
    try {
      await _ref.read(authRepositoryProvider).clearLocalAuthSession();
      _ref.read(userStateProvider).logOut();
      _log.i("User session cleared due to 401 Unauthorized");
    } catch (e) {
      _log.e("Error clearing session: $e");
    } finally {
      _handlingLogout = false;
    }
  }

  // void checkIfAppUpdateRequired(dynamic response) {
  //   final responseMap = response as Map<String, dynamic>?;
  //   if (responseMap?["event"] == AppConstants.appUpdateRequired) {
  //     _log.i("== initialiseAppUpdate ==");
  //     final Map<String, dynamic>? data =
  //         responseMap?["data"] as Map<String, dynamic>?;
  //     final appUpdateData = AppUpdateData.fromJson(data ?? {});
  //     _ref.read(appUpdateStateProvider).appUpdateBS(appUpdateData);

  //     // throw UserDefinedException(
  //     //   "App Outdated",
  //     //   "You are required to update your Vent Mobile App to the latest version",
  //     // );
  //   }
  // }
}
