import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/posts/models/post.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class PostHeader extends StatelessWidget {
  const PostHeader({super.key, required this.post});

  final Post post;

  static const Color _muted = Color(0xff8F8F8F);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(SvgAssets.primaryLogo, height: 28, width: 28),
        Gap.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(SvgAssets.blackLogo, height: 16),
                  Gap.w2,
                  AppText.regular(
                    "with",
                    fontSize: 10,
                    color: AppColors.blackTint20,
                  ),
                  Gap.w2,
                  AppText.medium(
                    post.withName ?? "",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ],
              ),
              AppText.regular(post.timeAgo, fontSize: 10, color: _muted),
            ],
          ),
        ),
      ],
    );
  }
}
