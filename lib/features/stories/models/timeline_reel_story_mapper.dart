import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/stories/models/story.dart";

String _ensureHttpScheme(String url) {
  final t = url.trim();
  if (t.startsWith("//")) return "https:$t";
  if (t.startsWith("http://") || t.startsWith("https://")) return t;
  return "https://$t";
}

bool _isYoutubeUrl(String url, String? videoType) {
  final vt = videoType?.trim().toLowerCase() ?? "";
  if (vt == "youtube") return true;
  final host = Uri.tryParse(url)?.host.toLowerCase() ?? "";
  return host.contains("youtube.com") ||
      host == "youtu.be" ||
      host.contains("youtube-nocookie.com");
}

bool _looksLikeDirectVideoFile(String url, String? mime) {
  final m = mime?.trim().toLowerCase() ?? "";
  if (m.startsWith("video/")) return true;
  final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
  return path.endsWith(".mp4") ||
      path.endsWith(".webm") ||
      path.endsWith(".mov") ||
      path.endsWith(".m3u8") ||
      path.endsWith(".mkv");
}

/// Maps API [TimelineReel] to UI [Story] (thumbnail + optional playable URL).
Story storyFromTimelineReel(TimelineReel r) {
  final thumb = r.media?.thumbnail?.trim();
  final videoThumb = r.videoThumbnail?.trim();
  final mediaUrl = r.media?.url?.trim() ?? "";
  final mime = r.media?.mimeType?.trim();

  final imageUrl = (thumb != null && thumb.isNotEmpty)
      ? thumb
      : (videoThumb != null && videoThumb.isNotEmpty)
      ? videoThumb
      : (mediaUrl.isNotEmpty ? mediaUrl : "");
  final label = r.title.trim().isNotEmpty ? r.title.trim() : "Reel";

  final videoLink = r.videoLink?.trim() ?? "";

  String? playUrl;
  String? playType;

  if (videoLink.isNotEmpty) {
    final link = _ensureHttpScheme(videoLink);
    if (_isYoutubeUrl(link, r.videoType)) {
      playUrl = link;
      playType = "youtube";
    } else {
      playUrl = link;
      playType = "file";
    }
  } else if (mediaUrl.isNotEmpty &&
      _looksLikeDirectVideoFile(_ensureHttpScheme(mediaUrl), mime)) {
    playUrl = _ensureHttpScheme(mediaUrl);
    playType = "file";
  }

  return Story(
    imageUrl: imageUrl,
    label: label,
    videoUrl: playUrl,
    videoType: playType,
  );
}
