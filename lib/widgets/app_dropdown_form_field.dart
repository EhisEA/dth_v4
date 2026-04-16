import "package:dth_v4/core/core.dart";
import "package:dth_v4/widgets/text/app_text.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_utils/flutter_utils.dart";

typedef AppDropdownOption<T> = ({T value, String label});

/// Select field that matches [AppTextField] chrome; opens a bottom sheet picker.
class AppDropdownFormField<T> extends ConsumerStatefulWidget {
  const AppDropdownFormField({
    super.key,
    required this.title,
    required this.hint,
    required this.options,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.enabled = true,
  });

  final String title;
  final String hint;
  final List<AppDropdownOption<T>> options;
  final T? initialValue;
  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T>? onSaved;
  final ValueChanged<T?>? onChanged;
  final AutovalidateMode autovalidateMode;
  final bool enabled;

  @override
  ConsumerState<AppDropdownFormField<T>> createState() =>
      _AppDropdownFormFieldState<T>();
}

class _AppDropdownFormFieldState<T>
    extends ConsumerState<AppDropdownFormField<T>> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool _isDarkMode() {
    return ref.watch(themeBrightnessProvider) == Brightness.dark;
  }

  String _labelFor(T? value, FormFieldState<T> field) {
    if (value == null) return '';
    for (final o in widget.options) {
      if (o.value == value) return o.label;
    }
    return value.toString();
  }

  Future<void> _openSheet(FormFieldState<T> field) async {
    if (!widget.enabled) return;
    FocusScope.of(context).requestFocus(_focusNode);
    final selected = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.55,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: AppText.medium(
                    widget.title,
                    fontSize: 16,
                    color: _isDarkMode() ? AppColors.white : AppColors.black,
                  ),
                ),
                for (final o in widget.options)
                  ListTile(
                    title: AppText.regular(
                      o.label,
                      fontSize: 15,
                      color: _isDarkMode() ? AppColors.white : AppColors.black,
                    ),
                    onTap: () => Navigator.of(ctx).pop(o.value),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted || selected == null) return;
    field.didChange(selected);
    widget.onChanged?.call(selected);
    field.validate();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
      validator:
          widget.validator ??
          (v) {
            if (v == null) return 'This field is required';
            if (v is String && v.isEmpty) return 'This field is required';
            return null;
          },
      builder: (field) {
        final hasError = field.hasError;
        final display = _labelFor(field.value, field);
        final borderColor = hasError
            ? Colors.red
            : (_focusNode.hasFocus
                  ? AppColors.primary
                  : (_isDarkMode()
                        ? Theme.of(context).scaffoldBackgroundColor
                        : const Color(0xffEDEDED)));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _openSheet(field),
              behavior: HitTestBehavior.opaque,
              child: Focus(
                focusNode: _focusNode,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _isDarkMode()
                        ? Theme.of(context).scaffoldBackgroundColor
                        : AppColors.white,
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.regular(
                        widget.title,
                        fontSize: 10,
                        letterSpacing: -0.2,
                        color: AppColors.black,
                      ),
                      Gap.h8,
                      Row(
                        children: [
                          Expanded(
                            child: AppText.regular(
                              display.isEmpty ? widget.hint : display,
                              fontSize: 14,
                              letterSpacing: -0.2,
                              color: display.isEmpty
                                  ? (_isDarkMode()
                                        ? const Color(0xff9A9DA3)
                                        : const Color(0xffB5B5B5))
                                  : (_isDarkMode()
                                        ? AppColors.white
                                        : AppColors.black),
                            ),
                          ),
                          SvgPicture.asset(
                            SvgAssets.downArrow,
                            height: 18,
                            width: 18,
                            colorFilter: ColorFilter.mode(
                              _isDarkMode()
                                  ? AppColors.white
                                  : AppColors.tint15,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: AppText.regular(
                  field.errorText!.isEmpty
                      ? field.errorText!
                      : field.errorText!.capitalizeFirstLetter(),
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
          ],
        );
      },
    );
  }
}
