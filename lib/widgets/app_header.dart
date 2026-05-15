import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/data/state/app_modules_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_utils/flutter_utils.dart';

class AppHeader extends ConsumerWidget {
  const AppHeader({
    super.key,
    required this.onLiveTap,
    // required this.onNotificationTap,
  });
  final VoidCallback onLiveTap;
  // final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appModules = ref.watch(appModulesStateProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(ImageAssets.logo2, height: 32, width: 110),
        Row(
          children: [
            if (appModules.appModules.value?.livestream == true) ...[
              GestureDetector(
                onTap: () {
                  onLiveTap();
                  HapticFeedback.lightImpact();
                },
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(SvgAssets.live),
              ),
            ],
            // Gap.w16,
            // GestureDetector(
            //   onTap: () {
            //     onNotificationTap();
            //     HapticFeedback.lightImpact();
            //   },
            //   child: SvgPicture.asset(SvgAssets.notification),
            // ),
          ],
        ),
      ],
    );
  }
}
