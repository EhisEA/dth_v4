import "package:dth_v4/data/models/user_model.dart";

/// `data` object from `POST /auth/register`.
class RegisterInitResult {
  const RegisterInitResult({required this.signature});

  final String signature;

  factory RegisterInitResult.fromJson(Map<String, dynamic> json) {
    return RegisterInitResult(signature: json["signature"] as String);
  }
}

/// `data` object from `POST /auth/register/verify-otp` (before persistence).
class RegistrationCompleteResult {
  const RegistrationCompleteResult({required this.user, required this.token});

  final UserModel user;
  final String token;

  factory RegistrationCompleteResult.fromJson(Map<String, dynamic> json) {
    return RegistrationCompleteResult(
      user: UserModel.fromJson(json["user"] as Map<String, dynamic>),
      token: json["token"] as String,
    );
  }
}
