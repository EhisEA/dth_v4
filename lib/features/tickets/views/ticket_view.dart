import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/tickets/tickets.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_utils/flutter_utils.dart";

class TicketView extends StatefulWidget {
  const TicketView({super.key});

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.h10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppText.medium(
                  "Tickets",
                  fontSize: 24,
                  color: AppColors.tertiary60,
                ),
              ),
              Gap.h8,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppText.regular(
                  "Don’t miss out — get your tickets and join the show live.",
                  fontSize: 14,
                  color: AppColors.paleLavender,
                ),
              ),
              Gap.h16,
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.medium(
                            "Upcoming Shows",
                            fontSize: 12,
                            color: AppColors.black,
                          ),
                          GestureDetector(
                            onTap: () {
                              MobileNavigationService.instance.navigateTo(
                                UpcomingShowsView.path,
                              );
                            },
                            behavior: HitTestBehavior.opaque,
                            child: AppText.regular(
                              "See all",
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap.h12,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: List.generate(10, (index) {
                          final cardWidth = context.width * 0.7;
                          return Padding(
                            padding: EdgeInsets.only(right: index < 9 ? 12 : 0),
                            child: SizedBox(
                              width: cardWidth,
                              child: UpcomingShowsComponent(
                                imageUrl:
                                    "https://picsum.photos/seed/tickets-upcoming-$index/960/540",
                                showLocation: false,
                                showDescription: false,
                                showDivider: false,
                                onTap: () {},
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Gap.h24,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppText.medium(
                        "Booked Shows",
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                    ),
                    Gap.h12,
                    ...List.generate(
                      3,
                      (index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (index > 0) Gap.h24,
                          BookedShowsComponent(
                            imageUrl:
                                "https://picsum.photos/seed/dth-ticket-$index/400/400",
                            scheduleLabel: index == 0
                                ? "19 Sept., 2026 02:30AM"
                                : "22 Sept., 2026 07:00PM",
                            onReadMore: () {},
                            onViewTickets: () {
                              MobileNavigationService.instance.navigateTo(
                                ShowView.path,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Gap.h(100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
