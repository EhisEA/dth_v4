import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/widgets/text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

class ApplicationWidget extends StatelessWidget {
  const ApplicationWidget({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueGrey, Colors.deepPurple],
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(SvgAssets.apply),
            Gap.w16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.semiBold(
                    "Applicant Dashboard",
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                  AppText.regular(
                    "Track the progress of your application.",
                    fontSize: 11,
                    color: AppColors.greyTint35,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              SvgAssets.rightArrow,
              colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
