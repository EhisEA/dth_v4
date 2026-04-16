import "package:dth_v4/core/core.dart";
import "package:flutter/material.dart";

/// Five (or [totalSteps]) horizontal segments; segments `0..currentStepIndex` use primary.
class ApplicationSegmentedProgress extends StatelessWidget {
  const ApplicationSegmentedProgress({
    super.key,
    required this.currentStepIndex,
    this.totalSteps = 5,
  });

  final int currentStepIndex;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final idx = currentStepIndex.clamp(0, totalSteps - 1);
    return Row(
      children: List.generate(totalSteps, (i) {
        final filled = i <= idx;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 6),
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: filled ? AppColors.primary : AppColors.greyTint35,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        );
      }),
    );
  }
}
