import "package:dth_v4/data/models/model.dart";

abstract class CommentRepo {
  Future<List<TimelineComment>> listComments(String postUid);
  Future<List<TimelineComment>> listReplies(String commentUid);
  Future<TimelineComment> createComment(String postUid, String body);
  Future<TimelineComment> createReply(String commentUid, String body);

  /// Toggles the authenticated viewer's reaction on a comment or reply.
  /// Returns the updated comment (fresh `counts.reactions` + `viewer_reacted`).
  Future<TimelineComment> toggleReaction(String commentUid);
}
