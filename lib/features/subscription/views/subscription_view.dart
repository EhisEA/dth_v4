import "package:dth_v4/core/core.dart";
import "package:dth_v4/core/router/router.dart";
import "package:flutter/material.dart";
import "package:dth_v4/features/subscription/subscription.dart";

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  static const String path = NavigatorRoutes.subscription;

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(top: false, child: SubscriptionPlanCarousel()),
            ),
          ],
        ),
      ),
    );
  }
}
