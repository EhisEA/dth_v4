import "package:carousel_slider/carousel_slider.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/core/router/router.dart";
import "package:dth_v4/features/subscription/subscription.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

/// Vertical budget for one plan card (tuned to match layout).
double _estimatedPlanCardHeight(SubscriptionPlanMock plan, double textScale) {
  const outerPadding = 8.0;
  const whiteCardBlock = 210.0;
  const belowCard = 16.0 + 18.0 + 2.0;
  const perPerkRow = 38.0;
  const safety = 18.0;
  final raw =
      outerPadding +
      whiteCardBlock +
      belowCard +
      plan.perks.length * perPerkRow +
      safety;
  return (raw * textScale).clamp(260.0, 900.0);
}

class SubscriptionPlanCarousel extends StatefulWidget {
  const SubscriptionPlanCarousel({super.key, this.plans});

  final List<SubscriptionPlanMock>? plans;

  @override
  State<SubscriptionPlanCarousel> createState() =>
      _SubscriptionPlanCarouselState();
}

class _SubscriptionPlanCarouselState extends State<SubscriptionPlanCarousel> {
  late final List<SubscriptionPlanMock> _plans =
      widget.plans ?? kMockSubscriptionPlans;
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final carouselHeight = _estimatedPlanCardHeight(
      _plans[_pageIndex],
      textScale,
    ).clamp(260.0, h * 0.58);

    return CarouselSlider.builder(
      itemCount: _plans.length,
      itemBuilder: (context, index, realIndex) {
        return SubscriptionPlanCard(
          plan: _plans[index],
          onCTATap: () {
            MobileNavigationService.instance.push(
              ConfirmationView.path,
              extra: {
                RoutingArgumentKey.confirmationSuccess:
                    _plans[index].confirmationSimulatesSuccess,
              },
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

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.onCTATap,
  });

  final SubscriptionPlanMock plan;
  final VoidCallback onCTATap;

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
            mainAxisSize: MainAxisSize.min,
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
                  mainAxisSize: MainAxisSize.min,
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
                      press: () {
                        onCTATap();
                        HapticFeedback.lightImpact();
                      },
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
