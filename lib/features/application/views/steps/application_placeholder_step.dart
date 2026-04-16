import "package:dth_v4/core/core.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_utils/flutter_utils.dart";

/// Placeholder for wizard steps 3–5 until designs exist.
class ApplicationPlaceholderStep extends StatelessWidget {
  const ApplicationPlaceholderStep({
    super.key,
    required this.formKey,
    required this.title,
    required this.subtitle,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          AppText.medium(
            title,
            fontSize: 24,
            letterSpacing: -0.4,
            color: context.isDarkMode
                ? AppColors.white
                : const Color(0xff08102F),
          ),
          Gap.h8,
          AppText.regular(
            subtitle,
            fontSize: 14,
            height: 1.4,
            color: context.isDarkMode
                ? AppColors.tint10
                : const Color(0xff474954),
          ),
          Gap.h24,
          AppText.regular(
            'This step is not available yet. You can continue to the next screen.',
            fontSize: 14,
            color: context.isDarkMode
                ? AppColors.tint10
                : AppColors.blackTint20,
          ),
          Gap.h32,
        ],
      ),
    );
  }
}
