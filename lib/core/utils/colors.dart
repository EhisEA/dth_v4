import "package:flutter/material.dart";

class AppColors {
  static Color _themeColor(BuildContext context, Color light, Color dark) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  // 00AD55
  static const Color primary = Color(0xFF00AD55);

  /// Darker primary surface (e.g. OTP countdown pill in dark mode).
  // 026B3A
  static const Color primaryMedium = Color(0xFF026B3A);

  // 000000
  static const Color black = Color(0xff000000);

  // FFFFFF
  static Color white = const Color(0xffffffff);

  // 8F8F8F
  static Color tint15 = const Color(0xff8F8F8F);

  // 6A6A6A
  static Color tint20 = const Color(0xff6A6A6A);

  // 454545
  static Color tint25 = const Color(0xff454545);

  ///=========================== Bottom Nav ==============================

  // EDEDED
  static Color baseShimmerLight = const Color(0xFFEDEDED);

  // 013546
  static Color baseShimmerDark = const Color(0xFF013546);
  // static Color get baseShimmer {
  //   return _themeViewModel.isLightMode ? baseShimmerLight : baseShimmerDark;
  // }

  static Color baseShimmer(BuildContext context) {
    return _themeColor(context, baseShimmerLight, baseShimmerDark);
  }

  // F8F7FA
  static Color hightlightShimmerLight = const Color(0xFFF8F7FA);

  // 01455B
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
