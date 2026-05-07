import "package:flutter/foundation.dart";

@immutable
class Post {
  const Post({
    required this.uid,
    required this.authorName,
    this.withName,
    required this.timeAgo,
    required this.description,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.viewCount = 0,
    this.viewerReacted = false,
    this.video,
    this.imageUrls = const [],
  });

  final String uid;
  final String authorName;
  final String? withName;
  final String timeAgo;
  final String description;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int viewCount;
  final bool viewerReacted;
  final PostVideo? video;
  final List<String> imageUrls;

  bool get isVideo => video != null;

  Post copyWith({
    String? authorName,
    String? withName,
    String? timeAgo,
    String? description,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    int? viewCount,
    bool? viewerReacted,
    PostVideo? video,
    List<String>? imageUrls,
  }) {
    return Post(
      uid: uid,
      authorName: authorName ?? this.authorName,
      withName: withName ?? this.withName,
      timeAgo: timeAgo ?? this.timeAgo,
      description: description ?? this.description,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      viewCount: viewCount ?? this.viewCount,
      viewerReacted: viewerReacted ?? this.viewerReacted,
      video: video ?? this.video,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

@immutable
class PostVideo {
  const PostVideo({
    required this.thumbnailUrl,
    this.videoUrl,
    this.provider,
  });

  final String thumbnailUrl;
  final String? videoUrl;
  final String? provider;

  bool get isYoutube => provider?.trim().toLowerCase() == "youtube";
  bool get isPlayable => videoUrl != null && videoUrl!.trim().isNotEmpty;
}
