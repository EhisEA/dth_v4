import "package:flutter/foundation.dart";

@immutable
class HomeStoryItem {
  const HomeStoryItem({required this.imageUrl, required this.label});
  final String imageUrl;
  final String label;
}

@immutable
class HomePostItem {
  const HomePostItem({
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
  final HomePostVideo? video;
  final List<String> imageUrls;

  bool get isVideo => video != null;
}

@immutable
class HomePostVideo {
  const HomePostVideo({required this.thumbnailUrl});
  final String thumbnailUrl;
}
