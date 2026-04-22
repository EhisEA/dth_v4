import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class AppModulesRepoImpl implements AppModulesRepo {
  AppModulesRepoImpl({required NetworkService networkService})
    : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<ApiResponse<AppModulesModel>> getAppModules() async {
    final response = await _networkService.get(ApiRoute.mobileAppModules);
    final root = response.data as Map<String, dynamic>;
    final data = root["data"];
    return ApiResponse(data: AppModulesModel.fromJson(data));
  }
}

final appModulesRepositoryProvider = Provider<AppModulesRepo>((ref) {
  return AppModulesRepoImpl(networkService: ref.read(networkServiceProvider));
});
