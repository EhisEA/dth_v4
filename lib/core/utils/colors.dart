import "package:flutter/material.dart";

class AppColors {
  static Color _themeColor(BuildContext context, Color light, Color dark) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  static const Color primary = Color(0xFF00AD55);
  static const Color black = Color(0xff000000);
  static Color white = const Color(0xffffffff);
  static Color tint15 = const Color(0xff8F8F8F);

  ///=========================== Bottom Nav ==============================

  static Color baseShimmerLight = const Color(0xFFEDEDED);
  static Color baseShimmerDark = const Color(0xFF013546);
  // static Color get baseShimmer {
  //   return _themeViewModel.isLightMode ? baseShimmerLight : baseShimmerDark;
  // }

  static Color baseShimmer(BuildContext context) {
    return _themeColor(context, baseShimmerLight, baseShimmerDark);
  }

  static Color hightlightShimmerLight = const Color(0xFFF8F7FA);
  static Color hightlightShimmerDark = const Color(0xFF01455B);
  // static Color get hightlightShimmer {
  //   return _themeViewModel.isLightMode
  //       ? hightlightShimmerLight
  //       : hightlightShimmerDark;
  // }
  static Color hightlightShimmer(BuildContext context) {
    return _themeColor(context, hightlightShimmerLight, hightlightShimmerDark);
  }
}
