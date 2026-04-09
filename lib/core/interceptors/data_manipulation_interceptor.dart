import "package:dio/dio.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/utils/app_logger.dart";

class DataManipulationInterceptor extends Interceptor {
  final _log = const AppLogger(DataManipulationInterceptor);
  final Ref _ref;
  final DeviceInfoState _deviceInfoState;

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
        _deviceInfoState.getDeviceIP(),
        _deviceInfoState.getDeviceId(),
      ]);

      final deviceName = results[0];
      final deviceIP = results[1];
      final deviceId = results[2];

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
    } else {
      // FirebaseCrashlytics.instance.recordError(
      //   err,
      //   err.stackTrace,
      //   reason:
      //       "API ${err.requestOptions.method} ${err.requestOptions.uri.path} "
      //       "— ${err.response?.statusCode}",
      // );
    }

    // if (err.response?.statusCode == 401) {
    //   final isOnOnboarding =
    //       RouteLifecycleObserver
    //           .routeObserver
    //           .activeRoutes
    //           .first
    //           .settings
    //           .name ==
    //       OnboardingView.path;

    //   if (!isOnOnboarding) {
    //     // Logout user: clear cache and navigate to login
    //     _performLogout();

    //     MobileNavigationService.instance.navigateAndClearStack(
    //       OnboardingView.path,
    //     );

    //     throw Exception("Unauthenticated");
    //   }
    //   // When on onboarding (e.g. login/verify OTP), do not logout; let the
    //   // error propagate so the view can dismiss loading and show the message.
    // }

    if (err.response?.data != null) {
      // _handleVerificationEvents(err.response!.data);
    }
    // checkIfAppUpdateRequired(err.response?.data);

    handler.next(err);
  }

  /// Clears user session data when unauthorized.
  Future<void> _performLogout() async {
    try {
      // await _ref.read(authRepoProvider).logout();

      // // Clear in-memory state
      // _ref.read(userStateProvider).logOut();
      // _ref.read(userPreferencesStateProvider).logOut();
      // _ref.read(kycStatusStateProvider).logOut();
      // _ref.read(tradeAssetsStateProvider).logOut();
      // _ref.read(withdrawalStateProvider).logOut();
      // _ref.read(reportStateProvider).logOut();
      // _ref.read(tradingRateStateProvider).logOut();
      // _ref.read(banksStateProvider).logOut();
      // _ref.read(transactionStateProvider).logOut();

      _log.i("User session cleared due to 401 Unauthorized");
    } catch (e) {
      _log.e("Error clearing session: $e");
    }
  }

  // void _handleVerificationEvents(dynamic data) {
  //   _ref
  //       .read(verificationEventStateProvider)
  //       .setEvent((data as Map<String, dynamic>?)?["event"] as String?);
  // }

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
