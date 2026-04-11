import 'package:dth_v4/core/router/routing_argument_keys.dart';
import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/data/repo/auth/auth.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

class VerifyOtpViewModel extends BaseChangeNotifierViewModel {
  VerifyOtpViewModel(
    this._authRepo,
    this._userState,
    this._initialEmail,
    this.deviceInfoState,
  ) : endTime = ValueNotifier<DateTime>(
        DateTime.now().add(const Duration(seconds: _defaultCooldownSeconds)),
      );

  static const int _defaultCooldownSeconds = 60;

  final AuthRepo _authRepo;
  final UserProfileState _userState;
  final String _initialEmail;
  final DeviceInfoState deviceInfoState;

  final ValueNotifier<bool> canResend = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime> endTime;

  String _email = '';
  String _fullName = '';
  String? _otpSignature;
  String _otpFlow = OtpFlowArg.register;

  String get email => _email;
  String? get registrationSignature => _otpSignature;

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
        _otpSignature = sig;
      }
      final flow = args[RoutingArgumentKey.otpFlow] as String?;
      _otpFlow = flow == OtpFlowArg.login
          ? OtpFlowArg.login
          : OtpFlowArg.register;
      assignEndTime(ttlSeconds: _ttlSecondsFromArgs(args));
    } else {
      _otpFlow = OtpFlowArg.register;
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

  /// Re-sends OTP for the current flow (login or registration).
  Future<void> resendOtp() async {
    if (_email.isEmpty) return;
    if (isBaseBusy) return;

    if (_otpFlow == OtpFlowArg.login) {
      if (_otpSignature == null || _otpSignature!.isEmpty) {
        DthFlushBar.instance.showError(
          title: 'Resend code',
          message: 'Start sign-in again from the login screen.',
        );
        return;
      }
    } else {
      if (_fullName.isEmpty || _otpSignature == null) {
        DthFlushBar.instance.showError(
          title: 'Resend code',
          message: 'Resend is only available during email sign-up.',
        );
        return;
      }
    }

    try {
      changeBaseState(const ViewModelState.busy());
      if (_otpFlow == OtpFlowArg.login) {
        final response = await _authRepo.login(
          email: _email,
          deviceName: await deviceInfoState.getDeviceName(),
        );
        changeBaseState(const ViewModelState.idle());
        final signature = response.data?.signature;
        if (signature != null && signature.isNotEmpty) {
          _otpSignature = signature;
          onOtpResentCooldown();
          notifyListeners();
        }
      } else {
        final response = await _authRepo.register(
          fullName: _fullName,
          email: _email,
          deviceName: await deviceInfoState.getDeviceName(),
        );
        changeBaseState(const ViewModelState.idle());
        final signature = response.data?.signature;
        if (signature != null && signature.isNotEmpty) {
          _otpSignature = signature;
          onOtpResentCooldown();
          notifyListeners();
        }
      }
    } on ApiFailure catch (e) {
      changeBaseState(ViewModelState.error(e));
      DthFlushBar.instance.showError(message: e.message, title: 'Failed');
    }
  }

  /// Verifies OTP, persists session on success. Returns `true` if navigation should run.
  Future<bool> submitOtp(String code) async {
    if (isBaseBusy) return false;
    final sig = _otpSignature;
    if (sig == null || sig.isEmpty) {
      DthFlushBar.instance.showError(
        title: 'Verification',
        message:
            'No verification session found. Go back and request a new code.',
      );
      return false;
    }
    try {
      changeBaseState(const ViewModelState.busy());
      if (_otpFlow == OtpFlowArg.login) {
        await _authRepo.verifyLoginOtp(otp: code, signature: sig);
      } else {
        await _authRepo.verifyRegisterOtp(otp: code, signature: sig);
      }
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
