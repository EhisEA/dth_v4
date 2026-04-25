import "dart:ui";

import "package:cached_network_image/cached_network_image.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/stories/models/stories_mock_data.dart";
import "package:dth_v4/features/tickets/tickets.dart";
import "package:dth_v4/widgets/text/text.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class FullReelBody extends StatelessWidget {
  const FullReelBody({
    super.key,
    required this.imageUrl,
    required this.topPad,
    required this.bottomPad,
    required this.onBack,
    required this.onChatTap,
    required this.readMoreTap,
  });

  final String imageUrl;
  final double topPad;
  final double bottomPad;
  final VoidCallback onBack;
  final VoidCallback onChatTap;
  final TapGestureRecognizer readMoreTap;

  static Widget _whiteSvg(String asset, {double size = 28}) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                ColoredBox(color: AppColors.baseShimmer(context)),
            errorWidget: (context, url, error) => ColoredBox(
              color: AppColors.baseShimmer(context),
              child: Icon(Icons.broken_image_outlined, color: AppColors.tint15),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.black.withValues(alpha: 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          top: topPad + 10,
          left: 16,
          child: CircleBlurIconButton(
            onTap: onBack,
            child: _whiteSvg(SvgAssets.backArrow, size: 20),
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(SvgAssets.primaryLogo),
                    Gap.w10,
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                SvgAssets.blackLogo,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  AppColors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Gap.w4,
                              AppText.medium(
                                "with",
                                fontSize: 12,
                                color: AppColors.tint5,
                              ),
                              Gap.w4,
                              AppText.medium(
                                storyWith,
                                fontSize: 14,
                                color: AppColors.white,
                              ),
                              Gap.w4,
                              AppText.regular(
                                storyTime,
                                fontSize: 12,
                                color: AppColors.tint5,
                              ),
                            ],
                          ),
                          Gap.h4,
                          Text.rich(
                            TextSpan(
                              style: AppTextStyle.regular.copyWith(
                                color: AppColors.white,
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
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: readMoreTap,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Gap.h16,
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: 0.4,
                  minHeight: 2,
                  backgroundColor: AppColors.white,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 30,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(color: AppColors.mainBlack),
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        fillColor: const Color(
                          0xffEFEFEF,
                        ).withValues(alpha: 0.16),
                        showBorder: false,
                        borderRadius: BorderRadius.circular(100),
                        hint: "Join the vibe...",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Gap.w16,
                    SvgPicture.asset(
                      SvgAssets.favorite,
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.redTint35,
                        BlendMode.srcIn,
                      ),
                    ),
                    Gap.w16,
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onChatTap,
                      child: SvgPicture.asset(
                        SvgAssets.messagesBorder,
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          AppColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Gap.w16,
                    SvgPicture.asset(SvgAssets.share, height: 24, width: 24),
                    // DthSendButton(onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                color: Colors.black.withValues(alpha: 0.40),
                child: SvgPicture.asset(
                  SvgAssets.play,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
