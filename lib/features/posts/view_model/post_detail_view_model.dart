import "dart:async";

import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/posts/models/comment.dart";
import "package:dth_v4/features/posts/models/comment_mapper.dart";
import "package:dth_v4/features/posts/models/post.dart";
import "package:dth_v4/features/posts/models/post_mapper.dart";
import "package:dth_v4/features/posts/view_model/posts_cache.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class PostDetailViewModel extends BaseChangeNotifierViewModel {
  PostDetailViewModel(
    this.uid,
    this._postRepo,
    this._commentRepo,
    this._postsCache,
  ) {
    _refresh();
  }

  final String uid;
  final PostRepo _postRepo;
  final CommentRepo _commentRepo;
  final PostsCache _postsCache;

  Post? get post => _postsCache.get(uid);

  List<Comment> _comments = const [];
  List<Comment> get comments => _comments;

  bool _commentsLoading = false;
  bool get commentsLoading => _commentsLoading;

  Failure? _commentsError;
  Failure? get commentsError => _commentsError;

  Comment? _replyTo;
  Comment? get replyTo => _replyTo;

  bool _submitting = false;
  bool get submitting => _submitting;

  void setReplyTo(Comment? comment) {
    _replyTo = comment;
    notifyListeners();
  }

  // commentUid -> {expanded, loading, replies}
  final Map<String, _RepliesState> _replies = {};

  bool isRepliesExpanded(String commentUid) =>
      _replies[commentUid]?.expanded ?? false;
  bool isRepliesLoading(String commentUid) =>
      _replies[commentUid]?.loading ?? false;
  List<Comment> repliesFor(String commentUid) =>
      _replies[commentUid]?.replies ?? const [];

  Future<void> refresh() async {
    await Future.wait([_refresh(), _loadComments()]);
  }

  Future<void> _refresh() async {
    try {
      if (post == null) {
        changeBaseState(const ViewModelState.busy());
      }
      final raw = await _postRepo.fetchPost(uid);
      _postsCache.upsert(postFromTimelinePost(raw));
      changeBaseState(const ViewModelState.idle());
      // Kick off comments after we have the post (idempotent if already loaded).
      if (_comments.isEmpty && !_commentsLoading) {
        unawaited(_loadComments());
      }
    } on ApiFailure catch (e) {
      if (post == null) {
        changeBaseState(ViewModelState.error(e));
      } else {
        notifyListeners();
      }
    }
  }

  Future<void> _loadComments() async {
    _commentsLoading = true;
    _commentsError = null;
    notifyListeners();
    try {
      final raw = await _commentRepo.listComments(uid);
      _comments = raw.map(commentFromTimelineComment).toList();
    } on ApiFailure catch (e) {
      _commentsError = e;
    } finally {
      _commentsLoading = false;
      notifyListeners();
    }
  }

  Future<void> retryLoadComments() => _loadComments();

  /// Returns true if submission was accepted (clears the composer).
  /// Posts a top-level comment when [replyTo] is null, otherwise a reply.
  Future<bool> submit(String text) async {
    final body = text.trim();
    if (body.isEmpty || _submitting) return false;
    _submitting = true;
    notifyListeners();
    try {
      if (_replyTo == null) {
        final raw = await _commentRepo.createComment(uid, body);
        final comment = commentFromTimelineComment(raw);
        _comments = [comment, ..._comments];
        _bumpPostCommentCount(1);
      } else {
        final parentUid = _replyTo!.uid;
        final raw = await _commentRepo.createReply(parentUid, body);
        final reply = commentFromTimelineComment(raw);
        final state = _replies[parentUid] ?? const _RepliesState();
        _replies[parentUid] = state.copyWith(
          expanded: true,
          replies: [...state.replies, reply],
        );
        _comments = _comments
            .map(
              (c) => c.uid == parentUid
                  ? c.copyWith(replyCount: c.replyCount + 1)
                  : c,
            )
            .toList();
        _replyTo = null;
      }
      return true;
    } on ApiFailure catch (e) {
      DthFlushBar.instance.showError(message: e.message, title: "Failed");
      return false;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  void _bumpPostCommentCount(int delta) {
    final current = post;
    if (current == null) return;
    _postsCache.upsert(
      current.copyWith(commentCount: current.commentCount + delta),
    );
  }

  /// Optimistic post like/unlike. Cache is flipped immediately; the server
  /// response then settles the canonical counts. Rolls back + toasts on failure.
  Future<void> togglePostLike() async {
    final original = post;
    if (original == null || _postLikePending) return;
    _postLikePending = true;
    final wasReacted = original.viewerReacted;
    _postsCache.upsert(
      original.copyWith(
        viewerReacted: !wasReacted,
        likeCount: original.likeCount + (wasReacted ? -1 : 1),
      ),
    );
    notifyListeners();
    try {
      final raw = await _postRepo.toggleReaction(uid);
      _postsCache.upsert(postFromTimelinePost(raw));
    } on ApiFailure catch (e) {
      _postsCache.upsert(original);
      DthFlushBar.instance.showError(message: e.message, title: "Like");
    } finally {
      _postLikePending = false;
      notifyListeners();
    }
  }

  bool _postLikePending = false;

  /// Optimistic comment/reply like. Locates the row via [comment.isReply] +
  /// [comment.parentUid] so top-level and reply lists both update correctly.
  Future<void> toggleCommentLike(Comment comment) async {
    if (_commentLikesPending.contains(comment.uid)) return;
    _commentLikesPending.add(comment.uid);
    final wasReacted = comment.viewerReacted;
    final optimistic = comment.copyWith(
      viewerReacted: !wasReacted,
      likeCount: comment.likeCount + (wasReacted ? -1 : 1),
    );
    _replaceComment(optimistic);
    notifyListeners();
    try {
      final raw = await _commentRepo.toggleReaction(comment.uid);
      final fresh = commentFromTimelineComment(raw);
      // Preserve the original comment's parent linkage; the server only sends
      // back counts + viewer_reacted, and parent_id can be absent.
      _replaceComment(
        comment.copyWith(
          viewerReacted: fresh.viewerReacted,
          likeCount: fresh.likeCount,
          replyCount: fresh.replyCount,
        ),
      );
    } on ApiFailure catch (e) {
      _replaceComment(comment);
      DthFlushBar.instance.showError(message: e.message, title: "Like");
    } finally {
      _commentLikesPending.remove(comment.uid);
      notifyListeners();
    }
  }

  final Set<String> _commentLikesPending = {};

  void _replaceComment(Comment updated) {
    if (updated.isReply && updated.parentUid != null) {
      final parentUid = updated.parentUid!;
      final state = _replies[parentUid];
      if (state == null) return;
      _replies[parentUid] = state.copyWith(
        replies: state.replies
            .map((r) => r.uid == updated.uid ? updated : r)
            .toList(),
      );
    } else {
      _comments = _comments
          .map((c) => c.uid == updated.uid ? updated : c)
          .toList();
    }
  }

  Future<void> toggleReplies(String commentUid) async {
    final current = _replies[commentUid];
    if (current?.expanded ?? false) {
      _replies[commentUid] = current!.copyWith(expanded: false);
      notifyListeners();
      return;
    }

    final hadReplies = current?.replies.isNotEmpty ?? false;
    _replies[commentUid] = (current ?? const _RepliesState())
        .copyWith(expanded: true, loading: !hadReplies);
    notifyListeners();

    if (hadReplies) return;

    try {
      final raw = await _commentRepo.listReplies(commentUid);
      _replies[commentUid] = _RepliesState(
        expanded: true,
        loading: false,
        replies: raw.map(commentFromTimelineComment).toList(),
      );
    } on ApiFailure {
      _replies[commentUid] =
          (_replies[commentUid] ?? const _RepliesState()).copyWith(
            loading: false,
          );
    } finally {
      notifyListeners();
    }
  }
}

@immutable
class _RepliesState {
  const _RepliesState({
    this.expanded = false,
    this.loading = false,
    this.replies = const [],
  });

  final bool expanded;
  final bool loading;
  final List<Comment> replies;

  _RepliesState copyWith({
    bool? expanded,
    bool? loading,
    List<Comment>? replies,
  }) {
    return _RepliesState(
      expanded: expanded ?? this.expanded,
      loading: loading ?? this.loading,
      replies: replies ?? this.replies,
    );
  }
}

final postDetailViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<PostDetailViewModel, String>((ref, uid) {
      return PostDetailViewModel(
        uid,
        ref.read(postRepositoryProvider),
        ref.read(commentRepositoryProvider),
        ref.read(postsCacheProvider),
      );
    });
