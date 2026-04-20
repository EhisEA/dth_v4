import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/repo/profile/profile_repo.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl({required NetworkService networkService})
    : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<ApiResponse<String>> sendPhoneOtp({
    required String phone,
    required String channel,
  }) async {
    final response = await _networkService.post(
      ApiRoute.profilePhoneSendOtp,
      data: {"phone": phone, "channel": channel},
    );
    final root = response.data as Map<String, dynamic>;
    final data = root["data"];
    if (data is! Map<String, dynamic>) {
      return const ApiResponse(data: null);
    }
    final sig = data["signature"] as String?;
    return ApiResponse(data: sig);
  }

  @override
  Future<ApiResponse<void>> verifyPhoneOtp({
    required String token,
    required String signature,
  }) async {
    await _networkService.post(
      ApiRoute.profilePhoneVerifyOtp,
      data: {"token": token, "signature": signature},
    );
    return const ApiResponse();
  }
}

final profileRepositoryProvider = Provider<ProfileRepo>((ref) {
  return ProfileRepoImpl(networkService: ref.read(networkServiceProvider));
});
