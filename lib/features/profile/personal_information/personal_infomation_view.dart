import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/data/data.dart';
import 'package:dth_v4/features/profile/profile.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_utils/flutter_utils.dart';

class PersonalInfomationView extends ConsumerWidget {
  const PersonalInfomationView({super.key, required this.user});
  final UserModel user;
  static const String path = NavigatorRoutes.personalInformation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayCountry = ref
        .watch(countriesListProvider)
        .maybeWhen(
          data: (countries) => DthCountry.findByIso(countries, user.isoCode),
          orElse: () => null,
        );
    return Scaffold(
      appBar: DthAppBar(title: "Personal Information"),
      backgroundColor: AppColors.scaffold,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: AppColors.baseShimmerLight,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              ImageAssets.user,
              height: 80,
              width: 80,
              color: const Color(0xffECECEC),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          AppText.semiBold(
            user.fullName,
            centered: true,
            fontSize: 18,
            color: AppColors.mainBlack,
          ),
          Gap.h2,
          AppText.regular(
            user.email,
            centered: true,
            fontSize: 12,
            color: AppColors.tint15,
          ),
          Gap.h16,
          Center(child: ContestantPill()),
          Gap.h24,
          AppTextField(
            title: "Full Name",
            titleColor: AppColors.tint15,
            hint: user.fullName,
            hintColor: AppColors.black,
            enabled: false,
            readOnly: true,
          ),
          Gap.h12,
          AppTextField(
            title: "Email Address",
            titleColor: AppColors.tint15,
            hint: user.email,
            hintColor: AppColors.black,
            enabled: false,
            readOnly: true,
          ),
          Gap.h12,
          PhoneNumberCountryInput(
            readOnly: true,
            initialNationalDigits: user.phoneNumber,
            displayCountry: displayCountry,
            suffix: user.isPhoneVerified
                ? null
                : AppButton.primary(
                    height: 32,
                    width: 76,
                    text: "Verify Now",
                    radius: 30,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    press: () {},
                  ),
          ),
        ],
      ),
    );
  }
}
