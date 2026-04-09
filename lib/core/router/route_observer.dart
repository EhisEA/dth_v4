// import 'package:flutter/material.dart';
// import 'package:flutter_utils/utils/app_logger.dart';

// class AppRouteObserver extends NavigatorObserver {
//   final AppLogger _logger = const AppLogger(AppRouteObserver);
//   final List<Route> activeRoutes = [];

//   static AppRouteObserver routeObserver = AppRouteObserver();
//   @override
//   void didPush(Route route, Route? previousRoute) {
//     _logger.v(route.settings.name, functionName: "didPush");
//     activeRoutes.add(route);
//     super.didPush(route, previousRoute);
//   }

//   @override
//   void didReplace({Route? newRoute, Route? oldRoute}) {
//     _logger.v(newRoute?.settings.name, functionName: "didReplace::add");
//     _logger.v(oldRoute?.settings.name, functionName: "didReplace::remove");
//     if (newRoute != null) activeRoutes.add(newRoute);
//     if (oldRoute != null) activeRoutes.remove(oldRoute);
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//   }

//   @override
//   void didPop(Route route, Route? previousRoute) {
//     _logger.v(route.settings.name, functionName: "didPop::remove");
//     _logger.v(previousRoute?.settings.name, functionName: "didPop::Active");
//     activeRoutes.remove(route);
//     super.didPop(route, previousRoute);
//   }

//   @override
//   void didRemove(Route route, Route? previousRoute) {
//     _logger.v(route.settings.name, functionName: "didPop::remove");
//     _logger.v(previousRoute?.settings.name, functionName: "didPop::Active");
//     activeRoutes.remove(route);
//     super.didRemove(route, previousRoute);
//   }

//   bool isRouteActive(String routeName) {
//     return activeRoutes.any((route) => route.settings.name == routeName);
//   }
// }
