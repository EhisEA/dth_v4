import "package:flutter/foundation.dart";

@immutable
class Story {
  const Story({
    required this.imageUrl,
    required this.label,
    this.videoUrl,
    this.videoType,
  });

  final String imageUrl;
  final String label;

  /// Playable reel URL when API supplies `video_link` or video `media.url`.
  final String? videoUrl;

  /// `"youtube"` or `"file"` (direct / HLS).
  final String? videoType;
}
