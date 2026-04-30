import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/polls/components/poll_option_data.dart";
import "package:dth_v4/features/polls/components/poll_option_tile.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";
import "package:intl/intl.dart";

class PollComponent extends StatelessWidget {
  const PollComponent({
    super.key,
    required this.pollListenable,
    required this.onVoteTap,
    this.isVoteBusy = false,
  });

  final ValueListenable<PollModel?> pollListenable;
  final ValueChanged<String> onVoteTap;
  final bool isVoteBusy;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PollModel?>(
      valueListenable: pollListenable,
      builder: (context, poll, child) {
        if (poll == null) return const SizedBox.shrink();

        final canVote = !poll.hasEnded && !poll.hasVoted && !isVoteBusy;
        final showResults = poll.hasVoted;
        final options = poll.options
            .map(
              (option) => PollOptionData(
                uid: option.uid,
                title: option.name,
                percentage: option.percentage,
                progress: showResults
                    ? (option.percentage / 100).clamp(0.0, 1.0)
                    : 0,
                selected: showResults && poll.votedOptionUid == option.uid,
              ),
            )
            .toList();

        final hasEnded = poll.hasEnded || poll.status.toLowerCase() == "ended";
        final statusText = hasEnded ? "Ended" : poll.timeLeft;
        final statusBg = hasEnded
            ? AppColors.redTint35.withValues(alpha: 0.08)
            : AppColors.dth100;
        final statusTextColor = hasEnded
            ? AppColors.redTint35
            : AppColors.secondaryBlue;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap.h12,
            Row(
              children: [
                SvgPicture.asset(SvgAssets.primaryLogo, height: 28, width: 28),
                Gap.w12,
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(SvgAssets.blackLogo, height: 24),
                      Gap.w4,
                      AppText.regular(
                        "with",
                        fontSize: 10,
                        color: AppColors.blackTint20,
                      ),
                      Gap.w4,
                      AppText.medium(
                        "All Contestants",
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: AppText.medium(
                          statusText,
                          fontSize: 10,
                          color: statusTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap.h8,
            AppText.regular(
              '${poll.question} ${poll.description}'.trim(),
              fontSize: 12,
              color: AppColors.black,
              multiText: true,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            Gap.h8,
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 14,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xffD2D2D2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        child: Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xffD2D2D2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap.w4,
                AppText.regular(
                  "Select one",
                  fontSize: 10,
                  color: AppColors.blackTint20,
                ),
                const Spacer(),
                SvgPicture.asset(
                  SvgAssets.verifyActive,
                  height: 12,
                  width: 12,
                  colorFilter: ColorFilter.mode(
                    AppColors.tint10,
                    BlendMode.srcIn,
                  ),
                ),
                Gap.w2,
                AppText.regular(
                  "${NumberFormat.decimalPattern().format(poll.totalVotes)} total points",
                  fontSize: 10,
                  color: AppColors.blackTint20,
                ),
              ],
            ),
            Gap.h16,
            for (final option in options) ...[
              PollOptionTile(
                data: option,
                enabled: canVote,
                isBusy: isVoteBusy,
                onTap: () => onVoteTap(option.uid),
              ),
              Gap.h16,
            ],
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 16,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            SvgAssets.verifyActive,
                            height: 12,
                            width: 12,
                            colorFilter: ColorFilter.mode(
                              AppColors.dthBlue,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            SvgAssets.verifyActive,
                            height: 12,
                            width: 12,
                            colorFilter: ColorFilter.mode(
                              AppColors.dthBlue,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap.w4,
                AppText.regular(
                  poll.totalVotesDescription,
                  fontSize: 10,
                  color: AppColors.blackTint20,
                  letterSpacing: -0.3,
                ),
              ],
            ),
            Gap.h8,
          ],
        );
      },
    );
  }
}
