import "package:flutter/material.dart";
import "package:dth_v4/widgets/text/textstyles.dart";

class AppText extends StatelessWidget {
  final String text;
  final bool multiText;
  final TextAlign? textAlign;
  final TextOverflow overflow;
  final Color? color;
  final Color? decorationColor;
  final bool centered;
  final int? maxLines;
  final double? fontSize;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final List<Shadow>? shadows;
  final TextStyle? baseStyle;

  /// Default: [AppTextStyle.regular].
  const AppText(
    this.text, {
    super.key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.shadows,
    this.textAlign,
    this.wordSpacing,
    this.decoration,
    this.decorationColor,
    this.height,
    this.letterSpacing,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.baseStyle,
  });

  const AppText.extraLight(
    this.text, {
    super.key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.shadows,
    this.textAlign,
    this.wordSpacing,
    this.decoration,
    this.decorationColor,
    this.height,
    this.letterSpacing,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
  }) : baseStyle = AppTextStyle.extraLight;

  const AppText.light(
    this.text, {
    super.key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.shadows,
    this.textAlign,
    this.wordSpacing,
    this.decoration,
    this.decorationColor,
    this.height,
    this.letterSpacing,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
  }) : baseStyle = AppTextStyle.light;

  const AppText.regular(
    this.text, {
    super.key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.shadows,
    this.textAlign,
    this.wordSpacing,
    this.decoration,
    this.decorationColor,
    this.height,
    this.letterSpacing,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
  }) : baseStyle = AppTextStyle.regular;

  const AppText.medium(
    this.text, {
    super.key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.shadows,
    this.textAlign,
    this.wordSpacing,
    this.decoration,
    this.decorationColor,
    this.height,
    this.letterSpacing,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
  }) : baseStyle = AppTextStyle.medium;

  const AppText.semiBold(
    this.text, {
    super.key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.shadows,
    this.textAlign,
    this.wordSpacing,
    this.decoration,
    this.decorationColor,
    this.height,
    this.letterSpacing,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
  }) : baseStyle = AppTextStyle.semiBold;

  const AppText.bold(
    this.text, {
    super.key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.shadows,
    this.textAlign,
    this.wordSpacing,
    this.decoration,
    this.decorationColor,
    this.height,
    this.letterSpacing,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
  }) : baseStyle = AppTextStyle.bold;

  const AppText.black(
    this.text, {
    super.key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.shadows,
    this.textAlign,
    this.wordSpacing,
    this.decoration,
    this.decorationColor,
    this.height,
    this.letterSpacing,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
  }) : baseStyle = AppTextStyle.black;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = (baseStyle ?? AppTextStyle.regular).copyWith(
      color: color,
      letterSpacing: letterSpacing,
      decorationColor: decorationColor,
      height: height,
      wordSpacing: wordSpacing,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontStyle: fontStyle,
      decoration: decoration,
      shadows: shadows,
    );

    return Text(
      text,
      key: key,
      maxLines: multiText || maxLines != null ? maxLines ?? 9999999999 : 1,
      overflow: overflow,
      textAlign: centered ? TextAlign.center : textAlign ?? TextAlign.left,
      style: effectiveStyle,
    );
  }
}
