import "package:dth_v4/features/authentication/views/get_started_view.dart";
import "package:dth_v4/features/bottomNavBar/bottom_nav_bar.dart";
import "package:flutter_utils/flutter_utils.dart";

class SplashViewModel extends BaseChangeNotifierViewModel {
  final LocalCache _localCache;
  SplashViewModel(this._localCache);
  final MobileNavigationService _navigationService =
      MobileNavigationService.instance;

  final _log = const AppLogger(SplashViewModel);

  Future<void> initialise() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    // _localCache.clearCache();
    _log.d(_localCache.getToken());
    _log.d(_localCache.getUserData());
    final bool isLoggedIn = _localCache.getToken() != null;

    if (isLoggedIn) {
      await _navigationService.replace(BottomNavBar.path);
    } else {
      await _navigationService.replace(GetStartedView.path);
    }
  }
}
t