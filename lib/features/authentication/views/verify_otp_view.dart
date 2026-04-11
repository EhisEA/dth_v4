import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/features/bottomNavBar/bottom_nav_bar.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

class VerifyOtpView extends ConsumerStatefulWidget {
  const VerifyOtpView({super.key, required this.email});

  static const String path = NavigatorRoutes.verifyOtp;

  final String email;

  @override
  ConsumerState<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends ConsumerState<VerifyOtpView> {
  static const int _defaultCooldownSeconds = 60;

  late final TextEditingController _otpController;
  late final FocusNode _otpFocusNode;
  final ValueNotifier<bool> canResend = ValueNotifier(false);
  // Past end times make CountdownTimer call onEnd during build (notifier assert).
  final ValueNotifier<DateTime> endTime = ValueNotifier(
    DateTime.now().add(Duration(seconds: _defaultCooldownSeconds)),
  );

  int resendCount = 0;
  String _email = '';

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _otpController = TextEditingController();
    _otpFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        final e = args[RoutingArgumentKey.email] as String?;
        if (e != null && e.isNotEmpty) {
          setState(() => _email = e);
        }
        assignEndTime(fromPhone: true, ttlSeconds: _ttlSecondsFromArgs(args));
      } else {
        assignEndTime(fromPhone: true);
      }
      if (mounted) {
        _otpFocusNode.requestFocus();
      }
    });
  }

  int? _ttlSecondsFromArgs(Map<String, dynamic> args) {
    final ttl = args['ttlSeconds'];
    if (ttl is int) return ttl;
    return null;
  }

  @override
  void dispose() {
    canResend.dispose();
    endTime.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void assignEndTime({bool fromPhone = false, int? ttlSeconds}) {
    if (fromPhone) {
      resendCount = 0;
    } else {
      resendCount++;
    }
    final seconds = ttlSeconds ?? _defaultCooldownSeconds;
    endTime.value = DateTime.now().add(Duration(seconds: seconds));
    canResend.value = false;
  }

  void onTimerEnd() {
    canResend.value = true;
  }

  void onOtpResent() {
    assignEndTime(ttlSeconds: _defaultCooldownSeconds);
  }

  Future<void> _handleResendOtp() async {
    if (_email.isEmpty) return;
    HapticFeedback.lightImpact();
    await Future<void>.delayed(Duration.zero);
    onOtpResent();
  }

  void _onOtpVerified() {
    final email = _email.isNotEmpty ? _email : widget.email;
    final now = DateTime.now().toIso8601String();
    final user = UserModel(
      id: 'local',
      fullName: '',
      email: email,
      emailVerifiedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    ref.read(userStateProvider).updateUserData(user);
    MobileNavigationService.instance.navigateAndClearStack(MyHomePage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DthAppBar(title: ''),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gap.h16,
              AppText.medium(
                "Let's verify its you",
                fontSize: 22,
                centered: true,
                color: const Color(0xff08102F),
              ),
              Gap.h12,
              AppText.regular(
                'Enter the 6-digit code sent to your email to continue',
                fontSize: 14,
                height: 1.4,
                color: const Color(0xff454545),
                centered: true,
              ),
              Gap.h28,
              PinCodeField(
                otpController: _otpController,
                length: 6,
                width: 60,
                height: 60,
                title: 'OTP',
                focusnode: _otpFocusNode,
                onCompleted: (code) {
                  debugPrint('OTP completed: $code');
                  _onOtpVerified();
                },
              ),
              Gap.h16,
              ValueListenableBuilder<bool>(
                valueListenable: canResend,
                builder: (context, allowResend, _) {
                  return Center(
                    child: allowResend
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText.regular(
                                "Didn't receive the code?",
                                color: const Color(0xff6A6A6A),
                                fontSize: 12,
                                letterSpacing: -0.4,
                              ),
                              Gap.w2,
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  await _handleResendOtp();
                                },
                                child: AppText.medium(
                                  'Resend Code',
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          )
                        : ValueListenableBuilder<DateTime>(
                            valueListenable: endTime,
                            builder: (context, value, _) {
                              return AuthCountDownWidget(
                                endTime: value,
                                isDarkMode: isDarkMode(),
                                onEnd: () {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (mounted) onTimerEnd();
                                  });
                                },
                                onResend: true,
                              );
                            },
                          ),
                  );
                },
              ),
              Gap.h24,
            ],
          ),
        ),
      ),
    );
  }
}
