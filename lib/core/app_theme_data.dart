import "package:dth_v4/core/core.dart";
import "package:flutter/material.dart";

/// App theme data configuration
///
/// Defines light and dark theme configurations for the app.
/// This centralizes all theme-related styling to ensure consistency.
class AppThemeData {
  /// Light theme configuration
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppFontFamily.primary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: Colors.grey,
      error: Colors.red,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      headlineLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      headlineSmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Color(0xFF595959),
      ),
      bodyMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Color(0xFF595959),
      ),
      bodySmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Color(0xFF595959),
      ),
      labelLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      labelMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
      labelSmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.black,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      hintStyle: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Color(0xFF828282),
      ),
    ),
  );

  /// Dark theme configuration
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppFontFamily.primary,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF05212F),
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: Colors.grey,
      error: Colors.red,
      surface: const Color(0xFF002D3D),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF002D3D),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Color(0xFFD3D3D3),
      ),
      bodyMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Color(0xFFD3D3D3),
      ),
      bodySmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Color(0xFFD3D3D3),
      ),
      labelLarge: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
      labelSmall: TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      hintStyle: const TextStyle(
        fontFamily: AppFontFamily.primary,
        color: Color(0xFFAAAAAA),
      ),
    ),
  );
}
