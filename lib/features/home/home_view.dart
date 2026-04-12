import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/features/home/components/home_header.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const String path = NavigatorRoutes.home;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final FocusNode _emailFocus;
  late final TextEditingController _emailController;
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _emailFocus = FocusNode();
    _emailController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                HomeHeader(onLiveTap: () {}, onNotificationTap: () {}),
                Expanded(
                  child: ListView(
                    children: [
                      Gap.h32,
                      AppText.regular(
                        'Home',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
