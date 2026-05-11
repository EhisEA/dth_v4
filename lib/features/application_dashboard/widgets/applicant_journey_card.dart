import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class ApplicantJourneyCard extends StatelessWidget {
  const ApplicantJourneyCard({
    super.key,
    required this.card,
    required this.width,
    this.onCta,
  });

  final JourneyCard card;
  final double width;
  final void Function(JourneyCta cta)? onCta;

  @override
  Widget build(BuildContext context) {
    final title = card.title?.trim() ?? "";
    final body = card.body?.trim() ?? "";
    final chip = card.statusChip;
    final cta = card.cta;

    return Container(
      width: width,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyTint30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title.isNotEmpty)
            AppText.medium(
              title,
              fontSize: 14,
              color: AppColors.black,
              maxLines: 2,
            ),
          if (title.isNotEmpty && body.isNotEmpty) Gap.h4,
          if (body.isNotEmpty)
            AppText.regular(
              body,
              fontSize: 10,
              color: AppColors.black,
              maxLines: 5,
              multiText: true,
            ),
          const Spacer(),
          if (cta != null && cta.enabled && cta.label.isNotEmpty) ...[
            const SizedBox(height: 14),
            AppButton.primary(
              text: cta.label,
              width: double.infinity,
              fontSize: 12,
              height: 36,
              radius: 100,
              press: () => onCta?.call(cta),
            ),
          ] else if (chip != null && !chip.isEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                SvgPicture.asset(
                  chipSvgAsset(chip.icon),
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(
                    AppColors.tint15,
                    BlendMode.srcIn,
                  ),
                ),
                Gap.w4,
                Expanded(
                  child: AppText.regular(
                    chip.label,
                    fontSize: 10,
                    color: AppColors.blackTint20,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String chipSvgAsset(String? icon) {
    switch (icon?.toLowerCase()) {
      case "schedule":
      case "clock":
        return SvgAssets.clock;
      case "check":
      case "success":
        return SvgAssets.check;
      case "info":
        return SvgAssets.infoOutline;
      default:
        return SvgAssets.rightArrow;
    }
  }
}
