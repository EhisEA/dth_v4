import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/tickets/components/upcoming_shows_component.dart";
import "package:dth_v4/widgets/dth_appbar.dart";
import "package:flutter/material.dart";

class UpcomingShowsView extends StatelessWidget {
  const UpcomingShowsView({super.key});

  static const String path = NavigatorRoutes.upcomingShows;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: DthAppBar(title: "Upcoming Shows"),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            ...List.generate(
              10,
              (index) => UpcomingShowsComponent(
                imageUrl:
                    "https://picsum.photos/seed/tickets-upcoming-$index/960/540",
                showDivider: index < 9,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
