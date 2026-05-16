import "package:cached_network_image/cached_network_image.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_utils/flutter_utils.dart";

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item, required this.onTap});

  final NotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LeadingAvatar(item: item),
            Gap.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _TitleText(item: item)),
                      if (!item.isRead) ...[
                        Gap.w8,
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.redTint35,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (item.createdAt.isNotEmpty) ...[
                    Gap.h4,
                    AppText.regular(
                      item.createdAt,
                      fontSize: 11,
                      color: AppColors.tint15,
                    ),
                  ],
                  if (item.description.isNotEmpty) ...[
                    Gap.h8,
                    _DescriptionText(description: item.description),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadingAvatar extends StatelessWidget {
  const _LeadingAvatar({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    if (item.isSystemStyle) {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          SvgAssets.homeStar,
          width: 18,
          height: 18,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      );
    }

    final avatar = item.user?.avatar?.trim() ?? "";
    final name = item.user?.name?.trim() ?? "";
    final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";

    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.baseShimmer(context),
      backgroundImage: avatar.isNotEmpty
          ? CachedNetworkImageProvider(avatar)
          : null,
      child: avatar.isNotEmpty
          ? null
          : AppText.regular(
              initial,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.paleLavender,
            ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final prefix = item.titleBoldPrefix;
    if (prefix == null) {
      return AppText.regular(
        item.title,
        fontSize: 14,
        color: AppColors.black,
        height: 1.3,
        multiText: true,
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: TextStyle(
              fontFamily: "Hanken Grotesk",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              height: 1.3,
            ),
          ),
          if (item.titleRemainder.isNotEmpty)
            TextSpan(
              text: " ${item.titleRemainder}",
              style: TextStyle(
                fontFamily: "Hanken Grotesk",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.blackTint20,
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText({required this.description});

  static const String _readMoreLabel = "Read More";

  final String description;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final baseStyle = TextStyle(
          fontFamily: "Hanken Grotesk",
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.blackTint20,
          height: 1.35,
        );
        final readMoreStyle = baseStyle.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        );

        final painter = TextPainter(
          text: TextSpan(text: description, style: baseStyle),
          maxLines: 2,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        if (!painter.didExceedMaxLines) {
          return Text(description, style: baseStyle);
        }

        final readMorePainter = TextPainter(
          text: TextSpan(text: " $_readMoreLabel", style: readMoreStyle),
          maxLines: 1,
          textDirection: Directionality.of(context),
        )..layout();

        final readMoreWidth = readMorePainter.width;
        var end = description.length;
        const ellipsis = "…";

        while (end > 0) {
          final candidate =
              "${description.substring(0, end).trimRight()}$ellipsis";
          final testPainter = TextPainter(
            text: TextSpan(text: candidate, style: baseStyle),
            maxLines: 2,
            textDirection: Directionality.of(context),
          )..layout(maxWidth: constraints.maxWidth - readMoreWidth);

          if (!testPainter.didExceedMaxLines) {
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: candidate, style: baseStyle),
                  TextSpan(text: " $_readMoreLabel", style: readMoreStyle),
                ],
              ),
            );
          }
          end--;
        }

        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: description, style: baseStyle),
              TextSpan(text: " $_readMoreLabel", style: readMoreStyle),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
