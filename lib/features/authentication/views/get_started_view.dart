import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/features/app_web_view/app_web_view.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({super.key});

  static const String path = NavigatorRoutes.getStarted;

  @override
  State<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyColor = theme.brightness == Brightness.dark
        ? const Color(0xFFD3D3D3)
        : const Color(0xFF595959);
    const linkColor = AppColors.primary;
    final baseStyle =
        theme.textTheme.bodySmall?.copyWith(
          color: bodyColor,
          fontSize: 12,
          height: 1.45,
        ) ??
        TextStyle(color: bodyColor, fontSize: 12, height: 1.45);
    final linkStyle = baseStyle.copyWith(
      color: linkColor,
      fontWeight: FontWeight.w600,
    );

    Widget svgIcon(String asset, {double size = 22}) {
      return SvgPicture.asset(asset, width: size, height: size);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  ImageAssets.logo,
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
              AppButton.primary(text: 'Continue with email', press: () {}),
              Gap.h12,
              AppButton.onBorder(
                text: 'Continue with Google',
                textColor: AppColors.black,
                borderColor: AppColors.primary,
                prefixIcon: svgIcon(SvgAssets.googleLogo),
                press: () {},
              ),
              Gap.h12,
              AppButton.onBorder(
                text: 'Continue with Apple',
                textColor: AppColors.black,
                borderColor: AppColors.primary,
                prefixIcon: svgIcon(SvgAssets.appleLogo),
                press: () {},
              ),
              Gap.h24,
              Text.rich(
                TextSpan(
                  style: baseStyle,
                  children: [
                    const TextSpan(
                      text:
                          'By clicking "Continue", you acknowledge and agree to ',
                    ),
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
