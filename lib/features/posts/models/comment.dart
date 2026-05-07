import "package:flutter/foundation.dart";

@immutable
class Comment {
  const Comment({
    required this.uid,
    required this.authorName,
    this.avatarUrl,
    required this.body,
    required this.timeAgo,
    required this.likeCount,
    required this.replyCount,
    this.viewerReacted = false,
    this.isReply = false,
    this.parentUid,
  });

  final String uid;
  final String authorName;
  final String? avatarUrl;
  final String body;
  final String timeAgo;
  final int likeCount;
  final int replyCount;
  final bool viewerReacted;
  final bool isReply;
  final String? parentUid;

  Comment copyWith({
    String? body,
    int? likeCount,
    int? replyCount,
    bool? viewerReacted,
  }) {
    return Comment(
      uid: uid,
      authorName: authorName,
      avatarUrl: avatarUrl,
      body: body ?? this.body,
      timeAgo: timeAgo,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      viewerReacted: viewerReacted ?? this.viewerReacted,
      isReply: isReply,
      parentUid: parentUid,
    );
  }
}
