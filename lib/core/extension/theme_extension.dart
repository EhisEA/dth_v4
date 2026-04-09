import "package:flutter/material.dart";

/// Extension on BuildContext to easily access theme information
extension ThemeExtension on BuildContext {
  /// Returns true if the current theme is light mode
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  /// Returns true if the current theme is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Returns the current brightness
  Brightness get brightness => Theme.of(this).brightness;
}
