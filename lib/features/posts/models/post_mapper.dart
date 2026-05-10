import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/posts/models/post.dart";
import "package:intl/intl.dart";

/// Splits a feed title formatted as "X with Y" into (author, withName).
/// Falls back gracefully when the separator is missing or the title is empty.
(String, String?) parsePostTitle(String title) {
  final trimmed = title.trim();
  if (trimmed.isEmpty) {
    return ("", null);
  }
  final lower = trimmed.toLowerCase();
  const sep = " with ";
  final idx = lower.indexOf(sep);
  if (idx == -1) {
    return ("", trimmed);
  }
  final author = trimmed.substring(0, idx).trim();
  final withPart = trimmed.substring(idx + sep.length).trim();
  return (
    author.isEmpty ? trimmed : author,
    withPart.isEmpty ? null : withPart,
  );
}

String formatTimeAgo(String createdAt) {
  if (createdAt.trim().isEmpty) {
    return "";
  }
  try {
    final dt = DateTime.parse(createdAt).toLocal();
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.isNegative) {
      return DateFormat.yMMMd().format(dt);
    }
    if (diff.inMinutes < 1) {
      return "Just now";
    }
    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    }
    if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    }
    if (diff.inDays < 7) {
      return "${diff.inDays}d ago";
    }
    return DateFormat.yMMMd().format(dt);
  } on FormatException {
    return "";
  }
}

Post postFromTimelinePost(TimelinePost p) {
  final parsed = parsePostTitle(p.title);
  final authorName = parsed.$1;
  final withName = parsed.$2;
  final typeLower = p.type.trim().toLowerCase();
  final thumb = p.videoThumbnail?.trim() ?? "";
  final isVideo = typeLower == "video" && thumb.isNotEmpty;

  final imageUrls = <String>[];
  if (!isVideo && p.media != null) {
    imageUrls.addAll(p.media!);
  }

  return Post(
    uid: p.uid,
    title: p.title.trim(),
    authorName: p.authorName ?? withName ?? authorName,
    createdAt: p.createdAt,
    description: p.description.trim(),
    likeCount: p.counts.reactions,
    commentCount: p.counts.comments,
    shareCount: p.counts.shares,
    viewCount: p.counts.views,
    viewerReacted: p.viewerReacted,
    video: isVideo
        ? PostVideo(
            thumbnailUrl: thumb,
            videoUrl: p.videoLink?.trim(),
            provider: p.videoType?.trim(),
          )
        : null,
    imageUrls: imageUrls,
  );
}
