import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/data/repo/auth/auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({
    required NetworkService networkService,
    required LocalCache localCache,
  }) : _networkService = networkService,
       _localCache = localCache;

  final NetworkService _networkService;
  final LocalCache _localCache;

  void _updateNetworkToken(String? token) {
    _networkService.accessToken = token;
  }

  Future<void> _clearLocalAuthState() async {
    await _localCache.deleteToken();
    await _localCache.removeFromLocalCache(CacheKeys.user);
    _updateNetworkToken(null);
  }

  @override
  Future<ApiResponse<UserModel>> getUserData() async {
    final response = await _networkService.get(ApiRoute.user);
    final data = response.data as Map<String, dynamic>;
    return ApiResponse(data: UserModel.fromJson(data["data"]["user"]));
  }

  @override
  Future<void> clearLocalAuthSession() => _clearLocalAuthState();

  @override
  Future<ApiResponse<RegisterInitResult>> register({
    required String fullName,
    required String email,
    required String deviceName,
  }) async {
    final response = await _networkService.post(
      ApiRoute.register,
      data: {"full_name": fullName, "email": email, "device_name": deviceName},
    );
    final data =
        (response.data as Map<String, dynamic>)["data"] as Map<String, dynamic>;
    return ApiResponse(data: RegisterInitResult.fromJson(data));
  }

  @override
  Future<ApiResponse<RegistrationCompleteResult>> verifyRegisterOtp({
    required String otp,
    required String signature,
  }) async {
    final response = await _networkService.post(
      ApiRoute.registerVerifyOtp,
      data: {"token": otp, "signature": signature},
    );
    final data = (response.data as Map<String, dynamic>)["data"];
    final result = RegistrationCompleteResult.fromJson(data);

    await _localCache.saveToken(result.token);
    await _localCache.saveUserData(result.user.toJson());
    _updateNetworkToken(result.token);

    return ApiResponse(data: result);
  }

  @override
  Future<ApiResponse<RegisterInitResult>> login({
    required String email,
    required String deviceName,
  }) async {
    final response = await _networkService.post(
      ApiRoute.login,
      data: {"email": email, "device_name": deviceName},
    );
    final data =
        (response.data as Map<String, dynamic>)["data"] as Map<String, dynamic>;
    return ApiResponse(data: RegisterInitResult.fromJson(data));
  }

  @override
  Future<ApiResponse<RegistrationCompleteResult>> verifyLoginOtp({
    required String otp,
    required String signature,
  }) async {
    final response = await _networkService.post(
      ApiRoute.loginVerifyOtp,
      data: {"token": otp, "signature": signature},
    );
    final data =
        (response.data as Map<String, dynamic>)["data"] as Map<String, dynamic>;
    final result = RegistrationCompleteResult.fromJson(data);

    await _localCache.saveToken(result.token);
    await _localCache.saveUserData(result.user.toJson());
    _updateNetworkToken(result.token);

    return ApiResponse(data: result);
  }

  @override
  Future<ApiResponse<void>> logout() async {
    try {
      if (_networkService.accessToken != null) {
        await _networkService.post(ApiRoute.logout, data: <String, dynamic>{});
      }
    } on Object {
      // Best-effort revoke; still clear local session.
    }
    await _clearLocalAuthState();
    return const ApiResponse<void>();
  }
}

final authRepositoryProvider = Provider<AuthRepo>((ref) {
  return AuthRepoImpl(
    networkService: ref.read(networkServiceProvider),
    localCache: ref.read(localCacheProvider),
  );
});
