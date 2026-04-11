import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    this.activeIcon,
    required this.isActive,
    this.onTap,
  });
  final String icon;
  final String? activeIcon;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconToUse = isActive ? (activeIcon ?? icon) : icon;
    return GestureDetector(
      onTap: () {
        onTap?.call();
        HapticFeedback.lightImpact();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        child: SvgPicture.asset(
          iconToUse,
          width: isActive ? 24 : 20,
          height: isActive ? 24 : 20,
        ),
      ),
    );
  }
}
