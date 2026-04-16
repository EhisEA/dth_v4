import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/features/app_web_view/app_web_view.dart';
import 'package:dth_v4/features/application/views/application_view.dart';
import 'package:dth_v4/features/authentication/views/create_account_view.dart';
import 'package:dth_v4/features/authentication/views/get_started_view.dart';
import 'package:dth_v4/features/authentication/views/login_view.dart';
import 'package:dth_v4/features/authentication/views/verify_otp_view.dart';
import 'package:dth_v4/features/bottomNavBar/bottom_nav_bar.dart';
import 'package:dth_v4/features/home/home_view.dart';
import 'package:dth_v4/features/stories/views/stories_view.dart';
import 'package:dth_v4/features/search/search_view.dart';
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
      case BottomNavBar.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: const BottomNavBar(),
        );

      case SplashView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: const SplashView(),
        );

      ////////////////AUTHVIEW////////////////////
      case GetStartedView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: const GetStartedView(),
        );

      case CreateAccountView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: const CreateAccountView(),
        );

      case LoginView.path:
        return _getPageRoute(settings: settings, viewToShow: const LoginView());

      case VerifyOtpView.path:
        final email = routeArgs[RoutingArgumentKey.email] as String? ?? '';
        final fullName =
            routeArgs[RoutingArgumentKey.fullName] as String? ?? '';
        return _getPageRoute(
          settings: settings,
          viewToShow: VerifyOtpView(
            email: email,
            fullName: fullName,
            signature: routeArgs[RoutingArgumentKey.signature] as String?,
            otpFlow: routeArgs[RoutingArgumentKey.otpFlow] as String?,
            ttlSeconds: routeArgs['ttlSeconds'] as int?,
          ),
        );

      ////////////////HOME VIEW////////////////////
      case HomeView.path:
        return _getPageRoute(settings: settings, viewToShow: const HomeView());
      case StoriesView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: StoriesView(
            imageUrl: routeArgs[RoutingArgumentKey.imageUrl] as String? ?? "",
          ),
        );
      ////////////////SEARCH VIEW////////////////////
      case SearchView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: const SearchView(),
        );

      ////////////////WEB VIEW////////////////////
      case AppWebView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: AppWebView(
            initialURl: routeArgs[RoutingArgumentKey.initialURl],
            title: routeArgs[RoutingArgumentKey.title],
          ),
        );
      ////////////////APPLICATION VIEW////////////////////
      case ApplicationView.path:
        return _getPageRoute(
          settings: settings,
          viewToShow: const ApplicationView(),
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
