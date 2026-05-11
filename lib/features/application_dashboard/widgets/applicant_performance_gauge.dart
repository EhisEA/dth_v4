import "package:dth_v4/core/core.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:flutter_utils/flutter_utils.dart";

/// Semicircular performance gauge (segmented track + progress arc).
class ApplicantPerformanceGauge extends StatelessWidget {
  const ApplicantPerformanceGauge({
    super.key,
    required this.score,
    required this.max,
    required this.arcColor,
    required this.label,
    required this.caption,
  });

  final int score;
  final int max;
  final Color arcColor;
  final String label;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final pct = max <= 0 ? 0 : ((score / max) * 100).round().clamp(0, 100);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 130,
          child: CustomPaint(
            painter: _GaugePainter(progress: pct / 100.0, arcColor: arcColor),
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.black(
                    "$pct%",
                    fontSize: 44,
                    color: AppColors.black,
                    height: 1.24,
                  ),
                  AppText.bold(
                    "of $max",
                    fontSize: 16,
                    letterSpacing: -0.6,
                    color: AppColors.tint15,
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap.h20,
        AppText.medium(label, fontSize: 14, color: AppColors.black),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(SvgAssets.infoOutline, width: 10, height: 10),
            Gap.w2,
            Flexible(
              child: AppText.regular(
                caption,
                fontSize: 10,
                color: AppColors.blackTint20,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.progress, required this.arcColor});

  final double progress;
  final Color arcColor;

  static const int _segments = 48;
  static const double _startAngle = 3.1415926535897932;
  static const double _sweep = 3.1415926535897932;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final radius = w * 0.38;
    final center = Offset(w / 2, h * 0.72);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = AppColors.greyTint30
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final segmentGap = _sweep / _segments;
    final slot = segmentGap * 0.62;
    for (var i = 0; i < _segments; i++) {
      final start = _startAngle + i * segmentGap + (segmentGap - slot) / 2;
      canvas.drawArc(rect, start, slot, false, trackPaint);
    }

    final fillSweep = (_sweep * progress.clamp(0.0, 1.0)).clamp(0.0, _sweep);
    if (fillSweep > 0.001) {
      final fillPaint = Paint()
        ..color = arcColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, _startAngle, fillSweep, false, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.arcColor != arcColor;
  }
}

Color applicantPerformanceArcColor(String colorKey) {
  switch (colorKey.toLowerCase()) {
    case "green":
    case "success":
      return AppColors.primary;
    case "red":
    case "danger":
      return AppColors.redTint35;
    case "orange":
    case "warning":
      return AppColors.secondaryOrange;
    case "blue":
      return AppColors.secondaryBlue;
    default:
      return AppColors.tint15;
  }
}
