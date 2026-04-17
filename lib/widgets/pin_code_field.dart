import "dart:math";

import "package:dth_v4/core/core.dart";
import "package:dth_v4/widgets/text/textstyles.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:pin_code_fields/pin_code_fields.dart";

class PinCodeField extends StatefulWidget {
  const PinCodeField({
    super.key,
    this.height,
    this.width,
    required this.otpController,
    required this.length,
    this.onSubmitted,
    this.onCompleted,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.hintCharacter,
    this.title = "Pin",
    this.isAuth = true,
    this.enabled = true,
    this.obscureText = false,
    this.autoDismissKeyboard,
    this.autoDisposeControllers,
    this.focusnode,
    this.fieldOuterPadding,
    this.mainAxisAlignment,
    this.selectedFillColor,
    this.activeFillColor,
    this.inactiveFillColor,
    this.selectedColor,
    this.activeColor,
    this.inactiveColor,
  });
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? fieldOuterPadding;
  final String title;
  final String? hintCharacter;
  final bool obscureText;
  final int length;
  final FocusNode? focusnode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(String)? onCompleted;
  final String? Function(String)? validator;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool isAuth;
  final bool? autoDismissKeyboard;
  final TextEditingController otpController;
  final bool? autoDisposeControllers;
  final MainAxisAlignment? mainAxisAlignment;
  final Color? inactiveFillColor;
  final Color? selectedFillColor;
  final Color? activeFillColor;
  final Color? selectedColor;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  createState() => _PinCodeFieldState();
}

class _PinCodeFieldState extends State<PinCodeField> {
  String? text;

  /// Per-cell horizontal margin from [PinTheme.fieldOuterPadding] (padding wraps each cell).
  double _horizontalGutterPerCell(BuildContext context) {
    final padding =
        (widget.fieldOuterPadding ?? const EdgeInsets.symmetric(horizontal: 4))
            .resolve(Directionality.of(context));
    return padding.horizontal;
  }

  /// Fits [length] cells in [maxRowWidth] without overflow; prefers [desiredWidth] / square [side].
  ///
  /// Package layout: each cell is `gutterPerCell + fieldWidth` wide.
  ({double width, double height}) _resolveFieldSize({
    required BuildContext context,
    required double maxRowWidth,
    required double gutterPerCell,
  }) {
    final maxFieldWidth = max(1.0, maxRowWidth / widget.length - gutterPerCell);

    final defaultWidth = min(
      (MediaQuery.sizeOf(context).width - 32) / widget.length - gutterPerCell,
      90.0,
    );

    final desiredW = widget.width ?? defaultWidth;
    final desiredH = widget.height ?? 64.0;
    final square =
        widget.width != null &&
        widget.height != null &&
        widget.width == widget.height;

    if (square) {
      final side = min(widget.width!, maxFieldWidth);
      return (width: side, height: side);
    }

    final w = min(desiredW, maxFieldWidth);
    return (width: w, height: desiredH);
  }

  @override
  Widget build(BuildContext context) {
    final gutter = _horizontalGutterPerCell(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxRow = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final size = _resolveFieldSize(
          context: context,
          maxRowWidth: maxRow,
          gutterPerCell: gutter,
        );

        return PinCodeTextField(
          mainAxisAlignment:
              widget.mainAxisAlignment ?? MainAxisAlignment.spaceEvenly,
          autoDismissKeyboard: widget.autoDismissKeyboard ?? true,
          onSubmitted: widget.onSubmitted,
          focusNode: widget.focusnode,
          hintCharacter: widget.hintCharacter,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          keyboardType: TextInputType.number,
          cursorColor: Colors.transparent,
          textStyle: AppTextStyle.medium.copyWith(
            color: const Color(0xff001119),
            fontSize: 18,
          ),

          obscureText: widget.obscureText,
          autovalidateMode: AutovalidateMode.disabled,
          controller: widget.otpController,
          hintStyle: AppTextStyle.medium.copyWith(
            color: const Color(0xffE1E3F4),
            fontSize: 18,
          ),
          appContext: context,
          length: widget.length,
          autoDisposeControllers: false,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
          onChanged: (value) {
            text = value;
            widget.onChanged?.call(value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "${widget.title} cannot be empty";
            } else if (value.length < widget.length) {
              return "Please completly fill your ${widget.title}";
            } else if (widget.validator != null) {
              return widget.validator!(value);
            }
            return null;
          },
          enableActiveFill: true,
          enabled: widget.enabled,
          onCompleted: widget.onCompleted,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(10),
            fieldOuterPadding:
                widget.fieldOuterPadding ??
                const EdgeInsets.symmetric(horizontal: 4),
            fieldWidth: size.width,
            fieldHeight: size.height,
            borderWidth: 0.9,
            selectedBorderWidth: 1,
            inactiveBorderWidth: 1,
            errorBorderWidth: 1,
            activeBorderWidth: 1,
            disabledBorderWidth: 1,
            inactiveColor: widget.inactiveColor ?? const Color(0xffEDEDED),
            activeColor: widget.activeColor ?? const Color(0xffEDEDED),
            selectedColor: widget.selectedColor ?? AppColors.primary,
            errorBorderColor: Colors.red,
            inactiveFillColor:
                widget.inactiveFillColor ??
                (widget.isAuth
                    ? Theme.of(context).scaffoldBackgroundColor
                    : const Color(0xff003A57)),
            selectedFillColor:
                widget.selectedFillColor ??
                (widget.isAuth
                    ? Theme.of(context).scaffoldBackgroundColor
                    : const Color(0xff003A57)),
            activeFillColor:
                widget.activeFillColor ??
                (widget.isAuth
                    ? Theme.of(context).scaffoldBackgroundColor
                    : const Color(0xff003A57)),
          ),
        );
      },
    );
  }
}
