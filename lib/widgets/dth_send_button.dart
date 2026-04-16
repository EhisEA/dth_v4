import 'package:dth_v4/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DthSendButton extends StatelessWidget {
  const DthSendButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          onTap();
          HapticFeedback.lightImpact();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            SvgAssets.send,
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
