import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class SubscriptionRepoImpl implements SubscriptionRepo {
  SubscriptionRepoImpl({required NetworkService networkService})
    : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<List<SubscriptionModel>> fetchSubscriptionPlans() async {
    final response = await _networkService.get(ApiRoute.subscriptionPlans);
    final data = response.data["data"]["plans"];
    if (data is! List<dynamic>) {
      return [];
    }
    return data
        .map(
          (e) =>
              SubscriptionModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  @override
  Future<ApiResponse<SubscriptionPurchaseInit>> purchaseSubscription({
    required String planUid,
  }) async {
    final response = await _networkService.post(
      ApiRoute.subscriptionPurchase,
      data: {"plan_uid": planUid},
    );
    final root = response.data as Map<String, dynamic>;
    final data = root["data"];
    if (data is! Map<String, dynamic>) {
      return const ApiResponse(data: null);
    }
    return ApiResponse(data: SubscriptionPurchaseInit.fromJson(data));
  }

  @override
  Future<ApiResponse<void>> verifyPayment({required String reference}) async {
    await _networkService.get(ApiRoute.paymentVerify(reference));
    return const ApiResponse();
  }
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepo>((ref) {
  return SubscriptionRepoImpl(networkService: ref.read(networkServiceProvider));
});
