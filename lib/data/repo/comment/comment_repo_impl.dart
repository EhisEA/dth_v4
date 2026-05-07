import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class CommentRepoImpl implements CommentRepo {
  CommentRepoImpl({required NetworkService networkService})
    : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<List<TimelineComment>> listComments(String postUid) async {
    final response = await _networkService.get(
      ApiRoute.timelinePostComments(postUid),
    );
    return _parseList(response.data, "comments");
  }

  @override
  Future<List<TimelineComment>> listReplies(String commentUid) async {
    final response = await _networkService.get(
      ApiRoute.timelineCommentReplies(commentUid),
    );
    return _parseList(response.data, "replies");
  }

  @override
  Future<TimelineComment> createComment(String postUid, String body) async {
    final response = await _networkService.post(
      ApiRoute.timelinePostComments(postUid),
      data: {"description": body},
    );
    return _parseSingle(response.data, ["comment"]);
  }

  @override
  Future<TimelineComment> createReply(String commentUid, String body) async {
    final response = await _networkService.post(
      ApiRoute.timelineCommentReplies(commentUid),
      data: {"description": body},
    );
    // API currently returns { data: { replies: {...single object...} } } —
    // accept either shape so a future backend cleanup ("reply") doesn't break us.
    return _parseSingle(response.data, ["reply", "replies"]);
  }

  @override
  Future<TimelineComment> toggleReaction(String commentUid) async {
    final response = await _networkService.post(
      ApiRoute.timelineCommentReact(commentUid),
    );
    return _parseSingle(response.data, ["comment"]);
  }

  List<TimelineComment> _parseList(dynamic root, String listKey) {
    if (root is! Map<String, dynamic>) return const [];
    final data = root["data"];
    if (data is! Map<String, dynamic>) return const [];
    final items = data[listKey];
    if (items is! List<dynamic>) return const [];
    return items
        .map((e) {
          if (e is! Map) return null;
          return TimelineComment.fromJson(Map<String, dynamic>.from(e));
        })
        .whereType<TimelineComment>()
        .toList();
  }

  TimelineComment _parseSingle(dynamic root, List<String> candidateKeys) {
    if (root is! Map<String, dynamic>) {
      throw ApiFailure("Invalid response shape");
    }
    final data = root["data"];
    if (data is! Map<String, dynamic>) {
      throw ApiFailure("Missing data block");
    }
    for (final key in candidateKeys) {
      final raw = data[key];
      if (raw is Map) {
        return TimelineComment.fromJson(Map<String, dynamic>.from(raw));
      }
    }
    throw ApiFailure("Comment payload missing");
  }
}

final commentRepositoryProvider = Provider<CommentRepo>((ref) {
  return CommentRepoImpl(networkService: ref.read(networkServiceProvider));
});
