import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/features/stories/models/mock_comment.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final MockComment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.baseShimmer(context),
          child: AppText.regular(
            comment.user.isNotEmpty ? comment.user[0].toUpperCase() : "?",
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xff474954),
          ),
        ),
        Gap.w10,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText.medium(
                    comment.user,
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                  Gap.w4,
                  AppText.regular(
                    comment.time,
                    fontSize: 10,
                    color: AppColors.tint15,
                  ),
                ],
              ),
              Gap.h8,
              AppText.regular(
                comment.text,
                fontSize: 12,
                color: AppColors.black,
                height: 1.35,
              ),
              Gap.h8,
              Row(
                children: [
                  SvgPicture.asset(
                    SvgAssets.favoriteBorder,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.blackTint20,
                      BlendMode.srcIn,
                    ),
                  ),
                  Gap.w4,
                  AppText.medium(
                    "${comment.likes}",
                    fontSize: 12,
                    color: AppColors.blackTint20,
                  ),
                  Gap.w8,
                  SvgPicture.asset(
                    SvgAssets.messagesBorder,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.blackTint20,
                      BlendMode.srcIn,
                    ),
                  ),
                  Gap.w4,
                  AppText.medium(
                    "${comment.replies}",
                    fontSize: 12,
                    color: AppColors.blackTint20,
                  ),
                  Gap.w8,
                  SvgPicture.asset(
                    SvgAssets.sendBorder,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.blackTint20,
                      BlendMode.srcIn,
                    ),
                  ),
                  Gap.w4,
                  AppText.medium(
                    "${comment.shares}",
                    fontSize: 12,
                    color: AppColors.blackTint20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
