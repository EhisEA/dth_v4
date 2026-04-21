import "dart:async";

import "package:dth_v4/core/core.dart";
import "package:dth_v4/core/router/router.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/subscription/components/subscription_widget.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class SubscriptionView extends ConsumerStatefulWidget {
  const SubscriptionView({super.key});

  static const String path = NavigatorRoutes.subscription;

  @override
  ConsumerState<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends ConsumerState<SubscriptionView> {
  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionPlansStateProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageAssets.subscriptionBg),
            fit: BoxFit.fill,
          ),
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            subscriptionState.plans,
            subscriptionState.fetchFailed,
          ]),
          builder: (context, _) {
            final failed = subscriptionState.fetchFailed.value;
            final plans = subscriptionState.plans.value;

            if (failed && plans == null) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText.regular(
                        "Could not load subscription plans.",
                        fontSize: 14,
                        color: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                      Gap.h16,
                      AppButton(
                        press: () => unawaited(subscriptionState.fetchPlans()),
                        text: "Retry",
                        color: AppColors.white,
                        height: 48,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (plans == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (plans.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AppText.regular(
                    "No subscription plans are available right now.",
                    fontSize: 14,
                    color: AppColors.black,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SubscriptionPlansList(plans: plans),
              ),
            );
          },
        ),
      ),
    );
  }
}
