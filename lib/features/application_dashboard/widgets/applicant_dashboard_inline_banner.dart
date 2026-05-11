import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_utils/flutter_utils.dart";

class ApplicantDashboardInlineBanner extends StatelessWidget {
  const ApplicantDashboardInlineBanner({
    super.key,
    required this.banner,
    required this.backgroundColor,
  });

  final ApplicantDashboardBanner banner;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyTint35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.semiBold(
            banner.title,
            fontSize: 15,
            color: AppColors.black,
            maxLines: 2,
          ),
          if (banner.body.isNotEmpty) ...[
            Gap.h8,
            AppText.regular(
              banner.body,
              fontSize: 13,
              color: AppColors.blackTint20,
              maxLines: 4,
              multiText: true,
            ),
          ],
        ],
      ),
    );
  }
}
