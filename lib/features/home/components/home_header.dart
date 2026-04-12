import 'package:dth_v4/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onLiveTap,
    required this.onNotificationTap,
  });
  final VoidCallback onLiveTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(ImageAssets.logo2, height: 32, width: 110),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                onLiveTap();
                HapticFeedback.lightImpact();
              },
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(SvgAssets.live),
            ),
            Gap.w16,
            GestureDetector(
              onTap: () {
                onNotificationTap();
                HapticFeedback.lightImpact();
              },
              child: SvgPicture.asset(SvgAssets.notification),
            ),
          ],
        ),
      ],
    );
  }
}
