import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

class ContestantPill extends StatelessWidget {
  const ContestantPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.white,
        border: Border.all(color: AppColors.greyTint30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.medium(
            "CONTESTANT",
            fontSize: 10,
            color: AppColors.mainBlack,
            letterSpacing: 0.4,
          ),
          Gap.w8,
          Container(width: 1, height: 12, color: AppColors.greyTint35),
          Gap.w12,
          AppText.medium(
            "0xff2828282",
            fontSize: 10,
            color: AppColors.mainBlack,
            letterSpacing: 0.4,
          ),
          Gap.w4,
          SvgPicture.asset(SvgAssets.copy),
        ],
      ),
    );
  }
}
