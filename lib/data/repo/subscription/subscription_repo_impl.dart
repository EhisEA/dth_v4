import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/data/models/subscription_model.dart';
import 'package:dth_v4/data/repo/subscription/subscription_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

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
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepo>((ref) {
  return SubscriptionRepoImpl(networkService: ref.read(networkServiceProvider));
});
