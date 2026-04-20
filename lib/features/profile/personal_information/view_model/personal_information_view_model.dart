import "package:dth_v4/data/data.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

/// Personal information screen + in-app phone verification (send code, OTP entry,
/// resend timer). Keeps verification state until you finish or start a new send.
class PersonalInformationViewModel extends BaseChangeNotifierViewModel {
  PersonalInformationViewModel(this._profileRepo, this._userState)
    : endTime = ValueNotifier<DateTime>(
        DateTime.now().add(const Duration(seconds: _defaultCooldownSeconds)),
      );

  static const int _defaultCooldownSeconds = 60;

  final ProfileRepo _profileRepo;
  final UserProfileState _userState;

  final ValueNotifier<bool> canResend = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime> endTime;

  String? _verificationSignature;
  String _phoneNumberForVerification = "";
  String _maskedPhoneForDisplay = "";

  String get maskedPhoneForDisplay => _maskedPhoneForDisplay;

  bool get hasActivePhoneVerification =>
      _verificationSignature != null &&
      _verificationSignature!.isNotEmpty &&
      _phoneNumberForVerification.isNotEmpty;

  /// Shown in the OTP subtitle (e.g. `+234 902 *** 19`).
  static String maskPhoneNumberForDisplay(String phoneNumber) {
    final raw = phoneNumber.trim();
    final d = raw.replaceAll(RegExp(r"\D"), "");
    if (d.length < 8) return raw;
    if (d.startsWith("234") && d.length >= 10) {
      final nsn = d.substring(3);
      if (nsn.length >= 3) {
        final last2 = d.substring(d.length - 2);
        return "+234 ${nsn.substring(0, 3)}***$last2";
      }
    }
    final last2 = d.substring(d.length - 2);
    final keep = (d.length - 5).clamp(4, 7);
    return "+${d.substring(0, keep)}***$last2";
  }

  void assignEndTime({int? ttlSeconds}) {
    final seconds = ttlSeconds ?? _defaultCooldownSeconds;
    endTime.value = DateTime.now().add(Duration(seconds: seconds));
    canResend.value = false;
  }

  void onTimerEnd() {
    canResend.value = true;
  }

  void onOtpResentCooldown() {
    assignEndTime(ttlSeconds: _defaultCooldownSeconds);
  }

  void clearPhoneVerificationSession() {
    _verificationSignature = null;
    _phoneNumberForVerification = "";
    _maskedPhoneForDisplay = "";
    notifyListeners();
  }

  /// Sends an SMS code and stores everything needed for the OTP step.
  Future<bool> sendPhoneVerificationCode(String phoneNumber) async {
    final trimmed = phoneNumber.trim();
    if (trimmed.isEmpty) {
      DthFlushBar.instance.showError(
        title: "Phone number",
        message: "Add a phone number before verifying.",
      );
      return false;
    }
    try {
      changeBaseState(const ViewModelState.busy());
      final response = await _profileRepo.sendPhoneOtp(
        phone: trimmed,
        channel: "text",
      );
      changeBaseState(const ViewModelState.idle());
      final sig = response.data;
      if (sig == null || sig.isEmpty) {
        DthFlushBar.instance.showError(
          title: "Something went wrong",
          message:
              "We could not send a verification code. Please try again in a moment.",
        );
        return false;
      }
      _verificationSignature = sig;
      _phoneNumberForVerification = trimmed;
      _maskedPhoneForDisplay = maskPhoneNumberForDisplay(trimmed);
      assignEndTime();
      notifyListeners();
      return true;
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(
        message: e.message,
        title: "Could not send code",
      );
      return false;
    }
  }

  Future<void> resendPhoneVerificationCode() async {
    if (isBaseBusy) return;
    final phone = _phoneNumberForVerification;
    if (phone.isEmpty || _verificationSignature == null) {
      DthFlushBar.instance.showError(
        title: "Resend code",
        message:
            "Your verification session expired. Go back and tap Verify again.",
      );
      return;
    }
    try {
      changeBaseState(const ViewModelState.busy());
      final response = await _profileRepo.sendPhoneOtp(
        phone: phone,
        channel: "text",
      );
      changeBaseState(const ViewModelState.idle());
      final newSig = response.data;
      if (newSig != null && newSig.isNotEmpty) {
        _verificationSignature = newSig;
      }
      DthFlushBar.instance.showSuccess(
        title: "Code sent",
        message: "A new verification code is on its way.",
      );
      onOtpResentCooldown();
      notifyListeners();
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(
        message: e.message,
        title: "Could not resend",
      );
    }
  }

  Future<bool> submitPhoneVerificationCode(String code) async {
    if (isBaseBusy) return false;
    final sig = _verificationSignature;
    if (sig == null || sig.isEmpty) {
      DthFlushBar.instance.showError(
        title: "Verification",
        message:
            "We could not find an active code request. Go back and tap Verify again.",
      );
      return false;
    }
    try {
      changeBaseState(const ViewModelState.busy());
      await _profileRepo.verifyPhoneOtp(token: code, signature: sig);
      await _userState.getUserDetails();
      clearPhoneVerificationSession();
      changeBaseState(const ViewModelState.idle());
      return true;
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(
        message: e.message,
        title: "Verification failed",
      );
      return false;
    }
  }

  @override
  void dispose() {
    canResend.dispose();
    endTime.dispose();
    super.dispose();
  }
}

final personalInformationViewModelProvider =
    ChangeNotifierProvider<PersonalInformationViewModel>((ref) {
      return PersonalInformationViewModel(
        ref.read(profileRepositoryProvider),
        ref.read(userStateProvider),
      );
    });
