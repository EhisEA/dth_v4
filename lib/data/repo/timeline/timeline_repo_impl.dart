import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class TimelineRepoImpl implements TimelineRepo {
  TimelineRepoImpl({required NetworkService networkService})
    : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<List<TimelinePost>> fetchTimeline() async {
    final response = await _networkService.get(ApiRoute.timeline);
    final root = response.data;
    if (root is! Map<String, dynamic>) {
      return const [];
    }
    final data = root["data"];
    if (data is! Map<String, dynamic>) {
      return const [];
    }
    final posts = data["posts"];
    if (posts is! List<dynamic>) {
      return const [];
    }
    return posts
        .map((e) {
          if (e is! Map) return null;
          return TimelinePost.fromJson(Map<String, dynamic>.from(e));
        })
        .whereType<TimelinePost>()
        .toList();
  }

  @override
  Future<List<TimelineReel>> fetchTimelineReels() async {
    final response = await _networkService.get(ApiRoute.timelineReels);
    final root = response.data;
    if (root is! Map<String, dynamic>) {
      return const [];
    }
    final data = root["data"];
    if (data is! Map<String, dynamic>) {
      return const [];
    }
    final reels = data["reels"];
    if (reels is! List<dynamic>) {
      return const [];
    }
    return reels
        .map((e) {
          if (e is! Map) return null;
          return TimelineReel.fromJson(Map<String, dynamic>.from(e));
        })
        .whereType<TimelineReel>()
        .toList();
  }
}

final timelineRepositoryProvider = Provider<TimelineRepo>((ref) {
  return TimelineRepoImpl(networkService: ref.read(networkServiceProvider));
});
