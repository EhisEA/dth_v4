import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/tickets/components/show_about_event_panel.dart";
import "package:dth_v4/features/tickets/components/show_buy_ticket.dart";
import "package:dth_v4/features/tickets/components/show_detail_hero.dart";
import "package:dth_v4/features/tickets/components/show_event_quick_info_row.dart";
import "package:dth_v4/features/tickets/components/show_status_chip.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_utils/flutter_utils.dart";

class ShowView extends StatelessWidget {
  const ShowView({
    super.key,
    this.heroImageUrl =
        "https://images.pexels.com/photos/37054685/pexels-photo-37054685.jpeg",
    this.statusLabel = "Upcoming",
    this.eventTitle = "Week 3: DTH Tradition Royalty Week",
    this.eventLocation = "Calabar Int'l Event Center, Calabar",
    this.eventDateTimeLine = "9 Sept, 2026 02:30AM",
    this.aboutBody = kDefaultAboutBody,
    this.detailDate = "9 September, 2026",
    this.detailTime = "9 AM",
    this.detailVenue = "Calabar International Event Center, Calabar",
    this.ticketsAvailable = 546,
    this.onShare,
    this.onBuyTicket,
  });

  static const String path = NavigatorRoutes.show;

  final String heroImageUrl;
  final String statusLabel;
  final String eventTitle;
  final String eventLocation;
  final String eventDateTimeLine;
  final String aboutBody;
  final String detailDate;
  final String detailTime;
  final String detailVenue;
  final int ticketsAvailable;
  final VoidCallback? onShare;
  final VoidCallback? onBuyTicket;

  static const String kDefaultAboutBody =
      "De9jaspiriTalentHunt is back, and this time it's bigger and better than ever before! Prepare yourself for an exhilarating experience filled with music, culture, and unforgettable performances.\n\n"
      "Whether you are cheering from the crowd or joining us online, this week celebrates tradition, royalty, and the journey from street to stardom.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShowDetailHero(imageUrl: heroImageUrl, onShare: onShare),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -25),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShowStatusChip(label: statusLabel),
                      Gap.h16,
                      AppText.medium(
                        eventTitle,
                        fontSize: 16,
                        color: AppColors.black,
                        maxLines: 2,
                        letterSpacing: -0.4,
                      ),
                      Gap.h4,
                      ShowEventQuickInfoRow(
                        location: eventLocation,
                        dateTimeLine: eventDateTimeLine,
                      ),
                      Gap.h16,
                      ShowAboutEventPanel(
                        aboutBody: aboutBody,
                        detailDate: detailDate,
                        detailTime: detailTime,
                        detailVenue: detailVenue,
                      ),
                      Gap.h16,
                      ShowBuyTicket(
                        availabilityLabel: "($ticketsAvailable available)",
                        onPressed: onBuyTicket,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
