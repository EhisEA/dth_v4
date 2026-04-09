import "package:dth_v4/core/core.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// View model for theme-related operations
///
/// Provides easy access to theme state and helper methods
class ThemeViewModel {
  final Brightness brightness;

  ThemeViewModel(this.brightness);

  /// Returns true if the current theme is light mode
  bool get isLightMode => brightness == Brightness.light;

  /// Returns true if the current theme is dark mode
  bool get isDarkMode => brightness == Brightness.dark;
}

/// Provider for ThemeViewModel
///
/// Usage in ConsumerWidget:
/// ```dart
/// final themeModel = ref.watch(themeViewModel);
///
/// // Then use it like:
/// themeModel.isLightMode
///   ? PngAssets.chatLight
///   : PngAssets.chatDark,
/// ```
final themeViewModel = Provider<ThemeViewModel>((ref) {
  final brightness = ref.watch(themeBrightnessProvider);
  return ThemeViewModel(brightness);
});
