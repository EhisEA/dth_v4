import 'package:dth_v4/data/data.dart';
import 'package:flutter_utils/flutter_utils.dart';

abstract class AuthRepo {
  Future<ApiResponse<UserModel>> getUserData();

  Future<ApiResponse<RegisterInitResult>> register({
    required String fullName,
    required String email,
    required String isoCode,
    required String phone,
    required String deviceName,
  });

  Future<ApiResponse<RegistrationCompleteResult>> verifyRegisterOtp({
    required String otp,
    required String signature,
    required String fcmToken,
  });

  Future<ApiResponse<RegisterInitResult>> login({
    required String email,
    required String deviceName,
  });

  Future<ApiResponse<RegisterInitResult>> resendRegisterOtp({
    required String email,
    required String deviceName,
  });

  Future<ApiResponse<RegisterInitResult>> resendLoginOtp({
    required String email,
    required String deviceName,
  });

  Future<ApiResponse<RegistrationCompleteResult>> verifyLoginOtp({
    required String otp,
    required String signature,
    required String fcmToken,
  });

  Future<ApiResponse<RegistrationCompleteResult>> loginWithGoogle({
    required String idToken,
    required String deviceName,
    required String fcmToken,
    String? fullName,
  });

  /// Revokes the session on the server (best effort) and clears local auth state.
  Future<ApiResponse<void>> logout();

  /// Clears token, cached user, and in-memory bearer token without calling the API.
  Future<void> clearLocalAuthSession();
}
