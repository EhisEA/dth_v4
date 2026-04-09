import "package:flutter/services.dart";

/// Formatter that capitalizes the first letter of each word.
/// Use this to enforce word capitalization regardless of keyboard behavior.
class WordCapitalizationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final capitalized = _capitalizeWords(newValue.text);
    if (capitalized == newValue.text) return newValue;

    return TextEditingValue(
      text: capitalized,
      selection: TextSelection.collapsed(offset: capitalized.length),
    );
  }

  static String _capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text
        .split(" ")
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(" ");
  }
}
