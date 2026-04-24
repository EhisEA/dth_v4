import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/features/home/home.dart';
import 'package:dth_v4/features/stories/stories.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';

class SearchTrendingReels extends StatelessWidget {
  const SearchTrendingReels({super.key});

  static final List<HomeStoryItem> _mockStories = [
    const HomeStoryItem(
      imageUrl: "https://picsum.photos/seed/dth1/200",
      label: "Day One: Auditi...",
    ),
    const HomeStoryItem(
      imageUrl: "https://picsum.photos/seed/dth2/200",
      label: "Behind scenes",
    ),
    const HomeStoryItem(
      imageUrl: "https://picsum.photos/seed/dth3/200",
      label: "Meet the judges",
    ),
    const HomeStoryItem(
      imageUrl: "https://picsum.photos/seed/dth2/200",
      label: "Behind scenes",
    ),
    const HomeStoryItem(
      imageUrl: "https://picsum.photos/seed/dth3/200",
      label: "Meet the judges",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium("Trending Reels", color: AppColors.black, fontSize: 12),
        Gap.h8,
        HomeStoriesBar(
          stories: _mockStories,
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
