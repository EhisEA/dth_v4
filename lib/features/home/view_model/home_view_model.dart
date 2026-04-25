import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/home/models/home_feed_models.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";
import "package:intl/intl.dart";

class HomeViewModel extends BaseChangeNotifierViewModel {
  HomeViewModel(this.userState, this._timelineRepo);

  final UserState userState;
  final TimelineRepo _timelineRepo;

  ValueNotifier<UserModel?> get userModel => userState.user;
  List<HomePostItem> _posts = const [];
  List<HomeStoryItem> _stories = const [];

  List<HomePostItem> get posts => _posts;

  List<HomeStoryItem> get stories => _stories;

  Future<void> loadTimeline() async {
    try {
      changeBaseState(const ViewModelState.busy());

      final posts = await _timelineRepo.fetchTimeline();
      _posts = posts.map(_timelinePostToHomeItem).toList();

      try {
        final reels = await _timelineRepo.fetchTimelineReels();
        _stories = reels.map(_reelToHomeStory).toList();
      } on ApiFailure {
        _stories = const [];
      }

      changeBaseState(const ViewModelState.idle());
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
    }
  }

  Future<void> refreshTimeline() async {
    try {
      final posts = await _timelineRepo.fetchTimeline();
      _posts = posts.map(_timelinePostToHomeItem).toList();
    } on ApiFailure catch (e) {
      DthFlushBar.instance.showError(message: e.message, title: "Failed");
      notifyListeners();
      return;
    }

    try {
      final reels = await _timelineRepo.fetchTimelineReels();
      _stories = reels.map(_reelToHomeStory).toList();
    } on ApiFailure catch (e) {
      DthFlushBar.instance.showError(message: e.message, title: "Reels");
    }

    notifyListeners();
  }
}

(String, String?) _parseTitle(String title) {
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

String _timeAgo(String createdAt) {
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

HomePostItem _timelinePostToHomeItem(TimelinePost p) {
  final parsed = _parseTitle(p.title);
  final authorName = parsed.$1;
  final withName = parsed.$2;
  final typeLower = p.type.trim().toLowerCase();
  final thumb = p.videoThumbnail?.trim() ?? "";
  final isVideo = typeLower == "video" && thumb.isNotEmpty;

  final imageUrls = <String>[];
  if (!isVideo && p.media != null) {
    imageUrls.addAll(p.media!);
  }

  return HomePostItem(
    authorName: authorName,
    withName: withName,
    timeAgo: _timeAgo(p.createdAt),
    description: p.description.trim(),
    likeCount: p.counts.reactions,
    commentCount: p.counts.comments,
    shareCount: p.counts.shares,
    video: isVideo ? HomePostVideo(thumbnailUrl: thumb) : null,
    imageUrls: imageUrls,
  );
}

HomeStoryItem _reelToHomeStory(TimelineReel r) {
  final thumb = r.media?.thumbnail?.trim();
  final videoThumb = r.videoThumbnail?.trim();
  final mediaUrl = r.media?.url?.trim();
  final imageUrl = (thumb != null && thumb.isNotEmpty)
      ? thumb
      : (videoThumb != null && videoThumb.isNotEmpty)
      ? videoThumb
      : (mediaUrl ?? "");
  final label = r.title.trim().isNotEmpty ? r.title.trim() : "Reel";
  return HomeStoryItem(imageUrl: imageUrl, label: label);
}

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  return HomeViewModel(
    ref.read(userStateProvider),
    ref.read(timelineRepositoryProvider),
  );
});
