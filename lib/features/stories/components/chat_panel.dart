import "package:dth_v4/core/core.dart";
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
    required this.bottomPad,
    required this.composerController,
    required this.readMoreTap,
    this.minHeight = 0,
  });

  final double bottomPad;
  final TextEditingController composerController;
  final TapGestureRecognizer readMoreTap;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
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
                                  TextSpan(
                                    text: storyCaptionPreview(maxChars: 92),
                                  ),
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
                                  child: StatsPill(
                                    icon: SvgAssets.favoriteBorder,
                                    label: formatStoryCount(storyLikes),
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
                      Gap.h16,
                      Container(
                        height: 1,
                        color: AppColors.greyTint20.withValues(alpha: 0.1),
                      ),
                      Gap.h20,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      Gap.h20,
                      ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: storyMockComments.length,
                        separatorBuilder: (_, __) => Gap.h16,
                        itemBuilder: (context, i) {
                          final c = storyMockComments[i];
                          return CommentTile(comment: c);
                        },
                      ),
                    ],
                  ),
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
        ),
      ),
    );
  }
}
