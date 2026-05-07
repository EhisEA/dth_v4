import "package:flutter/material.dart";
import "package:webview_flutter/webview_flutter.dart";

/// Inline YouTube player that loads the embed URL inside a WebView with
/// autoplay enabled. Expects an embed-style URL like
/// `https://www.youtube.com/embed/VIDEO_ID` (which is what the API returns).
class YoutubePlayerEmbed extends StatefulWidget {
  const YoutubePlayerEmbed({
    super.key,
    required this.embedUrl,
    this.radius = 12,
  });

  final String embedUrl;
  final double radius;

  @override
  State<YoutubePlayerEmbed> createState() => _YoutubePlayerEmbedState();
}

class _YoutubePlayerEmbedState extends State<YoutubePlayerEmbed> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final uri = _withAutoplay(widget.embedUrl);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(uri);
  }

  Uri _withAutoplay(String embedUrl) {
    final base = Uri.parse(embedUrl);
    final params = Map<String, String>.from(base.queryParameters);
    params["autoplay"] = "1";
    params["playsinline"] = "1";
    params["rel"] = "0";
    // iOS WebView (and most mobile browsers) block unmuted autoplay without a
    // user gesture. Muted autoplay matches the social-feed convention; users
    // unmute via YouTube's own player controls.
    params["mute"] = "1";
    return base.replace(queryParameters: params);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(
          color: Colors.black,
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
