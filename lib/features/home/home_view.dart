import "package:dth_v4/core/router/router.dart";
import "package:dth_v4/features/home/components/home_header.dart";
import "package:dth_v4/features/home/components/home_post_card.dart";
import "package:dth_v4/features/home/components/home_stories_bar.dart";
import "package:dth_v4/features/home/models/home_feed_models.dart";
import "package:dth_v4/features/stories/views/stories_view.dart";
import "package:flutter/material.dart";
import "package:flutter_utils/flutter_utils.dart";

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String path = NavigatorRoutes.home;

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
  ];

  static final List<HomePostItem> _mockPosts = [
    HomePostItem(
      authorName: "DE9JASPIRIT★",
      withName: "Osakpolo Evans",
      timeAgo: "14 Hours ago",
      description:
          "This is a sample caption for a video post. It can run longer than two lines so you can see how the ellipsis and Read more behave when the text does not fit in the allowed space.",
      likeCount: 361,
      commentCount: 24,
      shareCount: 12,
      video: const HomePostVideo(
        thumbnailUrl: "https://picsum.photos/seed/video1/800/450",
      ),
    ),
    HomePostItem(
      authorName: "DE9JASPIRIT★",
      withName: "Osakpolo Evans",
      timeAgo: "1 Day ago",
      description:
          "Gallery post with five images — layout shows one large tile and two stacked on the right; the last tile shows how many additional photos are in the set.",
      likeCount: 120,
      commentCount: 8,
      shareCount: 3,
      imageUrls: [
        "https://picsum.photos/seed/g1/600/800",
        "https://picsum.photos/seed/g2/400/400",
        "https://picsum.photos/seed/g3/400/400",
        "https://picsum.photos/seed/g4/400/400",
        "https://picsum.photos/seed/g5/400/400",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.paddingOf(context).bottom + 100; // tab bar + home indicator
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeHeader(onLiveTap: () {}, onNotificationTap: () {}),
                Gap.h16,
                HomeStoriesBar(
                  stories: _mockStories,
                  onStoryTap: (story) {
                    MobileNavigationService.instance.push(
                      StoriesView.path,
                      extra: {RoutingArgumentKey.imageUrl: story.imageUrl},
                    );
                  },
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: bottomInset, top: 32),
                    itemCount: _mockPosts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 28),
                    itemBuilder: (context, index) {
                      final post = _mockPosts[index];
                      return HomePostCard(
                        post: post,
                        onVideoTap: () {},
                        onReadMore: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
