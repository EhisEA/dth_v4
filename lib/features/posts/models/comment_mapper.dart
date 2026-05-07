import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/posts/models/comment.dart";
import "package:dth_v4/features/posts/models/post_mapper.dart";

Comment commentFromTimelineComment(TimelineComment c) {
  return Comment(
    uid: c.uid,
    authorName: c.user.fullName,
    avatarUrl: c.user.avatar,
    body: c.description,
    timeAgo: formatTimeAgo(c.createdAt),
    likeCount: c.counts.reactions,
    replyCount: c.counts.comments,
    viewerReacted: c.viewerReacted,
    isReply: c.isReply,
    parentUid: c.parentId,
  );
}
