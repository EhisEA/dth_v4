import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/data/repo/auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

class AuthRepoImpl implements AuthRepo {
  final NetworkService _networkService;
  AuthRepoImpl({required NetworkService networkService})
    : _networkService = networkService;

  @override
  Future<ApiResponse<UserModel>> getUserData() async {
    final response = await _networkService.get(ApiRoute.user);
    return ApiResponse(
      data: UserModel.fromJson(
        (response.data as Map<String, dynamic>)["data"] as Map<String, dynamic>,
      ),
    );
  }
}

final authRepositoryProvider = Provider<AuthRepo>((ref) {
  return AuthRepoImpl(networkService: ref.read(networkServiceProvider));
});
