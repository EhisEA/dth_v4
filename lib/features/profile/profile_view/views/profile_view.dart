import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/features/app_web_view/app_web_view.dart';
import 'package:dth_v4/features/application/views/application_view.dart';
import 'package:dth_v4/features/profile/profile_view/components/application_widget.dart';
import 'package:dth_v4/features/profile/profile_view/components/contestant_pill.dart';
import 'package:dth_v4/features/profile/profile_view/components/profile_tlle.dart';
import 'package:dth_v4/features/profile/profile_view/view_model/profile_view_model.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

final profileViewModel = ChangeNotifierProvider(
  (ref) => ProfileViewModel(ref.read(userProfileStateProvider)),
);

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});
  static const String path = NavigatorRoutes.profile;

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final MobileNavigationService _navigationService =
      MobileNavigationService.instance;
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAssets.profileBg),
          alignment: Alignment.topCenter,
        ),
      ),
      child: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: userState.user,
          builder: (context, user, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Gap.h30,
                      Image.asset(ImageAssets.user, height: 64, width: 64),
                      Gap.h16,
                      AppText.semiBold(
                        user?.fullName ?? "",
                        centered: true,
                        fontSize: 18,
                        color: AppColors.mainBlack,
                      ),
                      Gap.h2,
                      AppText.regular(
                        user?.email ?? "",
                        centered: true,
                        fontSize: 12,
                        color: AppColors.tint15,
                      ),
                      Gap.h16,
                      Center(child: ContestantPill()),
                      Gap.h32,
                      ApplicationWidget(
                        onTap: () {
                          _navigationService.navigateTo(ApplicationView.path);
                        },
                      ),
                      Gap.h32,
                      AppText.medium(
                        "Account Settings",
                        fontSize: 12,
                        color: AppColors.tint15,
                      ),
                      Gap.h24,
                      ProfileTlle(
                        title: "Personal Information",
                        description: "Update your profile information",
                        icon: SvgAssets.personal,
                        showRightArrow: false,
                        onTap: () {},
                      ),
                      Gap.h28,
                      ProfileTlle(
                        title: "Reset Password",
                        description: "Update your password",
                        icon: SvgAssets.reset,
                        onTap: () {},
                      ),
                      Gap.h32,
                      AppText.medium(
                        "Support & Legal",
                        fontSize: 12,
                        color: AppColors.tint15,
                      ),
                      Gap.h24,
                      ProfileTlle(
                        title: "Terms & Conditions",
                        description:
                            "Review the guidelines for using this platform",
                        icon: SvgAssets.terms,
                        onTap: () {
                          _navigationService.navigateTo(
                            AppWebView.path,
                            extra: {
                              RoutingArgumentKey.title: "Terms & Conditions",
                              RoutingArgumentKey.initialURl:
                                  AppLink.termsAndConditions,
                            },
                          );
                        },
                      ),
                      Gap.h28,
                      ProfileTlle(
                        title: "Privacy Policy",
                        description: "See how your data is handled",
                        icon: SvgAssets.privacy,
                        onTap: () {
                          _navigationService.navigateTo(
                            AppWebView.path,
                            extra: {
                              RoutingArgumentKey.title: "Privacy Policy",
                              RoutingArgumentKey.initialURl:
                                  AppLink.privacyPolicy,
                            },
                          );
                        },
                      ),
                      Gap.h28,
                      ProfileTlle(
                        title: "Social Media Community",
                        description:
                            "Connect with our community and stay updated",
                        icon: SvgAssets.social,
                        onTap: () {},
                      ),
                      Gap.h28,
                      ProfileTlle(
                        title: "Learn More",
                        description: "Discover more about De9jaTalenthunt",
                        icon: SvgAssets.learn,
                        onTap: () {},
                      ),
                      Gap.h32,
                      AppText.medium(
                        "Account Actions",
                        fontSize: 12,
                        color: AppColors.tint15,
                      ),
                      Gap.h24,
                      ProfileTlle(
                        title: "Log Out",
                        description: "Sign out of your account",
                        icon: SvgAssets.logout,
                        isRed: true,
                        showRightArrow: false,
                        onTap: () {},
                      ),
                      Gap.h28,
                      ProfileTlle(
                        title: "Delete Account",
                        description: "Delete your account permanently",
                        icon: SvgAssets.delete,
                        isRed: true,
                        onTap: () {},
                      ),
                      Gap.h30,
                      Gap.h30,
                      Gap.h30,
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
