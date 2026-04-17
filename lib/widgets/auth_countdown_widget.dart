import "package:dth_v4/widgets/text/app_text.dart";
import "package:flutter/material.dart";
import "package:flutter_countdown_timer/index.dart";

/// Pill countdown used on auth OTP (resend cooldown).
class AuthCountDownWidget extends StatelessWidget {
  const AuthCountDownWidget({
    super.key,
    required this.endTime,
    this.onEnd,
    required this.onResend,
  });

  final DateTime endTime;
  final void Function()? onEnd;
  final bool onResend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 9),
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(width: 0.8, color: const Color(0xffECEEF3)),
      ),
      child: CountdownTimer(
        endTime: endTime.millisecondsSinceEpoch,
        onEnd: onEnd,
        widgetBuilder: (context, currentTime) {
          if (currentTime == null) {
            return AppText.medium(
              "00 : 00",
              centered: true,
              fontSize: 11,
              color: const Color(0xff2E3748),
              letterSpacing: 0.4,
            );
          }

          final minutes = (currentTime.min ?? 0).toString().padLeft(2, "0");
          final seconds = (currentTime.sec ?? 0).toString().padLeft(2, "0");

          return AppText.medium(
            " $minutes  : $seconds ",
            centered: true,
            fontSize: 11,
            color: const Color(0xff2E3748),
            letterSpacing: 0.4,
          );
        },
        endWidget: AppText.medium(
          "00 : 00",
          centered: true,
          fontSize: 11,
          color: const Color(0xff2E3748),
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
