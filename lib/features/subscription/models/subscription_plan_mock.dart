import "package:dth_v4/core/core.dart";
import "package:flutter/material.dart";

/// Static subscription tier for UI mocks (no API).
@immutable
class SubscriptionPlanMock {
  const SubscriptionPlanMock({
    required this.badgeLabel,
    required this.badgeBackground,
    required this.planTitle,
    required this.priceLabel,
    required this.periodLabel,
    required this.ctaLabel,
    required this.perks,
    required this.confirmationSimulatesSuccess,
  });

  final String badgeLabel;
  final Color badgeBackground;
  final String planTitle;
  final String priceLabel;
  final String periodLabel;
  final String ctaLabel;
  final List<String> perks;

  /// Mock only: drives [ConfirmationView] success vs failure illustration.
  final bool confirmationSimulatesSuccess;
}

/// Blue “BEST VALUE”, peach “RECOMMENDED”, neutral Basic — aligned to product mock.
final kMockSubscriptionPlans = <SubscriptionPlanMock>[
  SubscriptionPlanMock(
    badgeLabel: "BEST VALUE",
    badgeBackground: AppColors.secondaryBlue,
    planTitle: "Premium",
    priceLabel: "15,000",
    periodLabel: "/per season",
    ctaLabel: "Upgrade to Premium",
    perks: ["Everything on the Standard Plan", "Access to Live Stream"],
    confirmationSimulatesSuccess: true,
  ),
  SubscriptionPlanMock(
    badgeLabel: "RECOMMENDED",
    badgeBackground: AppColors.secondaryOrange,
    planTitle: "Standard",
    priceLabel: "8,500",
    periodLabel: "/per season",
    ctaLabel: "Upgrade to Standard",
    perks: [
      "Everything on the Basic Plan",
      "Access to Live Stream",
      "200 Weekly Vote Credit",
      "3 Points Per Vote",
    ],
    confirmationSimulatesSuccess: false,
  ),
];
