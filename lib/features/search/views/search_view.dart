import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/features/search/search.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
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
                Gap.h10,
                SearchHeader(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  onSupportTap: () {},
                ),
                Gap.h16,
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 100),
                    children: [
                      SearchTrendingReels(),
                      Gap.h24,
                      AppText.medium(
                        "Upcoming Shows",
                        color: AppColors.black,
                        fontSize: 12,
                      ),
                      Gap.h12,
                      ...List.generate(
                        2,
                        (index) => UpcomingShows(showDivider: index < 1),
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
