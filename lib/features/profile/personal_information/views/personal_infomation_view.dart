import "dart:async";

import "package:dth_v4/core/core.dart";
import "package:dth_v4/core/router/router.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/profile/personal_information/view_model/personal_information_view_model.dart";
import "package:dth_v4/features/profile/profile.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";

class PersonalInfomationView extends ConsumerStatefulWidget {
  const PersonalInfomationView({super.key, required this.user});
  final UserModel user;
  static const String path = NavigatorRoutes.personalInformation;

  @override
  ConsumerState<PersonalInfomationView> createState() =>
      _PersonalInfomationViewState();
}

class _PersonalInfomationViewState
    extends ConsumerState<PersonalInfomationView> {
  @override
  Widget build(BuildContext context) {
    final displayCountry = ref
        .watch(countriesListProvider)
        .maybeWhen(
          data: (countries) =>
              DthCountry.findByIso(countries, widget.user.isoCode),
          orElse: () => null,
        );
    final vm = ref.watch(personalInformationViewModelProvider);
    final userListenable = ref.watch(userStateProvider).user;

    return Loader.page(
      isLoading: vm.isBaseBusy,
      child: Scaffold(
        appBar: DthAppBar(title: "Personal Information"),
        backgroundColor: AppColors.scaffold,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          children: [
            Center(
              child: ValueListenableBuilder<UserModel?>(
                valueListenable: userListenable,
                builder: (context, syncedUser, _) {
                  final u = syncedUser ?? widget.user;
                  return ProfileImageWidget(
                    showEdit: true,
                    avatar: u.avatar,
                    onEditTap: () =>
                        unawaited(vm.pickAndUpdateProfileAvatar(u)),
                  );
                },
              ),
            ),
            Gap.h16,
            AppText.semiBold(
              widget.user.fullName,
              centered: true,
              fontSize: 18,
              color: AppColors.mainBlack,
            ),
            Gap.h2,
            AppText.regular(
              widget.user.email,
              centered: true,
              fontSize: 12,
              color: AppColors.tint15,
            ),
            Center(child: ContestantPill(user: widget.user)),
            Gap.h24,
            AppTextField(
              title: "Full Name",
              titleColor: AppColors.tint15,
              hint: widget.user.fullName,
              hintColor: AppColors.black,
              enabled: false,
              readOnly: true,
            ),
            Gap.h12,
            AppTextField(
              title: "Email Address",
              titleColor: AppColors.tint15,
              hint: widget.user.email,
              hintColor: AppColors.black,
              enabled: false,
              readOnly: true,
            ),
            Gap.h12,
            PhoneNumberCountryInput(
              readOnly: true,
              initialNationalDigits: widget.user.phoneNumber,
              displayCountry: displayCountry,
              suffix: widget.user.isPhoneVerified
                  ? null
                  : AppButton.primary(
                      height: 32,
                      width: 76,
                      text: "Verify Now",
                      radius: 30,
                      fontSize: 11,
                      isLoading: vm.isBaseBusy,
                      fontWeight: FontWeight.w400,
                      press: widget.user.phoneNumber.trim().isEmpty
                          ? () {}
                          : () async {
                              final sent = await vm.sendPhoneVerificationCode(
                                widget.user.phoneNumber.trim(),
                              );
                              if (!mounted || !sent) return;
                              MobileNavigationService.instance.push(
                                ProfilePhoneVerifyOtpView.path,
                              );
                            },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
