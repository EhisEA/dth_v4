import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/home/models/home_feed_models.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_utils/flutter_utils.dart";

class HomeStoriesBar extends StatelessWidget {
  const HomeStoriesBar({super.key, required this.stories, this.onStoryTap});

  final List<HomeStoryItem> stories;
  final void Function(HomeStoryItem story)? onStoryTap;

  static const double _ringSize = 80;
  static const double _borderWidth = 3;

  static const _ringGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00AD55), Color(0xFF284B9A)],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _ringSize + 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => Gap.w8,
        itemBuilder: (context, index) {
          final s = stories[index];
          return GestureDetector(
            onTap: () => onStoryTap?.call(s),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: _ringSize,
                    height: _ringSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _ringGradient,
                    ),
                    padding: const EdgeInsets.all(_borderWidth),
                    child: Container(
                      padding: const EdgeInsets.all(_borderWidth),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          s.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => ColoredBox(
                            color: AppColors.baseShimmer(context),
                            child: Icon(
                              Icons.image_outlined,
                              color: AppColors.tint15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap.h6,
                  AppText.regular(
                    s.label,
                    fontSize: 11,
                    maxLines: 1,
                    color: const Color(0xff08102F),
                    height: 1.2,
                    centered: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
