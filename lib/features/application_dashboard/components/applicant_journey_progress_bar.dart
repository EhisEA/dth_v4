import "dart:math" as math;

import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/data.dart";
import "package:dth_v4/features/application_dashboard/components/applicant_performance_gauge.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_utils/flutter_utils.dart";

/// Discrete vertical segments + white gaps (API `progress.type: bar`).
/// No outer track border — unfilled area is transparent (card background).
class ApplicantJourneyProgressBar extends StatelessWidget {
  const ApplicantJourneyProgressBar({super.key, required this.progress});

  final JourneyProgress progress;

  static const double _barHeight = 12;
  static const double _segmentWidth = 4;
  static const double _gap = 2;

  @override
  Widget build(BuildContext context) {
    if (progress.typeNormalized != "bar") return const SizedBox.shrink();
    final max = progress.max;
    final frac = max <= 0 ? 0.0 : (progress.value / max).clamp(0.0, 1.0);
    final fillColor = dashboardSemanticColor(progress.color);
    final label = progress.label.trim().isNotEmpty
        ? progress.label
        : "${(frac * 100).round()}%";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              return SizedBox(
                height: _barHeight,
                width: c.maxWidth,
                child: CustomPaint(
                  painter: _DiscreteSegmentBarPainter(
                    width: c.maxWidth,
                    height: _barHeight,
                    fraction: frac,
                    fillColor: fillColor,
                    segmentWidth: _segmentWidth,
                    gap: _gap,
                  ),
                ),
              );
            },
          ),
        ),
        Gap.w8,
        AppText.regular(
          label,
          fontSize: 10,
          color: AppColors.mainBlack,
          letterSpacing: 0.2,
        ),
      ],
    );
  }
}

/// Filled portion = first [fraction] of segment slots; each slot is a short
/// stadium (rounded) column; [gap] is unpainted (shows card white behind).
class _DiscreteSegmentBarPainter extends CustomPainter {
  _DiscreteSegmentBarPainter({
    required this.width,
    required this.height,
    required this.fraction,
    required this.fillColor,
    required this.segmentWidth,
    required this.gap,
  });

  final double width;
  final double height;
  final double fraction;
  final Color fillColor;
  final double segmentWidth;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    final unit = segmentWidth + gap;
    if (unit <= 0) return;

    final maxSlots = math.max(1, ((w + gap) / unit).floor());
    final filledSlots = (maxSlots * fraction.clamp(0.0, 1.0)).round().clamp(
      0,
      maxSlots,
    );
    if (filledSlots == 0) return;

    final r = math.min(segmentWidth, h) / 2;
    final paint = Paint()..color = fillColor;

    for (var i = 0; i < filledSlots; i++) {
      final left = i * unit;
      if (left >= w) break;
      final segW = math.min(segmentWidth, w - left);
      if (segW <= 0) break;
      final rr = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 0, segW, h),
        Radius.circular(r),
      );
      canvas.drawRRect(rr, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DiscreteSegmentBarPainter oldDelegate) {
    return oldDelegate.width != width ||
        oldDelegate.height != height ||
        oldDelegate.fraction != fraction ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.segmentWidth != segmentWidth ||
        oldDelegate.gap != gap;
  }
}
