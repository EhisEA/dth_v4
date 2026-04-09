import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/features/authentication/views/create_account_view.dart';
import 'package:dth_v4/features/authentication/views/verify_otp_view.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/flutter_utils.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String path = NavigatorRoutes.login;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final FocusNode _emailFocus;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailFocus = FocusNode();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    MobileNavigationService.instance.push(
      VerifyOtpView.path,
      extra: {RoutingArgumentKey.email: email},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Gap.h10,
                    AppText.medium(
                      'Glad to have you back',
                      fontSize: 24,
                      color: const Color(0xff08102F),
                    ),
                    Gap.h8,
                    AppText.regular(
                      'Enter your email to continue from where you left off.',
                      fontSize: 14,
                      color: const Color(0xff474954),
                    ),
                    Gap.h24,
                    AppTextField(
                      title: 'Email Address',
                      hint: 'example@email.com',
                      controller: _emailController,
                      focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      formatter: [
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                    ),
                    Gap.h28,
                  ],
                ),
              ),

              AppButton.primary(text: 'Login', press: _onLogin),
              Gap.h12,
              AppButton.onBorder(
                text: "I don't have an account",
                textColor: AppColors.primary,
                borderColor: AppColors.primary,
                press: () => MobileNavigationService.instance
                    .navigateAndClearStack(CreateAccountView.path),
              ),
              Gap.h24,
            ],
          ),
        ),
      ),
    );
  }
}
