class RoutingArgumentKey {
  static const String initialURl = "initialURl";
  static const String title = "title";
  static const String email = "email";
  static const String signature = "signature";
  static const String fullName = "fullName";
  static const String imageUrl = "imageUrl";

  /// `"login"` or `"register"` for [VerifyOtpView] / [VerifyOtpViewModel].
  static const String otpFlow = "otpFlow";

  static const String applicationDraft = "applicationDraft";
  static const String user = "user";

  /// `bool` — subscription checkout simulation ([ConfirmationView]).
  static const String confirmationSuccess = "confirmationSuccess";

  static const String callbackUrl = "callbackUrl";
}

abstract class OtpFlowArg {
  static const String login = "login";
  static const String register = "register";
}
