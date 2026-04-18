import "dart:math" as math;

import "package:carousel_slider/carousel_slider.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/subscription/models/subscription_plan_mock.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

/// Rough vertical budget for one plan card (outer padding + white block + perks block).
double _estimatedPlanCardHeight(SubscriptionPlanMock plan) {
  const outerPadding = 8.0;
  const whiteCardBlock = 236.0;
  const belowCard = 16.0 + 22.0 + 12.0;
  const bottomPadding = 20.0;
  const perPerkRow = 54.0;
  return outerPadding +
      whiteCardBlock +
      belowCard +
      plan.perks.length * perPerkRow +
      bottomPadding;
}

class SubscriptionPlanCarousel extends StatelessWidget {
  SubscriptionPlanCarousel({super.key, List<SubscriptionPlanMock>? plans})
    : plans = plans ?? kMockSubscriptionPlans;

  final List<SubscriptionPlanMock> plans;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final tallest = plans
        .map(_estimatedPlanCardHeight)
        .fold(0.0, (a, b) => math.max(a, b));
    final carouselHeight = tallest.clamp(300.0, h * 0.62);

    return CarouselSlider.builder(
      itemCount: plans.length,
      itemBuilder: (context, index, realIndex) {
        return SubscriptionPlanCard(plan: plans[index]);
      },
      options: CarouselOptions(
        height: carouselHeight,
        viewportFraction: 0.90,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        padEnds: true,
        enableInfiniteScroll: false,
      ),
    );
  }
}

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({super.key, required this.plan});

  final SubscriptionPlanMock plan;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.greyTint15,
          border: Border.all(color: AppColors.greyTint30),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.greyTint35),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: plan.badgeBackground,
                        borderRadius: BorderRadius.circular(500),
                      ),
                      child: AppText.semiBold(
                        plan.badgeLabel,
                        fontSize: 8,
                        letterSpacing: 0.5,
                        color: AppColors.white,
                      ),
                    ),
                    Gap.h16,
                    AppText.regular(
                      plan.planTitle,
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                    Gap.h2,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        AppText.matterBold(
                          "₦",
                          fontSize: 14,
                          color: AppColors.mainBlack,
                          height: 0,
                        ),
                        AppText.matterBold(
                          plan.priceLabel,
                          fontSize: 26,
                          color: AppColors.mainBlack,
                          height: 0,
                        ),

                        AppText.regular(
                          plan.periodLabel,
                          fontSize: 12,
                          color: AppColors.tint15,
                        ),
                      ],
                    ),
                    Gap.h16,
                    AppButton.onBorder(
                      press: () {},
                      text: plan.ctaLabel,
                      height: 48,
                    ),
                  ],
                ),
              ),
              Gap.h16,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppText.regular(
                  "What's included",
                  fontSize: 12,
                  color: AppColors.tint25,
                ),
              ),
              Gap.h12,
              ...plan.perks.map(
                (line) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(SvgAssets.check),
                      Gap.w12,
                      Expanded(
                        child: AppText.regular(
                          line,
                          fontSize: 13,
                          color: AppColors.black,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
