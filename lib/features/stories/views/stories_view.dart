import "package:dth_v4/core/router/router.dart";
import "package:dth_v4/features/stories/components/chat_split_body.dart";
import "package:dth_v4/features/stories/components/full_reel_body.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_utils/flutter_utils.dart";

class StoriesView extends StatefulWidget {
  const StoriesView({super.key, required this.imageUrl});

  final String imageUrl;

  static const String path = NavigatorRoutes.stories;

  @override
  State<StoriesView> createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  bool _chatOpen = false;
  final TextEditingController _composerController = TextEditingController();
  late final TapGestureRecognizer _readMoreReelTap;
  late final TapGestureRecognizer _readMoreChatTap;

  @override
  void initState() {
    super.initState();
    _readMoreReelTap = TapGestureRecognizer()..onTap = () {};
    _readMoreChatTap = TapGestureRecognizer()..onTap = () {};
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.imageUrl.isEmpty
          ? const Center(
              child: AppText.regular("No media", color: Colors.white),
            )
          : _chatOpen
          ? ChatSplitBody(
              imageUrl: widget.imageUrl,
              topPad: topPad,
              bottomPad: bottomPad,
              composerController: _composerController,
              onBack: _onBack,
              readMoreTap: _readMoreChatTap,
            )
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).unfocus();
                if (_chatOpen) {
                  setState(() => _chatOpen = false);
                }
              },
              child: FullReelBody(
                imageUrl: widget.imageUrl,
                topPad: topPad,
                bottomPad: bottomPad,
                onBack: _onBack,
                onChatTap: _toggleChat,
                readMoreTap: _readMoreReelTap,
              ),
            ),
    );
  }
}
