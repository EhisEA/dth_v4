import "package:cached_network_image/cached_network_image.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class UpcomingShows extends StatelessWidget {
  const UpcomingShows({
    super.key,
    this.imageUrl = "https://picsum.photos/seed/dth-upcoming/960/540",
    this.title = "DTH Tradition Royalty Week",
    this.description =
        "De9jaspiriTalentHunt is back, and this time it's bigger and better than ever before! Prepare yourself for an exhilarating experience filled with music, culture, and unforgettable performances.",
    this.location = "Calabar Int'l Event Center, Calabar",
    this.dateTimeLabel = "9 Sept., 2026 02:30AM",
    this.showDivider = true,
    this.onTap,
  });

  final String imageUrl;
  final String title;
  final String description;
  final String location;
  final String dateTimeLabel;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 130,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  ColoredBox(color: AppColors.baseShimmer(context)),
              errorWidget: (_, __, ___) => ColoredBox(
                color: AppColors.baseShimmer(context),
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.tint15,
                ),
              ),
            ),
          ),
          Gap.h8,
          AppText.regular(
            title,
            color: AppColors.black,
            fontSize: 14,
            maxLines: 2,
            multiText: true,
          ),
          Gap.h8,
          AppText.regular(
            description,
            color: const Color(0xff474954),
            fontSize: 12,
            maxLines: 2,
            multiText: true,
          ),
          Gap.h10,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _MetaChip(icon: SvgAssets.location, text: location),
              ),
              Gap.w10,
              Expanded(
                flex: 2,
                child: _MetaChip(icon: SvgAssets.clock, text: dateTimeLabel),
              ),
            ],
          ),
          if (showDivider) ...[
            Gap.h16,
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.greyTint25,
            ),
            Gap.h16,
          ],
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          width: 11,
          height: 11,
          colorFilter: ColorFilter.mode(AppColors.blackTint20, BlendMode.srcIn),
        ),
        Gap.w4,
        Expanded(
          child: AppText.regular(
            text,
            color: AppColors.blackTint20,
            fontSize: 10,
            maxLines: 2,
            multiText: true,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
