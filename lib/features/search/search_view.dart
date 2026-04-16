import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/features/home/components/home_stories_bar.dart';
import 'package:dth_v4/features/home/models/home_feed_models.dart';
import 'package:dth_v4/features/stories/views/stories_view.dart';
import 'package:dth_v4/widgets/text/textstyles.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  static const String path = NavigatorRoutes.search;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final FocusNode _searchFocus;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchFocus = FocusNode();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppTextField(
                        hint: 'Search contents and events',
                        controller: _searchController,
                        focusNode: _searchFocus,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        borderRadius: BorderRadius.circular(100),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        formatter: [
                          FilteringTextInputFormatter.singleLineFormatter,
                        ],
                        hintStyle: AppTextStyle.regular.copyWith(
                          color: AppColors.tint15,
                          fontSize: 14,
                          letterSpacing: -0.2,
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                          maxHeight: 20,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.asset(
                            SvgAssets.search,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.mainBlack,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap.w12,
                    GestureDetector(
                      onTap: () => HapticFeedback.lightImpact(),
                      behavior: HitTestBehavior.opaque,
                      child: SvgPicture.asset(
                        SvgAssets.support,

                        colorFilter: ColorFilter.mode(
                          AppColors.tint15,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap.h30,
                Expanded(
                  child: ListView(
                    children: [
                      HomeStoriesBar(
                        stories: _mockStories,
                        onStoryTap: (story) {
                          MobileNavigationService.instance.push(
                            StoriesView.path,
                            extra: {
                              RoutingArgumentKey.imageUrl: story.imageUrl,
                            },
                          );
                        },
                      ),
                    ],
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
