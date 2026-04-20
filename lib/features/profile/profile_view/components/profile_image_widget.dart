import 'package:dth_v4/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    this.showEdit = false,
    this.size = 80,
    this.color,
  });
  final bool showEdit;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.baseShimmerLight,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                child: Center(
                  child: Image.asset(
                    ImageAssets.user,
                    height: size,
                    width: size,
                    color: color ?? const Color(0xffECECEC),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
              ),
            ),
            if (showEdit)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffE5FBF0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        SvgAssets.edit,
                        height: 14,
                        width: 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
