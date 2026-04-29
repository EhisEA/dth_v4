import 'package:dth_v4/core/core.dart';
import 'package:flutter/material.dart';

class PollProgressBar extends StatelessWidget {
  const PollProgressBar({
    super.key,
    required this.progress,
    required this.isSelected,
  });

  final double progress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final clampedProgress = progress.clamp(0.0, 1.0);
        final barWidth = constraints.maxWidth * clampedProgress;
        return Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.greyTint30,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: barWidth,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.tint10,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        );
      },
    );
  }
}
