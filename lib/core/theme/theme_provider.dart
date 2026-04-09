import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/local/local_cache.dart";
import "package:dth_v4/core/constants/constants.dart";
import "package:dth_v4/core/provider.dart";

/// Theme provider that manages app theme mode (light, dark, or system)
///
/// This provider persists theme preference to SharedPreferences and
/// automatically syncs with the MaterialApp theme.
///
/// Usage:
/// ```dart
/// // In a ConsumerWidget
/// final themeMode = ref.watch(themeModeProvider);
///
/// // To change theme
/// ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
/// ref.read(themeModeProvider.notifier).toggleTheme();
/// ```
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final LocalCache _localCache;

  ThemeNotifier(this._localCache) : super(_loadThemeMode(_localCache));

  /// Loads saved theme mode from SharedPreferences
  /// Defaults to system theme if no preference is saved
  static ThemeMode _loadThemeMode(LocalCache localCache) {
    final saved = localCache.getFromLocalCache(CacheKeys.themeMode);
    if (saved == null) return ThemeMode.system;

    try {
      return ThemeMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => ThemeMode.system,
      );
    } catch (e) {
      return ThemeMode.system;
    }
  }

  /// Sets the theme mode and persists it
  void setThemeMode(ThemeMode mode) {
    state = mode;
    _localCache.saveToLocalCache(key: CacheKeys.themeMode, value: mode.name);
  }

  /// Toggles between light and dark mode
  /// If currently system mode, switches to dark
  void toggleTheme() {
    final current = _getCurrentBrightness();
    state = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    _localCache.saveToLocalCache(key: CacheKeys.themeMode, value: state.name);
  }

  /// Gets the current effective brightness
  /// Takes into account system theme when in system mode
  Brightness _getCurrentBrightness() {
    if (state == ThemeMode.light) return Brightness.light;
    if (state == ThemeMode.dark) return Brightness.dark;
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
}

/// Provider for theme mode state
///
/// Watch this in your MaterialApp to react to theme changes
final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  final prefs = ref.watch(localCacheProvider);
  return ThemeNotifier(prefs);
});

/// Helper provider to get current brightness
/// Useful for non-widget contexts that need to know the theme
final themeBrightnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  if (themeMode == ThemeMode.light) return Brightness.light;
  if (themeMode == ThemeMode.dark) return Brightness.dark;
  return WidgetsBinding.instance.platformDispatcher.platformBrightness;
});
