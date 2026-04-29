import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/features/home/home.dart';
import 'package:dth_v4/features/stories/stories.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

class SearchTrendingReels extends ConsumerStatefulWidget {
  const SearchTrendingReels({super.key});

  @override
  ConsumerState<SearchTrendingReels> createState() =>
      _SearchTrendingReelsState();
}

class _SearchTrendingReelsState extends ConsumerState<SearchTrendingReels> {
  bool _isLoading = true;
  List<HomeStoryItem> _stories = const [];

  @override
  void initState() {
    super.initState();
    _loadReels();
  }

  Future<void> _loadReels() async {
    try {
      final reels = await ref
          .read(timelineRepositoryProvider)
          .fetchTimelineReels();
      if (!mounted) return;
      setState(() {
        _stories = reels.map(_reelToStory).toList();
        _isLoading = false;
      });
    } on ApiFailure {
      if (!mounted) return;
      setState(() {
        _stories = const [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }
    if (_stories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium("Trending Reels", color: AppColors.black, fontSize: 12),
        Gap.h8,
        HomeStoriesBar(
          stories: _stories,
          onStoryTap: (story) {
            MobileNavigationService.instance.push(
              StoriesView.path,
              extra: {RoutingArgumentKey.imageUrl: story.imageUrl},
            );
          },
        ),
      ],
    );
  }
}

HomeStoryItem _reelToStory(TimelineReel reel) {
  final thumb = reel.media?.thumbnail?.trim();
  final videoThumb = reel.videoThumbnail?.trim();
  final mediaUrl = reel.media?.url?.trim();
  final imageUrl = (thumb != null && thumb.isNotEmpty)
      ? thumb
      : (videoThumb != null && videoThumb.isNotEmpty)
      ? videoThumb
      : (mediaUrl ?? "");
  final label = reel.title.trim().isNotEmpty ? reel.title.trim() : "Reel";
  return HomeStoryItem(imageUrl: imageUrl, label: label);
}
