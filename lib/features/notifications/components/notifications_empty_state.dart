import "package:dth_v4/core/core.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      illustration: _PlaceholderIllustration(),
      title: "Nothing New Right Now",
      subtitle:
          "You're all caught up. New notifications about your activity will appear here.",
      showDashedDivider: false,
      cardDecoration: null,
      cardPadding: EdgeInsets.zero,
      outerPadding: const EdgeInsets.symmetric(horizontal: 24),
      titleFontSize: 14,
      titleColor: AppColors.mainBlack,
      subtitleFontSize: 12,
      subtitleColor: AppColors.blackTint20,
      gapAfterIllustration: 16,
    );
  }
}

class _PlaceholderIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.greyTint20,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.tint5,
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 24,
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.tint15,
                shape: BoxShape.circle,
              ),
              child: AppText.semiBold(
                "0",
                fontSize: 12,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
