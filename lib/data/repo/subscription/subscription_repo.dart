import "package:dth_v4/data/models/model.dart";
import "package:flutter_utils/flutter_utils.dart";

abstract class SubscriptionRepo {
  Future<List<SubscriptionModel>> fetchSubscriptionPlans();

  Future<ApiResponse<SubscriptionPurchaseInit>> purchaseSubscription({
    required String planUid,
  });

  Future<ApiResponse<void>> verifyPayment({required String reference});
}
