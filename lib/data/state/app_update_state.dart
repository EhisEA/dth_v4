import 'dart:io';
import 'dart:ui';

import 'package:dth_v4/core/constants/app_constants.dart';
import 'package:dth_v4/data/state/base_state.dart';
import 'package:dth_v4/widgets/app_update_bs_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/services/navigation/mobile_navigation_service.dart';
import 'package:flutter_utils/utils/link_launcher.dart';

class AppUpdateState extends BaseState {
  AppUpdateState();
  bool bsOpened = false;

  appUpdateBS() {
    if (bsOpened) return;
    bsOpened = true;
    return showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      context:
          MobileNavigationService.instance.navigatorKey.currentState!.context,
      isScrollControlled: true,
      barrierColor: const Color(0XFF5969C5).withValues(alpha: .12),
      constraints: BoxConstraints(
        maxWidth:
            MediaQuery.of(
              MobileNavigationService
                  .instance
                  .navigatorKey
                  .currentState!
                  .context,
            ).size.width -
            24,
      ),
      builder: (context) {
        return PopScope(
          canPop: false, // Prevent back button dismissal
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AppUpdateBsCard(
              onTap: () async {
                if (Platform.isAndroid) {
                  await LinkLauncher.openURL(AppLink.androidStoreLink);
                } else if (Platform.isIOS) {
                  await LinkLauncher.openURL(AppLink.iosStoreLink);
                }
              },
            ),
          ),
        );
      },
    ).then((_) {
      // Reset the flag when the bottom sheet is dismissed
      bsOpened = false;
    });
  }
}

final appUpdateStateProvider = Provider((ref) => AppUpdateState());
