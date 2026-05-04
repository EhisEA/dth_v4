import "package:flutter/foundation.dart";

@immutable
class Post {
  const Post({
    required this.authorName,
    this.withName,
    required this.timeAgo,
    required this.description,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.video,
    this.imageUrls = const [],
  });

  final String authorName;
  final String? withName;
  final String timeAgo;
  final String description;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final PostVideo? video;
  final List<String> imageUrls;

  bool get isVideo => video != null;
}

@immutable
class PostVideo {
  const PostVideo({required this.thumbnailUrl});
  final String thumbnailUrl;
}
