import 'dart:ui';

import 'package:flutter/material.dart';

class CircleBlurIconButton extends StatelessWidget {
  const CircleBlurIconButton({
    super.key,
    required this.onTap,
    required this.child,
  });

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              color: const Color(0xffF7F7F7).withValues(alpha: 0.16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
