import "package:dth_v4/data/data.dart";
import "package:flutter_utils/flutter_utils.dart";

abstract class ProfileRepo {
  Future<ApiResponse<String>> sendPhoneOtp({
    required String phone,
    required String channel,
  });

  Future<ApiResponse<void>> verifyPhoneOtp({
    required String token,
    required String signature,
  });
  
  Future<ApiResponse<UserModel>> updateProfile({
    String? fullName,
    String? phone,
    String? isoCode,
    String? avatarFilePath,
  });
}
