// ignore_for_file: unused_element

import "package:flutter/services.dart";
import "package:flutter_utils/utils/input_formatters.dart";
import "package:intl/intl.dart";

class NigerianPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r"\D"), "");
    digitsOnly = digitsOnly.length > 11
        ? digitsOnly.substring(0, 11)
        : digitsOnly;
    String formatted = "";

    if (digitsOnly.length <= 4) {
      formatted = digitsOnly;
    } else if (digitsOnly.length <= 7) {
      formatted = "${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4)}";
    } else {
      formatted =
          "${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4, 7)} ${digitsOnly.substring(7, digitsOnly.length)}";
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Converts a Nigerian phone number from local format (0XXXXXXXXX) to international format (+234XXXXXXXXX)
  ///
  /// [phoneNumber] - The phone number in local format (e.g., "0801 234 5678" or "08012345678")
  /// Returns the phone number in international format (e.g., "+2348012345678")
  static String toInternationalFormat(String phoneNumber) {
    // Remove all non-digit characters
    final String digitsOnly = phoneNumber.replaceAll(RegExp(r"\D"), "");

    // If it starts with 0, remove it and add +234
    if (digitsOnly.startsWith("0")) {
      return "+234${digitsOnly.substring(1)}";
    }

    // If it already starts with 234, add the + prefix and ensure no leading zero after 234
    if (digitsOnly.startsWith("234")) {
      String remainingDigits = digitsOnly.substring(3);
      // If there's a leading zero after 234, remove it
      if (remainingDigits.startsWith("0")) {
        remainingDigits = remainingDigits.substring(1);
      }
      return "+234$remainingDigits";
    }

    // If it doesn't start with 0 or 234, assume it's already in the correct format
    // but add +234 prefix if it's 10 digits (Nigerian number without country code)
    if (digitsOnly.length == 10) {
      return "+234$digitsOnly";
    }

    // If it's already 11 digits and doesn't start with 0, it might be missing the +
    if (digitsOnly.length == 11 && !digitsOnly.startsWith("0")) {
      return "+$digitsOnly";
    }

    // Return as is if it doesn't match any pattern
    return phoneNumber;
  }

  /// Extracts only the digits from a formatted phone number
  ///
  /// [phoneNumber] - The formatted phone number (e.g., "0801 234 5678")
  /// Returns only the digits (e.g., "08012345678")
  static String extractDigits(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r"\D"), "");
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  static const String prefix = "+234 "; // Permanent prefix
  static const int maxLength = 15; // Total length including prefix and spaces

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Ensure the prefix is always present
    if (!newValue.text.startsWith(prefix)) {
      return const TextEditingValue(
        text: prefix,
        selection: TextSelection.collapsed(offset: prefix.length),
      );
    }

    // Extract the user's input (digits only)
    String userInput = newValue.text
        .substring(prefix.length)
        .replaceAll(RegExp(r"[^0-9]"), "");

    // Ensure the total length does not exceed the limit
    if (userInput.length > maxLength - prefix.length) {
      userInput = userInput.substring(0, maxLength - prefix.length);
    }

    // Apply formatting (add spaces after every 3 digits)
    final String formattedText = prefix + _formatPhoneNumber(userInput);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatPhoneNumber(String digits) {
    if (digits.isEmpty) return "";
    if (digits.length <= 3) {
      return digits;
    } else if (digits.length <= 6) {
      return "${digits.substring(0, 3)} ${digits.substring(3)}";
    } else {
      return "${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}";
    }
  }
}

class ThousandsFormatter extends NumberInputFormatter {
  static final NumberFormat _formatter = NumberFormat.decimalPattern();

  final FilteringTextInputFormatter _decimalFormatter;
  final String _decimalSeparator;
  final RegExp _decimalRegex;

  final NumberFormat? formatter;
  final bool allowFraction;
  final String symbol;

  ThousandsFormatter({
    this.formatter,
    this.allowFraction = false,
    this.symbol = "N",
  }) : _decimalSeparator = (formatter ?? _formatter).symbols.DECIMAL_SEP,
       _decimalRegex = RegExp(
         allowFraction
             ? "[0-9]+([${(formatter ?? _formatter).symbols.DECIMAL_SEP}])?"
             : r"\d+",
       ),
       _decimalFormatter = FilteringTextInputFormatter.allow(
         RegExp(
           allowFraction
               ? "[0-9]+([${(formatter ?? _formatter).symbols.DECIMAL_SEP}])?"
               : r"\d+",
         ),
       );

  String _formatPattern(String? digits) {
    if (digits == null || digits.isEmpty) return "";
    num number;
    if (allowFraction) {
      String decimalDigits = digits;
      if (_decimalSeparator != ".") {
        decimalDigits = digits.replaceFirst(RegExp(_decimalSeparator), ".");
      }
      number = double.tryParse(decimalDigits) ?? 0.0;
    } else {
      number = int.tryParse(digits) ?? 0;
    }

    final result = (formatter ?? _formatter).format(number);

    if (allowFraction && digits.endsWith(_decimalSeparator)) {
      return "$symbol$result$_decimalSeparator";
    }
    if (allowFraction) {
      return "$symbol$result";
    }
    if (allowFraction) {
      return "$symbol${result.split('.')[0]}";
    }

    return "$symbol$result";
  }

  TextEditingValue _formatValue(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _decimalFormatter.formatEditUpdate(oldValue, newValue);
  }

  bool _isUserInput(String s) {
    return s == _decimalSeparator || _decimalRegex.firstMatch(s) != null;
  }
}
