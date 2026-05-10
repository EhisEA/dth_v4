import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/posts/components/like_chip.dart";
import "package:dth_v4/features/posts/models/post.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class PostActions extends StatelessWidget {
  const PostActions({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              LikeChip(
                liked: post.viewerReacted,
                count: post.likeCount,
                onTap: onLike,
              ),
              Gap.w10,
              Container(width: 1, height: 14, color: const Color(0xffEBEBEB)),
              Gap.w10,
              _ActionChip(
                icon: SvgAssets.messagesBorder,
                count: post.commentCount,
                onTap: onComment,
              ),
            ],
          ),
        ),
        Gap.w10,
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: _ActionChip(
            icon: SvgAssets.share,
            count: post.shareCount,
            tint: const Color(0xff454545),
            onTap: onShare,
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.count,
    this.tint,
    this.onTap,
  });

  final String icon;
  final int count;
  final Color? tint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 14,
            width: 14,
            colorFilter: ColorFilter.mode(
              tint ?? AppColors.blackTint20,
              BlendMode.srcIn,
            ),
          ),
          Gap.w4,
          AppText.medium('$count', fontSize: 12, color: AppColors.tint25),
        ],
      ),
    );
  }
}
