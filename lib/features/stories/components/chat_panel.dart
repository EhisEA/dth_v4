import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/posts/components/like_chip.dart";
import "package:dth_v4/features/stories/components/comment_tile.dart";
import "package:dth_v4/features/stories/components/stats_pill.dart";
import "package:dth_v4/features/stories/models/stories_mock_data.dart";
import "package:dth_v4/widgets/dth_send_button.dart";
import "package:dth_v4/widgets/text/text.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class ChatPanel extends StatelessWidget {
  const ChatPanel({
    super.key,
    required this.scrollController,
    required this.scrollPhysics,
    required this.bottomPad,
    required this.composerController,
    required this.readMoreTap,
    required this.liked,
    required this.likeCount,
    required this.onLikeTap,
  });

  final ScrollController scrollController;
  final ScrollPhysics scrollPhysics;

  final double bottomPad;
  final TextEditingController composerController;
  final TapGestureRecognizer readMoreTap;
  final bool liked;
  final int likeCount;
  final VoidCallback onLikeTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              physics: scrollPhysics,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium(
                          storyTitle,
                          fontSize: 16,
                          color: AppColors.black,
                          maxLines: 2,
                        ),
                        Gap.h6,
                        Row(
                          children: [
                            SvgPicture.asset(
                              SvgAssets.primaryLogo,
                              width: 14,
                              height: 14,
                            ),
                            Gap.w6,
                            SvgPicture.asset(
                              SvgAssets.blackLogo,
                              width: 65,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff08102F),
                                ),
                                children: [
                                  TextSpan(
                                    text: " with ",
                                    style: AppTextStyle.regular.copyWith(
                                      color: AppColors.blackTint20,
                                      fontSize: 10,
                                    ),
                                  ),
                                  TextSpan(
                                    text: storyWith,
                                    style: AppTextStyle.medium.copyWith(
                                      color: AppColors.black,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap.w4,
                            AppText.regular(
                              storyTime,
                              fontSize: 10,
                              color: AppColors.tint15,
                            ),
                          ],
                        ),
                        Gap.h12,
                        Text.rich(
                          TextSpan(
                            style: AppTextStyle.regular.copyWith(
                              color: AppColors.black,
                              fontSize: 12,
                              height: 1.35,
                            ),
                            children: [
                              TextSpan(text: storyCaptionPreview(maxChars: 92)),
                              TextSpan(
                                text: " Read more",
                                style: const TextStyle(
                                  color: Color(0xff6A6A6A),
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: readMoreTap,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap.h12,
                        Row(
                          children: [
                            Expanded(
                              child: _LikePill(
                                liked: liked,
                                count: likeCount,
                                onTap: onLikeTap,
                              ),
                            ),
                            Gap.w8,
                            const Expanded(
                              child: StatsPill(
                                iconData: Icons.thumb_down_alt_outlined,
                                label: "$storyDislikes",
                              ),
                            ),
                            Gap.w8,
                            const Expanded(
                              child: StatsPill(
                                icon: SvgAssets.sendBorder,
                                label: "$storyShares",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: Gap.h16),
                SliverToBoxAdapter(
                  child: Container(
                    height: 1,
                    color: AppColors.greyTint20.withValues(alpha: 0.1),
                  ),
                ),
                SliverToBoxAdapter(child: Gap.h20),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AppText.medium(
                              "Top Comments ",
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                            Gap.w4,
                            AppText.regular(
                              storyCommentCount.toString(),
                              fontSize: 12,
                              color: AppColors.tint15,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AppText.regular(
                              "Most recent",
                              fontSize: 12,
                              color: AppColors.tint25,
                            ),
                            Gap.w4,
                            SvgPicture.asset(
                              SvgAssets.downArrow,
                              width: 14,
                              height: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: Gap.h20),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  sliver: SliverList.separated(
                    itemCount: storyMockComments.length,
                    separatorBuilder: (_, __) => Gap.h16,
                    itemBuilder: (context, i) {
                      final c = storyMockComments[i];
                      return CommentTile(comment: c);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPad + 12),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: composerController,
                    borderRadius: BorderRadius.circular(100),
                    hint: "Drop a banger...",
                    fillColor: const Color(0xffFAFAFA),
                    hintColor: AppColors.tint15,
                    showBorder: false,
                  ),
                ),
                Gap.w8,
                DthSendButton(onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tappable likes pill matching [StatsPill] styling, animated via [LikeChip].
class _LikePill extends StatelessWidget {
  const _LikePill({
    required this.liked,
    required this.count,
    required this.onTap,
  });

  final bool liked;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: LikeChip(
          liked: liked,
          count: count,
          countLabel: formatStoryCount(count),
          onTap: onTap,
          iconSize: 18,
          fontSize: 12,
          inactiveColor: AppColors.paleLavender,
          countColor: AppColors.paleLavender,
        ),
      ),
    );
  }
}
