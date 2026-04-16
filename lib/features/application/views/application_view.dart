import 'package:dth_v4/core/core.dart';
import 'package:dth_v4/core/router/router.dart';
import 'package:dth_v4/features/application/view_model/application_wizard_notifier.dart';
import 'package:dth_v4/features/application/views/steps/application_placeholder_step.dart';
import 'package:dth_v4/features/application/views/steps/contact_information_step.dart';
import 'package:dth_v4/features/application/views/steps/personal_information_step.dart';
import 'package:dth_v4/features/application/components/application_segmented_progress.dart';
import 'package:dth_v4/widgets/text/textstyles.dart';
import 'package:dth_v4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_utils/flutter_utils.dart';

class ApplicationView extends ConsumerStatefulWidget {
  const ApplicationView({super.key});
  static const String path = NavigatorRoutes.application;

  @override
  ConsumerState<ApplicationView> createState() => _ApplicationViewState();
}

class _ApplicationViewState extends ConsumerState<ApplicationView> {
  static const int _totalSteps = 5;

  late final PageController _pageController;
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    _totalSteps,
    (_) => GlobalKey<FormState>(),
  );
  final List<void Function()?> _persistFns = List.filled(_totalSteps, null);

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _registerPersist(int step, void Function() fn) {
    _persistFns[step] = fn;
  }

  void _onBack() {
    HapticFeedback.lightImpact();
    if (_currentIndex == 0) {
      Navigator.of(context).pop();
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  String _primaryButtonLabel() {
    switch (_currentIndex) {
      case 0:
        return 'Proceed ';
      case 1:
        return 'Proceed ';
      case 2:
        return 'Continue';
      case 3:
        return 'Continue';
      case 4:
        return 'Submit application';
      default:
        return 'Continue';
    }
  }

  String _primaryButtonSubtitle() {
    switch (_currentIndex) {
      case 0:
        return '(Contact Information)';
      case 1:
        return '(Audition Video)';
      case 2:
        return 'Continue';
      case 3:
        return 'Continue';
      case 4:
        return 'Submit application';
      default:
        return 'Continue';
    }
  }

  Future<void> _onProceed() async {
    FocusScope.of(context).unfocus();
    final form = _formKeys[_currentIndex].currentState;
    if (form == null || !form.validate()) return;
    _persistFns[_currentIndex]?.call();

    if (_currentIndex < _totalSteps - 1) {
      await _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      await ref.read(applicationWizardProvider.notifier).submitApplication();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _onBack,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.greyTint15),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SvgPicture.asset(
                            SvgAssets.backArrow,
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                              AppColors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap.w24,
                    Expanded(
                      child: ApplicationSegmentedProgress(
                        currentStepIndex: _currentIndex,
                        totalSteps: _totalSteps,
                      ),
                    ),
                    Gap.w24,
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      child: SvgPicture.asset(SvgAssets.support),
                    ),
                  ],
                ),
              ),
              Gap.h8,
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  children: [
                    PersonalInformationStep(
                      formKey: _formKeys[0],
                      onRegisterPersist: (fn) => _registerPersist(0, fn),
                    ),
                    ContactInformationStep(
                      formKey: _formKeys[1],
                      onRegisterPersist: (fn) => _registerPersist(1, fn),
                    ),
                    ApplicationPlaceholderStep(
                      formKey: _formKeys[2],
                      title: 'Audition Video',
                      subtitle: 'Upload or record your audition in this step.',
                    ),
                    ApplicationPlaceholderStep(
                      formKey: _formKeys[3],
                      title: 'Review',
                      subtitle: 'Confirm your details before submitting.',
                    ),
                    ApplicationPlaceholderStep(
                      formKey: _formKeys[4],
                      title: 'Submit',
                      subtitle: 'Final confirmation and terms.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: AppButton.primary(
                  text: _primaryButtonLabel(),
                  press: _onProceed,
                  subtitle: _primaryButtonSubtitle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyle.regular.copyWith(
                      fontSize: 11,
                      color: context.isDarkMode
                          ? AppColors.tint10
                          : AppColors.blackTint20,
                    ),
                    children: [
                      TextSpan(
                        text: 'Proudly sponsored by ',
                        style: AppTextStyle.regular.copyWith(
                          fontSize: 12,
                          color: AppColors.blackTint20,
                        ),
                      ),
                      TextSpan(
                        text: 'Vent Africa',
                        style: AppTextStyle.regular.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff009DF9),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
