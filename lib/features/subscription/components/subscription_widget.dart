import "package:carousel_slider/carousel_slider.dart";
import "package:dth_v4/core/router/router.dart";
import "package:dth_v4/data/models/subscription_model.dart";
import "package:dth_v4/features/subscription/subscription.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_utils/flutter_utils.dart";

/// Vertical budget for one plan card (tuned to match layout).
double _estimatedPlanCardHeight(SubscriptionModel plan, double textScale) {
  const outerPadding = 8.0;
  const whiteCardBlock = 210.0;
  const belowCard = 16.0 + 18.0 + 2.0;
  const perPerkRow = 38.0;
  const safety = 18.0;
  final perkCount = featureLines(plan).length;
  final raw =
      outerPadding +
      whiteCardBlock +
      belowCard +
      perkCount * perPerkRow +
      safety;
  return (raw * textScale).clamp(260.0, 900.0);
}

class SubscriptionPlanCarousel extends StatefulWidget {
  const SubscriptionPlanCarousel({super.key, required this.plans});

  final List<SubscriptionModel> plans;

  @override
  State<SubscriptionPlanCarousel> createState() =>
      _SubscriptionPlanCarouselState();
}

class _SubscriptionPlanCarouselState extends State<SubscriptionPlanCarousel> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final plans = widget.plans;
    final carouselHeight = _estimatedPlanCardHeight(
      plans[_pageIndex],
      textScale,
    ).clamp(260.0, h * 0.58);

    return CarouselSlider.builder(
      itemCount: plans.length,
      itemBuilder: (context, index, realIndex) {
        return SubscriptionPlanCard(
          plan: plans[index],
          onCTATap: () {
            MobileNavigationService.instance.push(
              ConfirmationView.path,
              extra: {RoutingArgumentKey.confirmationSuccess: true},
            );
            HapticFeedback.lightImpact();
          },
        );
      },
      options: CarouselOptions(
        height: carouselHeight,
        viewportFraction: 0.90,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        padEnds: true,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          if (index != _pageIndex) {
            setState(() => _pageIndex = index);
          }
        },
      ),
    );
  }
}