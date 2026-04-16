import "dart:async";

import "package:dth_v4/core/core.dart";
import "package:dth_v4/core/router/router.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/bottomNavBar/components/nav_item.dart";
import "package:dth_v4/features/bottomNavBar/viewmodel/bottom_nav_bar_view_model.dart";
import "package:dth_v4/features/home/home_view.dart";
import "package:dth_v4/features/profile/profile_view/views/profile_view.dart";
import "package:dth_v4/features/search/search_view.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart";

final bottomNavBarViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => BottomNavBarViewModel(ref.read(userStateProvider)),
);

class _NavEntry {
  const _NavEntry({
    required this.label,
    required this.assetInactive,
    required this.assetActive,
  });
  final String label;
  final String assetInactive;
  final String assetActive;
}

const List<_NavEntry> _kNavEntries = [
  _NavEntry(
    label: 'Home',
    assetInactive: SvgAssets.home,
    assetActive: SvgAssets.homeActive,
  ),
  _NavEntry(
    label: 'Search',
    assetInactive: SvgAssets.search,
    assetActive: SvgAssets.searchActive,
  ),
  _NavEntry(
    label: 'Verify',
    assetInactive: SvgAssets.verify,
    assetActive: SvgAssets.verifyActive,
  ),
  _NavEntry(
    label: 'Tickets',
    assetInactive: SvgAssets.ticket,
    assetActive: SvgAssets.ticketActive,
  ),
  _NavEntry(
    label: 'Profile',
    assetInactive: SvgAssets.profile,
    assetActive: SvgAssets.profileActive,
  ),
];

class BottomNavBar extends ConsumerStatefulWidget {
  static const String path = NavigatorRoutes.bottomNavBar;
  const BottomNavBar({super.key});

  static GlobalKey<BottomNavBarState> bottomNavBarKey =
      GlobalKey<BottomNavBarState>();

  @override
  ConsumerState<BottomNavBar> createState() => BottomNavBarState();
}

class BottomNavBarState extends ConsumerState<BottomNavBar> {
  List<CustomNavBarScreen> _buildScreens() {
    return [
      CustomNavBarScreen(screen: HomeView()),
      CustomNavBarScreen(screen: SearchView()),
      CustomNavBarScreen(screen: _PlaceholderTab(title: _kNavEntries[2].label)),
      CustomNavBarScreen(screen: _PlaceholderTab(title: _kNavEntries[3].label)),
      CustomNavBarScreen(screen: ProfileView()),
    ];
  }

  final PersistentTabController _tabController = PersistentTabController(
    initialIndex: 0,
  );
  DateTime? _lastBackPress;
  Timer? _exitTimer;
  static const _exitWindow = Duration(seconds: 2);

  void changeTab(int newIndex) {
    if (newIndex < 0 || newIndex >= _kNavEntries.length) return;
    _tabController.jumpToTab(newIndex);
  }

  void _onPopInvoked(bool didPop, Object? result) {
    if (didPop) return;
    final onDashboard = _tabController.index == 0;
    if (!onDashboard) {
      _tabController.jumpToTab(0);
      return;
    }
    final now = DateTime.now();
    final isSecondBack =
        _lastBackPress != null && now.difference(_lastBackPress!) < _exitWindow;
    if (isSecondBack) {
      _exitTimer?.cancel();
      _lastBackPress = null;
      unawaited(SystemNavigator.pop());
      return;
    }
    _lastBackPress = now;
    _exitTimer?.cancel();
    _exitTimer = Timer(_exitWindow, () {
      if (mounted) _lastBackPress = null;
    });
    if (mounted) {
      DthFlushBar.instance.showSuccess(
        message: "Press back again to exit",
        title: "Oh!",
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void dispose() {
    _exitTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final model = ref.read(bottomNavBarViewModel);
    unawaited(
      Future.microtask(() {
        model.userState.getUserDetails();
      }),
    );
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Widget _buildCustomNavBar() {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Material(
      color: AppColors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset > 0 ? 4 : 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < _kNavEntries.length; i++)
              Expanded(
                child: NavItem(
                  icon: _kNavEntries[i].assetInactive,
                  activeIcon: _kNavEntries[i].assetActive,
                  isActive: _tabController.index == i,
                  onTap: () {
                    setState(() {
                      _tabController.index = i;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(bottomNavBarViewModel);
    return ValueListenableBuilder<UserModel?>(
      valueListenable: model.userModel,
      builder: (context, userModel, _) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: _onPopInvoked,
          child: PersistentTabView.custom(
            context,
            backgroundColor: Colors.transparent,
            controller: _tabController,
            handleAndroidBackButtonPress: false,
            screens: _buildScreens(),
            confineToSafeArea: false,
            navBarHeight: 84,
            itemCount: _kNavEntries.length,
            bottomScreenMargin: 0,
            customWidget: _buildCustomNavBar(),
          ),
        );
      },
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: AppText.medium(title, fontSize: 18)));
  }
}
