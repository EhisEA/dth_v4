import "dart:ui";

import "package:cached_network_image/cached_network_image.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/stories/components/chat_panel.dart";
import "package:dth_v4/features/tickets/tickets.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class ChatSplitBody extends StatelessWidget {
  const ChatSplitBody({
    super.key,
    required this.imageUrl,
    required this.topPad,
    required this.bottomPad,
    required this.composerController,
    required this.onBack,
    required this.readMoreTap,
  });

  final String imageUrl;
  final double topPad;
  final double bottomPad;
  final TextEditingController composerController;
  final VoidCallback onBack;
  final TapGestureRecognizer readMoreTap;

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final mediaHeight = viewportHeight * 0.6;
    final panelMinHeight = viewportHeight * 0.3;

    return SizedBox.expand(
      child: Column(
        children: [
          SizedBox(
            height: mediaHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      ColoredBox(color: AppColors.baseShimmer(context)),
                  errorWidget: (context, url, error) => ColoredBox(
                    color: AppColors.baseShimmer(context),
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.tint15,
                    ),
                  ),
                ),
                const ColoredBox(color: Color(0x22000000)),
                Positioned(
                  top: topPad + 8,
                  left: 16,
                  child: CircleBlurIconButton(
                    onTap: onBack,
                    child: SvgPicture.asset(
                      SvgAssets.backArrow,
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        color: Colors.black.withValues(alpha: 0.5),
                        child: const Icon(
                          Icons.pause_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: 0.4,
              minHeight: 4,
              backgroundColor: AppColors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: ChatPanel(
              bottomPad: bottomPad,
              composerController: composerController,
              readMoreTap: readMoreTap,
              minHeight: panelMinHeight,
            ),
          ),
        ],
      ),
    );
  }
}
