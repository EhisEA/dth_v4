import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/home/components/home_post_description.dart";
import "package:dth_v4/features/home/components/home_post_media.dart";
import "package:dth_v4/features/home/models/home_feed_models.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class HomePostCard extends StatelessWidget {
  const HomePostCard({
    super.key,
    required this.post,
    this.onVideoTap,
    this.onReadMore,
  });

  final HomePostItem post;
  final VoidCallback? onVideoTap;
  final VoidCallback? onReadMore;

  static const Color _muted = Color(0xff6A6A6A);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SvgPicture.asset(SvgAssets.greyLogo, height: 28, width: 28),
            Gap.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(SvgAssets.blackLogo, height: 24),
                      Gap.w4,
                      AppText.regular(
                        "with",
                        fontSize: 10,
                        color: AppColors.tint20,
                      ),
                      Gap.w4,
                      AppText.medium(
                        post.withName ?? "",
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                    ],
                  ),

                  AppText.regular(post.timeAgo, fontSize: 12, color: _muted),
                ],
              ),
            ),
          ],
        ),
        Gap.h8,
        HomePostMedia(post: post, onVideoTap: onVideoTap),
        if (post.description.isNotEmpty) ...[
          Gap.h12,
          HomePostDescription(text: post.description, onReadMore: onReadMore),
        ],
        Gap.h12,
        Row(
          children: [
            _ActionChip(icon: SvgAssets.favoriteBorder, count: post.likeCount),
            Gap.w10,
            _ActionChip(
              icon: SvgAssets.messagesBorder,
              count: post.commentCount,
            ),
            Gap.w10,
            _ActionChip(icon: SvgAssets.sendBorder, count: post.shareCount),
          ],
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.count});

  final String icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, height: 22, width: 22),
        Gap.w4,
        AppText.medium('$count', fontSize: 12, color: AppColors.tint25),
      ],
    );
  }
}
