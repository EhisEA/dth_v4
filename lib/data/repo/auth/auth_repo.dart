import 'package:dth_v4/data/data.dart';
import 'package:flutter_utils/flutter_utils.dart';

abstract class AuthRepo {
  Future<ApiResponse<UserModel>> getUserData();

  Future<ApiResponse<RegisterInitResult>> register({
    required String fullName,
    required String email,
    required String deviceName,
  });

  Future<ApiResponse<RegistrationCompleteResult>> verifyRegisterOtp({
    required String otp,
    required String signature,
  });
}
