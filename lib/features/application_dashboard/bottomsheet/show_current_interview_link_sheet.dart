import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_utils/flutter_utils.dart";

/// Small grey label above the join URL. API `title` is often "Join your interview";
/// Figma uses this line instead.
const String _kInterviewLinkSheetLabel = "Your interview link:";

const String _kAlrightGotIt = "Alright. Got it!";

const String _kWhatYouNeedTitle = "What you need to know:";

/// Static copy until backend provides a `tips` array on the payload.
const List<String> _kInterviewTips = [
  "Copy the interview link using the copy button, then paste it into your browser or meeting app to join.",
  "Join the session at least 5 minutes before your scheduled time.",
  "Ensure your audio and video are enabled and working correctly before joining.",
  "Position yourself in a well-lit, distraction-free environment.",
  "Ensure you have a reliable internet connection for a smooth interview experience.",
];

/// `GET /applicant/interview-bookings/current` — join URL, countdown, tips, dismiss.
Future<void> showCurrentInterviewLinkSheet(
  BuildContext context, {
  required CurrentInterviewBookingPayload payload,
}) {
  return showBlurredModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    builder: (ctx) => _CurrentInterviewLinkSheetBody(payload: payload),
  );
}

String _startsInLine(CurrentInterviewBookingPayload p) {
  final start = p.startsAt;
  if (start == null) {
    return p.subtitle.trim();
  }
  final now = DateTime.now().toUtc();
  final s = start.toUtc();
  if (!s.isAfter(now)) {
    final sub = p.subtitle.trim();
    return sub.isNotEmpty ? sub : "Starting soon";
  }
  var diff = s.difference(now);
  final days = diff.inDays;
  diff -= Duration(days: days);
  final hours = diff.inHours;
  diff -= Duration(hours: hours);
  final mins = diff.inMinutes;
  final parts = <String>[];
  if (days > 0) {
    parts.add("$days ${days == 1 ? "day" : "days"}");
  }
  if (hours > 0) {
    parts.add("$hours ${hours == 1 ? "hour" : "hours"}");
  }
  if (mins > 0 || parts.isEmpty) {
    parts.add("$mins ${mins == 1 ? "min" : "mins"}");
  }
  return "Starts in ${parts.join(" ")}";
}

class _CurrentInterviewLinkSheetBody extends StatelessWidget {
  const _CurrentInterviewLinkSheetBody({required this.payload});

  final CurrentInterviewBookingPayload payload;

  void _onPrimary(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final join = payload.joinUrl.trim();
    final canOpen = join.isNotEmpty;
    final countdown = _startsInLine(payload).trim();
    final primaryLabel = (payload.cta?.label ?? "").trim().isNotEmpty
        ? payload.cta!.label.trim()
        : _kAlrightGotIt;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: AppColors.greyTint20,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).maybePop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.mainBlack,
                    ),
                  ),
                ),
              ),
            ),
            Gap.h8,
            AppText.regular(
              _kInterviewLinkSheetLabel,
              fontSize: 12,
              color: AppColors.blackTint20,
              textAlign: TextAlign.center,
              multiText: true,
            ),
            Gap.h10,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: canOpen
                      ? AppText.medium(
                          join,
                          fontSize: 16,
                          color: AppColors.black,
                          multiText: true,
                          maxLines: 8,
                        )
                      : AppText.medium(
                          "—",
                          fontSize: 16,
                          color: AppColors.blackTint20,
                        ),
                ),
                if (canOpen) ...[
                  Gap.w8,
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: join));
                        HapticFeedback.lightImpact();
                        DthFlushBar.instance.showSuccess(
                          title: "Copied",
                          message: "Interview link copied to clipboard.",
                        );
                      },
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          SvgAssets.copyOutline,
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (countdown.isNotEmpty) ...[
              Gap.h8,
              AppText.regular(
                countdown,
                fontSize: 12,
                color: AppColors.blackTint20,
                textAlign: TextAlign.center,
                multiText: true,
              ),
            ],
            Gap.h20,
            Container(
              decoration: BoxDecoration(
                color: AppColors.dth100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText.medium(
                    _kWhatYouNeedTitle,
                    fontSize: 12,
                    color: AppColors.dthBlue,
                    textAlign: TextAlign.center,
                    multiText: true,
                  ),
                  Gap.h12,
                  for (var i = 0; i < _kInterviewTips.length; i++) ...[
                    if (i > 0)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xffEDEDED),
                      ),
                    if (i > 0) Gap.h10,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.done_all,
                          size: 18,
                          color: AppColors.mainBlack,
                        ),
                        Gap.w10,
                        Expanded(
                          child: AppText.regular(
                            _kInterviewTips[i],
                            fontSize: 11,
                            color: AppColors.blackTint20,
                            height: 1.35,
                            multiText: true,
                          ),
                        ),
                      ],
                    ),
                    if (i < _kInterviewTips.length - 1) Gap.h10,
                  ],
                ],
              ),
            ),
            Gap.h24,
            AppButton.primary(
              text: primaryLabel,
              width: double.infinity,
              height: 48,
              radius: 100,
              press: () => _onPrimary(context),
            ),
            Gap.h8,
          ],
        ),
      ),
    );
  }
}
