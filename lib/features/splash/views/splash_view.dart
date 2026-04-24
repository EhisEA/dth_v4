import "dart:async";

import "package:dth_v4/core/core.dart";
import "package:dth_v4/features/splash/view_model/splash_view_model.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final _splashViewModel = ChangeNotifierProvider.autoDispose<SplashViewModel>((
  ref,
) {
  return SplashViewModel(ref.read(localCacheProvider));
});

class SplashView extends ConsumerStatefulWidget {
  static const String path = NavigatorRoutes.splash;
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(ref.read(_splashViewModel).initialise());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Image.asset(
            ImageAssets.logo,
            height: 56,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.broken_image_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }
}
