import 'package:dth_v4/data/data.dart';

abstract class SubscriptionRepo {
  Future<List<SubscriptionModel>> fetchSubscriptionPlans();
}
