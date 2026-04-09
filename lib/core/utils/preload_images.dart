import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class PreLoadImage {
  static Future<Image> loadImg(BuildContext context, String path) async {
    final image = Image.asset(path);
    await precacheImage(image.image, context);
    return image;
  }

  static Future<void> precacheSvgPicture(String svgPath) async {
    final logo = SvgAssetLoader(svgPath);
    await svg.cache.putIfAbsent(
      logo.cacheKey(null),
      () => logo.loadBytes(null),
    );
  }
}
