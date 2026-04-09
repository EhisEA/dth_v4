import "package:dth_v4/data/models/app_textfield_state.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_utils/flutter_utils.dart";
import "package:dth_v4/core/core.dart";
import "package:dth_v4/widgets/text/app_text.dart";
import "package:dth_v4/widgets/text/textstyles.dart";

class AppTextField extends ConsumerStatefulWidget {
  final String? hint;
  final String? title;
  final BorderRadius? borderRadius;
  final String? Function(String value)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final List<TextInputFormatter> formatter;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final Color? fillColor;
  final Color? errorColor;
  final Color? hintColor;
  final Color? titleColor;
  final Color? inActiveBorderColor;
  final Function(String)? onSubmitted;
  final int? maxLength;
  final double? height;
  late final ValueNotifier<AppTextFieldState> formState;
  final double? width;
  final FocusNode focusNode;
  final EdgeInsets? padding;
  final TextCapitalization textCapitalization;
  final EdgeInsets? contentPadding;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? bottomIcon;
  final Widget? prefix;
  final bool readOnly;
  final bool showBorder;
  final TextStyle? hintStyle;
  final double? titleSize;
  final TextStyle? style;
  final void Function()? onTap;
  final TextInputAction? textInputAction;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;

  AppTextField({
    super.key,
    this.hint,
    this.title,
    this.height,
    this.borderRadius,
    this.width,
    FocusNode? focusNode,
    this.padding,
    ValueNotifier<AppTextFieldState>? formState,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.hintStyle,
    this.style,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.enabled = true,
    this.minLines,
    this.hintColor,
    this.suffixIcon,
    this.prefixIcon,
    this.bottomIcon,
    this.prefix,
    this.showBorder = true,
    this.contentPadding,
    this.isPassword = false,
    this.titleSize,
    this.readOnly = false,
    this.formatter = const [],
    this.onChanged,
    this.onSubmitted,
    this.fillColor,
    this.titleColor,
    this.errorColor,
    this.inActiveBorderColor,
    this.maxLength,
    this.textInputAction,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
  }) : focusNode = focusNode ?? FocusNode(),
       formState =
           formState ??
           ValueNotifier<AppTextFieldState>(AppTextFieldState.defaultValue());

  @override
  ConsumerState<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends ConsumerState<AppTextField> {
  late bool obscure;
  late ValueNotifier<bool> hasFocus = ValueNotifier<bool>(false);
  late ValueNotifier<String?> errorState = ValueNotifier<String?>(null);

  @override
  void initState() {
    obscure = widget.isPassword;
    widget.focusNode.addListener(() {
      hasFocus.value = widget.focusNode.hasFocus;
    });
    // widget.controller?.addListener(() {
    //   setState(() {}); // So that suffixIcon updates when text changes
    // });
    super.initState();
  }

  void toggleVisibility() {
    setState(() {
      obscure = !obscure;
    });
  }

  bool _isDarkMode() {
    final brightness = ref.watch(themeBrightnessProvider);
    return brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: hasFocus,
      builder: (context, hasFocus, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: errorState,
          builder: (context, errorMessage, _) {
            return GestureDetector(
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!();
                } else {
                  FocusScope.of(context).requestFocus(widget.focusNode);
                }
              },

              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(0.5),
                    decoration: BoxDecoration(
                      borderRadius:
                          widget.borderRadius ?? BorderRadius.circular(12),
                      color: widget.showBorder
                          ? (hasFocus
                                ? AppColors.primary
                                : widget.fillColor ??
                                      (_isDarkMode()
                                          ? const Color(0xff00334C)
                                          : AppColors.white))
                          : Colors.transparent,
                    ),
                    child: Container(
                      padding:
                          widget.padding ??
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            widget.borderRadius ?? BorderRadius.circular(12),
                        color:
                            widget.fillColor ??
                            (_isDarkMode()
                                ? Theme.of(context).scaffoldBackgroundColor
                                : AppColors.white),
                        border: Border.all(
                          color: widget.showBorder
                              ? hasFocus
                                    ? (errorMessage == null
                                          ? AppColors.primary
                                          : Colors.red)
                                    : (widget.inActiveBorderColor ??
                                          (_isDarkMode()
                                              ? Theme.of(
                                                  context,
                                                ).scaffoldBackgroundColor
                                              : const Color(0xffEDEDED)))
                              : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.title != null) ...[
                            AppText.regular(
                              widget.title!,
                              fontSize: widget.titleSize ?? 10,
                              letterSpacing: -0.2,
                              color:
                                  widget.titleColor ??
                                  (_isDarkMode()
                                      ? AppColors.white
                                      : AppColors.tint15),
                            ),
                            // Gap.h4,
                          ],
                          SizedBox(
                            height: widget.height,
                            child: TextFormField(
                              textCapitalization: widget.textCapitalization,
                              focusNode: widget.focusNode,
                              maxLength: widget.maxLength,
                              maxLines: widget.maxLines,
                              minLines: widget.minLines,
                              readOnly: widget.readOnly,
                              style:
                                  widget.style ??
                                  AppTextStyle.regular.copyWith(
                                    color: _isDarkMode()
                                        ? AppColors.white
                                        : AppColors.black,
                                    fontSize: 14,
                                  ),
                              controller: widget.controller,
                              inputFormatters: widget.formatter,
                              textInputAction: widget.textInputAction,
                              onFieldSubmitted: widget.onSubmitted,
                              validator: (value) {
                                errorState.value = null;
                                String? error;
                                if (widget.validator != null) {
                                  error = widget.validator!(value!);
                                }

                                errorState.value = error;
                                return error;
                              },
                              keyboardType: widget.keyboardType,
                              obscureText: obscure,
                              enabled: widget.enabled,
                              onChanged: widget.onChanged,
                              decoration: InputDecoration(
                                contentPadding: widget.contentPadding,
                                errorStyle: const TextStyle(fontSize: 0),
                                prefixIconConstraints:
                                    widget.prefixIconConstraints,
                                suffixIconConstraints:
                                    widget.suffixIconConstraints ??
                                    const BoxConstraints(maxHeight: 40),
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                prefix: widget.prefix,
                                prefixIcon: widget.prefixIcon,
                                suffixIcon: widget.suffixIcon,
                                isDense: true,
                                hintText: widget.hint,
                                hintStyle:
                                    widget.hintStyle ??
                                    AppTextStyle.regular.copyWith(
                                      color:
                                          widget.hintColor ??
                                          (_isDarkMode()
                                              ? const Color(0xff9A9DA3)
                                              : const Color(0xffB5B5B5)),
                                      fontSize: 13,
                                      letterSpacing: -0.2,
                                    ),
                                enabled: widget.enabled,
                              ),
                            ),
                          ),

                          widget.bottomIcon ?? const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Gap.w6,
                          AppText.regular(
                            errorMessage.isEmpty
                                ? errorMessage
                                : errorMessage.capitalizeFirstLetter(),
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
