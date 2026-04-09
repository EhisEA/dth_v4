import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/features/app_web_view/app_web_view.dart';
import 'package:dth_v4/features/authentication/views/get_started_view.dart';
import 'package:dth_v4/features/home/home.dart';
import 'package:dth_v4/features/splash/views/splash_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static PageRoute _getPageRoute({
    required RouteSettings settings,
    required Widget viewToShow,
  }) {
    return MaterialPageRoute(
      builder: (context) => viewToShow,
      settings: settings,
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic> routeArgs = settings.arguments != null
        ? settings.arguments as Map<String, dynamic>
        : {};

    switch (settings.name) {
      case HomeView.path:
        return _getPageRoute(settings: settings, viewToShow: const HomeView());

      case SplashView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: const SplashView(),
        );

      case GetStartedView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: const GetStartedView(),
        );
      case AppWebView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: AppWebView(
            initialURl: routeArgs[RoutingArgumentKey.initialURl],
            title: routeArgs[RoutingArgumentKey.title],
          ),
        );

      default:
        return _getPageRoute(
          settings: settings,
          viewToShow: Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
