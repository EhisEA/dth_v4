import "package:flutter/foundation.dart";

enum Flavor {
  prod("Dth"),
  dev("Dth (Dev)");

  const Flavor(this.title);
  final String title;
}

class FlavorConfig {
  final Flavor flavor;
  final String title;
  final String baseUrl;

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    assert(
      _instance != null,
      "FlavorConfig not initialized. Please initialize in main.dart",
    );
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.title, this.baseUrl);

  factory FlavorConfig({
    required Flavor flavor,
    required String title,
    required String baseUrl,
  }) {
    _instance ??= FlavorConfig._internal(flavor, title, baseUrl);
    return _instance!;
  }

  // Reset instance (useful for testing)
  static void reset() {
    _instance = null;
  }

  @override
  String toString() {
    return "FlavorConfig(flavor: ${flavor.name}, title: $title, baseUrl: $baseUrl)";
  }

  bool get isDev => flavor == Flavor.dev;

  bool get isProd => flavor == Flavor.prod;
}

@immutable
class FlavorValues {
  const FlavorValues({
    required this.baseUrl,
    this.apiTimeout = const Duration(seconds: 30),
    this.logEnabled = false,
    required this.title,
  });

  final String baseUrl;
  final Duration apiTimeout;
  final bool logEnabled;
  final String title;
}
