import 'package:dth_v4/core/router/routing_argument_keys.dart';
import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/data/repo/auth/auth.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

class VerifyOtpViewModel extends BaseChangeNotifierViewModel {
  final AuthRepo _authRepo;
  final UserProfileState _userState;
  final String _initialEmail;
  final DeviceInfoState deviceInfoState;

  VerifyOtpViewModel(
    this._authRepo,
    this._userState,
    this._initialEmail,
    this.deviceInfoState,
  ) : endTime = ValueNotifier<DateTime>(
        DateTime.now().add(const Duration(seconds: _defaultCooldownSeconds)),
      );

  static const int _defaultCooldownSeconds = 60;

  final ValueNotifier<bool> canResend = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime> endTime;

  String _email = '';
  String _fullName = '';
  String? _registrationSignature;

  String get email => _email;
  String? get registrationSignature => _registrationSignature;

  void hydrateFromRouteArgs(Map<String, dynamic>? args) {
    _email = _initialEmail;
    if (args != null) {
      final e = args[RoutingArgumentKey.email] as String?;
      if (e != null && e.isNotEmpty) {
        _email = e;
      }
      final name = args[RoutingArgumentKey.fullName] as String?;
      if (name != null && name.isNotEmpty) {
        _fullName = name;
      }
      final sig = args[RoutingArgumentKey.signature] as String?;
      if (sig != null && sig.isNotEmpty) {
        _registrationSignature = sig;
      }
      assignEndTime(ttlSeconds: _ttlSecondsFromArgs(args));
    } else {
      assignEndTime();
    }
    notifyListeners();
  }

  int? _ttlSecondsFromArgs(Map<String, dynamic> args) {
    final ttl = args['ttlSeconds'];
    if (ttl is int) return ttl;
    return null;
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

  /// Re-sends registration OTP; updates [registrationSignature] on success.
  Future<void> resendRegistrationOtp() async {
    if (_email.isEmpty) return;
    if (_fullName.isEmpty || _registrationSignature == null) {
      DthFlushBar.instance.showError(
        title: 'Resend code',
        message: 'Resend is only available during email sign-up.',
      );
      return;
    }
    if (isBaseBusy) return;
    try {
      changeBaseState(const ViewModelState.busy());
      final response = await _authRepo.register(
        fullName: _fullName,
        email: _email,
        deviceName: await deviceInfoState.getDeviceName(),
      );
      changeBaseState(const ViewModelState.idle());
      final signature = response.data?.signature;
      if (signature != null && signature.isNotEmpty) {
        _registrationSignature = signature;
        onOtpResentCooldown();
        notifyListeners();
      }
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: 'Failed');
    }
  }

  /// Verifies registration OTP and refreshes user from cache. Returns `true` if navigation should run.
  Future<bool> submitRegistrationOtp(String code) async {
    if (isBaseBusy) return false;
    final sig = _registrationSignature;
    if (sig == null || sig.isEmpty) {
      DthFlushBar.instance.showError(
        title: 'Verification',
        message:
            'Email verification is not available for this sign-in path yet.',
      );
      return false;
    }
    try {
      changeBaseState(const ViewModelState.busy());
      await _authRepo.verifyRegisterOtp(otp: code, signature: sig);
      await _userState.getUserDetails();
      changeBaseState(const ViewModelState.idle());
      return true;
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: 'Failed');
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

final verifyOtpViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<VerifyOtpViewModel, String>((ref, initialEmail) {
      return VerifyOtpViewModel(
        ref.read(authRepositoryProvider),
        ref.read(userStateProvider),
        initialEmail,
        ref.read(deviceInfoStateProvider),
      );
    });
