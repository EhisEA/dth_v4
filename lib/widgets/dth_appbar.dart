import "package:dth_v4/core/core.dart";
import "package:dth_v4/widgets/widgets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class DthAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DthAppBar({
    super.key,
    this.title,
    this.actions,
    this.elevation,
    this.backgroundColor,
    this.onBack,
    this.showBack = true,
  });
  final String? title;
  final bool showBack;
  final Color? backgroundColor;
  final double? elevation;
  final Function()? onBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: AppText.regular(
        title ?? "",
        color: context.isDarkMode ? AppColors.white : AppColors.black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor:
          backgroundColor ??
          (context.isLightMode ? Colors.white : const Color(0xff022739)),
      elevation: elevation ?? (context.isLightMode ? 0 : null),
      actions: actions,
      leading: showBack
          ? GestureDetector(
              onTap: () {
                if (onBack != null) {
                  onBack?.call();
                } else {
                  Navigator.pop(context);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.isDarkMode
                        ? const Color(0xff022739)
                        : const Color(0xffF8F9FC),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    Icons.arrow_back,
                    // height: 16,
                    // width: 16,
                    color: context.isDarkMode
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
