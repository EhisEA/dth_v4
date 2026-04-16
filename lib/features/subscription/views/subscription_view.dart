import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/flutter_utils.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  static const String path = NavigatorRoutes.subscription;

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  late final FocusNode _emailFocus;
  late final TextEditingController _emailController;
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _emailFocus = FocusNode();
    _emailController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                AppText.regular(
                  'Home',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                Gap.h16,
                AppTextField(
                  title: 'Email',
                  hint: 'you@example.com',
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  formatter: [FilteringTextInputFormatter.singleLineFormatter],
                ),
                Gap.h24,
                PinCodeField(
                  otpController: _otpController,
                  length: 6,
                  title: 'OTP',
                  onCompleted: (code) {
                    debugPrint('PIN complete: $code');
                  },
                ),
                Gap.h24,
                AppButton.primary(text: 'Primary Button'),
                Gap.h16,
                AppButton.primary(
                  text: 'With subtitle',
                  subtitle: 'Optional line under the title',
                ),
                Gap.h16,
                AppButton.onBorder(text: 'On Border Button'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
