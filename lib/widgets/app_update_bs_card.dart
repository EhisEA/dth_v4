import 'package:dth_v4/core/constants/assets.dart';
import 'package:dth_v4/widgets/app_button.dart';
import 'package:dth_v4/widgets/text/app_text.dart';
import 'package:dth_v4/widgets/text/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/widgets/gap.dart';

class AppUpdateBsCard extends StatelessWidget {
  const AppUpdateBsCard({super.key, required this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: 24,
        ),
        decoration: BoxDecoration(
          color: Color(0xffFCFCFC),
          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 43,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xffEBEBEB),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Gap.h(24),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Image.asset(
                  ImageAssets.updateIcon,
                  width: 45,
                  height: 45,
                ),
              ),
            ),
            Gap.h12,
            AppText.medium(
              "New Update Available",

              fontSize: 16,
              color: const Color(0xff060606),
              centered: true,
              letterSpacing: -0.2,
            ),
            Gap.h12,
            AppText.regular(
              "To continue enjoying the DTH Show, update for the latest features and bug fixes.",
              fontSize: 14,
              color: const Color(0xff454545),
              centered: true,
              letterSpacing: -0.2,
            ),
            Gap.h(24),
            AppButton(text: "Update now", press: onTap, enabled: true),
            Gap.h(24),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Need help? ",
                    style: AppTextStyle.regular.copyWith(
                      color: Color(0xff6A6A6A),
                      fontSize: 12,
                      letterSpacing: -0.2,
                    ),
                  ),
                  TextSpan(
                    text: "Contact Support",
                    style: AppTextStyle.semiBold.copyWith(
                      color: Color(0xff202020),
                      fontSize: 12,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
