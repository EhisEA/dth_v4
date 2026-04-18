import "package:dth_v4/core/core.dart";
import "package:dth_v4/data/models/dth_country.dart";
import "package:dth_v4/widgets/country_flag_thumbnail.dart";
import "package:dth_v4/widgets/text/app_text.dart";
import "package:dth_v4/widgets/text/textstyles.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_utils/flutter_utils.dart";

/// Validates the national number in [value] (no dial code in the string).
String? validateNationalPhone(String value, DthCountry? country) {
  final empty = Validator.emptyField(value, "Phone number");
  if (empty != null) return empty;
  final digits = value.replaceAll(RegExp(r"\D"), "");
  if (country != null && country.isoCode == "NG") {
    return Validator.phone(digits);
  }
  if (digits.length < 7 || digits.length > 15) {
    return "Enter a valid phone number";
  }
  return null;
}

/// Builds E.164-style storage: dial code + national digits only.
String composeInternationalPhone({
  required DthCountry? country,
  required String nationalInput,
}) {
  final dial = country?.dialCode ?? "";
  final digits = nationalInput.replaceAll(RegExp(r"\D"), "");
  return "$dial$digits";
}

class PhoneNumberCountryInput extends StatefulWidget {
  const PhoneNumberCountryInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.displayCountry,
    required this.textInputAction,
    required this.onCountryTap,
    required this.onSubmitted,
    this.title = "Phone Number",
    this.hint = "702 3456 789",
    this.validator,
    this.formatter,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final DthCountry? displayCountry;
  final TextInputAction textInputAction;
  final VoidCallback onCountryTap;
  final ValueChanged<String> onSubmitted;
  final String title;
  final String hint;
  final String? Function(String value)? validator;
  final List<TextInputFormatter>? formatter;

  @override
  State<PhoneNumberCountryInput> createState() =>
      _PhoneNumberCountryInputState();
}

class _PhoneNumberCountryInputState extends State<PhoneNumberCountryInput> {
  String? _errorText;
  bool _focused = false;

  static const _radius = 12.0;
  static const _borderIdle = Color(0xffEDEDED);
  static const _hintColor = Color(0xffB5B5B5);

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant PhoneNumberCountryInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChanged);
      widget.focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    final has = widget.focusNode.hasFocus;
    if (_focused != has) {
      setState(() => _focused = has);
    }
  }

  Color _borderColor() {
    if (_errorText != null) return Colors.red;
    if (_focused) return AppColors.primary;
    return _borderIdle;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(color: _borderColor()),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onCountryTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.displayCountry != null &&
                                widget.displayCountry!.flagDataUri.isNotEmpty)
                              CountryFlagThumbnail(
                                flagDataUri: widget.displayCountry!.flagDataUri,
                              )
                            else
                              Container(
                                height: 22,
                                width: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.greyTint30,
                                ),
                              ),
                            Gap.w4,
                            AppText.regular(
                              widget.displayCountry?.dialCode ?? "",
                              fontSize: 14,
                              color: AppColors.black,
                            ),
                            Gap.w4,
                            SvgPicture.asset(
                              SvgAssets.downArrow,
                              width: 12,
                              height: 12,
                              colorFilter: ColorFilter.mode(
                                AppColors.blackTint20,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap.w8,
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      keyboardType: TextInputType.phone,
                      textInputAction: widget.textInputAction,
                      onFieldSubmitted: widget.onSubmitted,
                      style: AppTextStyle.regular.copyWith(
                        fontSize: 14,
                        color: AppColors.black,
                      ),
                      cursorColor: AppColors.primary,
                      inputFormatters:
                          widget.formatter ??
                          [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        hintText: widget.hint,
                        hintStyle: AppTextStyle.regular.copyWith(
                          fontSize: 14,
                          color: _hintColor,
                        ),
                        contentPadding: EdgeInsets.zero,
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                      ),
                      validator: (value) {
                        String? err;
                        if (widget.validator != null) {
                          err = widget.validator!(value ?? "");
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          final next = err;
                          if (_errorText != next) {
                            setState(() => _errorText = next);
                          }
                        });
                        return err;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_errorText != null && _errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: AppText.regular(
              _errorText!.capitalizeFirstLetter(),
              fontSize: 12,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
