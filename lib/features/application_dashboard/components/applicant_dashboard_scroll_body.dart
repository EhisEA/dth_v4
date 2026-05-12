import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/application_dashboard/applicant_dashboard.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_utils/flutter_utils.dart";

class ApplicantDashboardScrollBody extends StatelessWidget {
  const ApplicantDashboardScrollBody({
    super.key,
    required this.data,
    required this.viewModel,
  });

  final ApplicantDashboardData data;
  final ApplicantDashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final perf = data.performance;
    final arcColor = applicantPerformanceArcColor(perf.color);
    final caption = viewModel.performanceCaption(data);
    final journeyTitle = viewModel.journeySectionTitle(data);
    final rows = viewModel.journeyGridRows(data);

    return RefreshIndicator(
      onRefresh: viewModel.refreshDashboard,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        children: [
          Gap.h32,
          Gap.h32,
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: ApplicantPerformanceGauge(
              score: perf.score,
              max: perf.max,
              arcColor: arcColor,
              label: perf.label,
              caption: caption,
            ),
          ),
          if (data.banner != null) ...[
            ApplicantDashboardInlineBanner(
              banner: data.banner!,
              backgroundColor: viewModel.bannerBackgroundForVariant(
                data.banner!.variant,
              ),

              bodyColor: viewModel.bannerBodyTextColorForVariant(
                data.banner!.variant,
              ),
            ),
            Gap.h16,
          ],
          AppText.medium(journeyTitle, fontSize: 14, color: AppColors.black),
          Gap.h12,
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 8.0;
              final cellWidth = (constraints.maxWidth - spacing) / 2;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var r = 0; r < rows.length; r++) ...[
                    if (r > 0) SizedBox(height: spacing),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: cellWidth,
                          child: ApplicantJourneyCard(
                            card: rows[r][0]!,
                            width: cellWidth,
                            onCta: viewModel.handleJourneyCta,
                          ),
                        ),
                        SizedBox(width: spacing),
                        SizedBox(
                          width: cellWidth,
                          child: rows[r][1] != null
                              ? ApplicantJourneyCard(
                                  card: rows[r][1]!,
                                  width: cellWidth,
                                  onCta: viewModel.handleJourneyCta,
                                )
                              : SizedBox(width: cellWidth),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
          if (data.footerBanner != null) ...[
            Gap.h12,
            ApplicantDashboardInlineBanner(
              banner: data.footerBanner!,
              backgroundColor: viewModel.bannerBackgroundForVariant(
                data.footerBanner!.variant,
              ),
              bodyColor: viewModel.bannerBodyTextColorForVariant(
                data.footerBanner!.variant,
              ),
              svg: viewModel.iconForVariant(data.footerBanner!.variant),
            ),
          ],
          Gap.h24,
        ],
      ),
    );
  }
}
