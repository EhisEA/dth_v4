import "package:dth_v4/flavor/flavor_config.dart";

/// Base URLs should be supplied via --dart-define in release builds to avoid
/// hardcoding. Example: flutter run --dart-define=STAGING_BASE_URL=https://dev.vent.africa/api
/// Fallbacks below are for local dev only; prefer env in CI/production.
class ApiRoute {
  static String get baseUrl => FlavorConfig.instance.baseUrl;

  static String get stagingBaseURL => const String.fromEnvironment(
    "STAGING_BASE_URL",
    defaultValue: "https://dth5.on-forge.com/api",
  );
  static String get prodBaseURL => const String.fromEnvironment(
    "PROD_BASE_URL",
    defaultValue: "https://dth5.on-forge.com/api",
  );

  /////AUTH
  static String get logout => "$baseUrl/auth/logout";
  static String get register => "$baseUrl/auth/register";
  static String get registerVerifyOtp => "$baseUrl/auth/register/verify-otp";
  static String get registerResendOtp => "$baseUrl/auth/register/resend-otp";
  static String get login => "$baseUrl/auth/login";
  static String get loginVerifyOtp => "$baseUrl/auth/login/verify-otp";
  static String get loginResendOtp => "$baseUrl/auth/login/resend-otp";
  static String get countries => "$baseUrl/countries";

  ////APPLICATION
  static String get application => "$baseUrl/application";
  static String get applicationProcess => "$baseUrl/application/process";
  ///SUBSCRIPTION
  static String get subscriptionPlans => "$baseUrl/plans";

  ///PROFILE
  static String get user => "$baseUrl/profile";
}
