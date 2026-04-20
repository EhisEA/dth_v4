import "package:dth_v4/data/models/subscription_model.dart";
import "package:dth_v4/data/repo/subscription/subscription_repo.dart";
import "package:dth_v4/data/repo/subscription/subscription_repo_impl.dart";
import "package:dth_v4/data/state/base_state.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class SubscriptionPlansState extends BaseState {
  SubscriptionPlansState(this._repo);

  final SubscriptionRepo _repo;

  final ValueNotifier<List<SubscriptionModel>?> plans = ValueNotifier(null);
  final ValueNotifier<bool> fetchFailed = ValueNotifier(false);

  Future<void> fetchPlans() async {
    fetchFailed.value = false;
    try {
      final list = await _repo.fetchSubscriptionPlans();
      list.sort((a, b) => a.order.compareTo(b.order));
      plans.value = list;
    } catch (e) {
      fetchFailed.value = true;
      handleError(e, "fetchPlans");
    }
  }

  @override
  void dispose() {
    plans.dispose();
    fetchFailed.dispose();
  }
}

final subscriptionPlansStateProvider = Provider<SubscriptionPlansState>((ref) {
  final state = SubscriptionPlansState(
    ref.read(subscriptionRepositoryProvider),
  );
  ref.onDispose(state.dispose);
  return state;
});
