import "package:dth_v4/core/constants/assets.dart";
import "package:dth_v4/core/router/router.dart";
import "package:dth_v4/core/utils/colors.dart";
import "package:dth_v4/features/posts/components/like_chip.dart";
import "package:dth_v4/features/stories/components/chat_split_body.dart";
import "package:dth_v4/features/stories/components/full_reel_body.dart";
import "package:dth_v4/features/stories/components/reel_backdrop_media.dart";
import "package:dth_v4/features/stories/models/stories_mock_data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class StoriesView extends StatefulWidget {
  const StoriesView({
    super.key,
    required this.imageUrl,
    this.videoUrl,
    this.videoType,
  });

  final String imageUrl;
  final String? videoUrl;
  final String? videoType;

  static const String path = NavigatorRoutes.stories;

  @override
  State<StoriesView> createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  bool _chatOpen = false;
  bool _liked = false;
  int _likeCount = storyLikes;
  final TextEditingController _composerController = TextEditingController();
  late final TapGestureRecognizer _readMoreReelTap;
  late final TapGestureRecognizer _readMoreChatTap;

  @override
  void initState() {
    super.initState();
    _readMoreReelTap = TapGestureRecognizer()..onTap = () {};
    _readMoreChatTap = TapGestureRecognizer()..onTap = () {};
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Same idea as post detail on dark media: light status bar icons.
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _readMoreReelTap.dispose();
    _readMoreChatTap.dispose();
    _composerController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() => _chatOpen = !_chatOpen);
    HapticFeedback.lightImpact();
  }

  void _onBack() {
    if (_chatOpen) {
      setState(() => _chatOpen = false);
    } else {
      MobileNavigationService.instance.goBack();
    }
  }

  /// Pull-to-dismiss when the chat sheet is already at its minimum height.
  void _closeChatFromDrag() {
    if (!_chatOpen) return;
    setState(() => _chatOpen = false);
    HapticFeedback.lightImpact();
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final hasPoster = widget.imageUrl.trim().isNotEmpty;
    final hasVideo =
        widget.videoUrl != null && widget.videoUrl!.trim().isNotEmpty;
    final noReelMedia = !hasPoster && !hasVideo;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: noReelMedia
            ? const Center(
                child: AppText.regular("No media", color: Colors.white),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: ReelBackdropMedia(
                      key: const ValueKey<String>("stories_reel_backdrop"),
                      posterUrl: widget.imageUrl,
                      videoUrl: widget.videoUrl,
                      videoType: widget.videoType,
                    ),
                  ),
                  if (_chatOpen)
                    ChatSplitBody(
                      imageUrl: widget.imageUrl,
                      videoUrl: widget.videoUrl,
                      videoType: widget.videoType,
                      topPad: topPad,
                      bottomPad: bottomPad,
                      composerController: _composerController,
                      onBack: _onBack,
                      onCloseChat: _closeChatFromDrag,
                      readMoreTap: _readMoreChatTap,
                      excludeBackdrop: true,
                      liked: _liked,
                      likeCount: _likeCount,
                      onLikeTap: _toggleLike,
                    )
                  else
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (_chatOpen) {
                          setState(() => _chatOpen = false);
                        }
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: FullReelBody(
                              imageUrl: widget.imageUrl,
                              videoUrl: widget.videoUrl,
                              videoType: widget.videoType,
                              topPad: topPad,
                              bottomPad: bottomPad,
                              onBack: _onBack,
                              onChatTap: _toggleChat,
                              readMoreTap: _readMoreReelTap,
                              excludeBackdrop: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 8,
                              bottom: bottomPad + 16,
                              left: 16,
                              right: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mainBlack,
                            ),
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
                                Gap.w8,
                                LikeChip(
                                  liked: _liked,
                                  count: _likeCount,
                                  countLabel: formatStoryCount(_likeCount),
                                  onTap: _toggleLike,
                                  iconSize: 24,
                                  fontSize: 14,
                                  inactiveColor: AppColors.white,
                                  countColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                                _ReelComposerIcon(
                                  onTap: _toggleChat,
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
                                _ReelComposerIcon(
                                  onTap: () => HapticFeedback.lightImpact(),
                                  child: SvgPicture.asset(
                                    SvgAssets.share,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _ReelComposerIcon extends StatelessWidget {
  const _ReelComposerIcon({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: SizedBox(
          width: kMinInteractiveDimension,
          height: kMinInteractiveDimension,
          child: Center(child: child),
        ),
      ),
    );
  }
}
