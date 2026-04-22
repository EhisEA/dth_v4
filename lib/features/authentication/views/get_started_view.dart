import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/features/app_web_view/app_web_view.dart';
import 'package:dth_v4/features/authentication/view_model/get_started_view_model.dart';
import 'package:dth_v4/features/authentication/views/create_account_view.dart';
import 'package:dth_v4/features/bottomNavBar/bottom_nav_bar.dart';
import 'package:dth_v4/widgets/text/text.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

class GetStartedView extends ConsumerStatefulWidget {
  const GetStartedView({super.key});

  static const String path = NavigatorRoutes.getStarted;

  @override
  ConsumerState<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends ConsumerState<GetStartedView> {
  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = _onTermsPressed;
    _privacyTap = TapGestureRecognizer()..onTap = _onPrivacyPressed;
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  void _onTermsPressed() {
    HapticFeedback.lightImpact();
    MobileNavigationService.instance.navigateTo(
      AppWebView.path,
      extra: {
        RoutingArgumentKey.title: "Terms & Conditions",
        RoutingArgumentKey.initialURl: AppLink.termsAndConditions,
      },
    );
  }

  void _onPrivacyPressed() {
    HapticFeedback.lightImpact();
    MobileNavigationService.instance.navigateTo(
      AppWebView.path,
      extra: {
        RoutingArgumentKey.title: "Privacy Policy",
        RoutingArgumentKey.initialURl: AppLink.privacyPolicy,
      },
    );
  }

  Future<void> _onGooglePressed() async {
    HapticFeedback.lightImpact();
    final model = ref.read(getStartedViewModelProvider);
    final success = await model.signInWithGoogle();
    if (!mounted || !success) return;
    MobileNavigationService.instance.navigateAndClearStack(BottomNavBar.path);
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(getStartedViewModelProvider);
    final theme = Theme.of(context);
    const bodyColor = Color(0xFF6A6A6A);
    const linkColor = AppColors.primary;
    final baseStyle =
        theme.textTheme.bodySmall?.copyWith(
          color: bodyColor,
          fontSize: 12,
          height: 1.45,
        ) ??
        TextStyle(color: bodyColor, fontSize: 12, height: 1.45);
    final linkStyle = AppTextStyle.regular.copyWith(
      color: linkColor,
      fontSize: 12,
    );
    final blackStyle = AppTextStyle.regular.copyWith(
      color: AppColors.black,
      fontSize: 12,
    );

    Widget svgIcon(String asset, {double size = 16}) {
      return SvgPicture.asset(asset, width: size, height: size);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Gap.h14,
              Center(
                child: Image.asset(
                  ImageAssets.logo2,
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              const Spacer(),
              AppButton.primary(
                text: 'Continue with email',
                enabled: !model.isBaseBusy,
                press: () {
                  MobileNavigationService.instance.push(CreateAccountView.path);
                },
              ),
              Gap.h12,
              AppButton.onBorder(
                text: 'Continue with Google',
                textColor: AppColors.black,
                borderColor: AppColors.primary,
                prefixIcon: svgIcon(SvgAssets.googleLogo),
                isLoading: model.isBaseBusy,
                enabled: !model.isBaseBusy,
                press: _onGooglePressed,
              ),
              Gap.h12,
              AppButton.onBorder(
                text: 'Continue with Apple',
                textColor: AppColors.black,
                borderColor: AppColors.primary,
                prefixIcon: svgIcon(SvgAssets.appleLogo),
                enabled: !model.isBaseBusy,
                press: () {
                  MobileNavigationService.instance.navigateAndClearStack(
                    BottomNavBar.path,
                  );
                },
              ),
              Gap.h24,
              Text.rich(
                TextSpan(
                  style: baseStyle,
                  children: [
                    const TextSpan(text: 'By clicking '),
                    TextSpan(text: '"Continue" ', style: blackStyle),
                    const TextSpan(text: 'you acknowledge and agree to '),
                    TextSpan(
                      text: "DTH's Terms & Conditions",
                      style: linkStyle,
                      recognizer: _termsTap,
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy.',
                      style: linkStyle,
                      recognizer: _privacyTap,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Gap.h16,
            ],
          ),
        ),
      ),
    );
  }
}
