import "dart:ui" show ImageFilter;

import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/home/models/home_feed_models.dart";
import "package:flutter/material.dart";

class HomePostMedia extends StatelessWidget {
  const HomePostMedia({super.key, required this.post, this.onVideoTap});

  final HomePostItem post;
  final VoidCallback? onVideoTap;

  static const double _mediaHeight = 160;
  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    if (post.isVideo && post.video != null) {
      return _VideoBlock(
        thumbnailUrl: post.video!.thumbnailUrl,
        height: _mediaHeight,
        radius: _radius,
        onTap: onVideoTap,
      );
    }
    final urls = post.imageUrls;
    if (urls.isEmpty) {
      return const SizedBox.shrink();
    }
    return _ImageGalleryBlock(
      urls: urls,
      height: _mediaHeight,
      radius: _radius,
    );
  }
}

class _VideoBlock extends StatelessWidget {
  const _VideoBlock({
    required this.thumbnailUrl,
    required this.height,
    required this.radius,
    this.onTap,
  });

  final String thumbnailUrl;
  final double height;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Material(
        color: Colors.black,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      ColoredBox(color: AppColors.baseShimmer(context)),
                ),
                const ColoredBox(color: Color(0x33000000)),
                Center(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        color: Colors.black.withValues(alpha: 0.55),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageGalleryBlock extends StatelessWidget {
  const _ImageGalleryBlock({
    required this.urls,
    required this.height,
    required this.radius,
  });

  final List<String> urls;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final n = urls.length;
    if (n == 1) {
      return _one(urls.first, context);
    }
    if (n == 2) {
      return SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: _cell(urls[0], context),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: _cell(urls[1], context),
              ),
            ),
          ],
        ),
      );
    }

    final extra = n - 3;
    final r = Radius.circular(radius);
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.all(r),
              child: _cell(urls[0], context),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(r),
                    child: _cell(urls[1], context),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(r),
                    child: extra > 0
                        ? _cellWithOverlay(urls[2], context, '+$extra')
                        : _cell(urls[2], context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _one(String url, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: _cell(url, context),
      ),
    );
  }

  Widget _cell(String url, BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => ColoredBox(
        color: AppColors.baseShimmer(context),
        child: Icon(Icons.broken_image_outlined, color: AppColors.tint15),
      ),
    );
  }

  Widget _cellWithOverlay(
    String url,
    BuildContext context,
    String overlayText,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _cell(url, context),
        ColoredBox(
          color: const Color(0x99000000),
          child: Center(
            child: Text(
              overlayText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
