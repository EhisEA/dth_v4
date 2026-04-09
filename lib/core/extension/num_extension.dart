extension NumX on num {
  String toDecimalMoney({int dec = 9, bool removeTrailingZeros = true}) {
    final double amount = toDouble();

    // Ensure decimal places don't exceed 9
    final int decimalPlaces = dec.clamp(0, 9);

    final String formattedAmount = amount.toStringAsFixed(decimalPlaces);

    // Split into integer and decimal parts
    final List<String> parts = formattedAmount.split(".");
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : "";

    // Add commas to integer part
    integerPart = integerPart.replaceAllMapped(
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (Match match) => "${match[1]},",
    );

    // Handle decimal part
    if (decimalPart.isNotEmpty) {
      // Remove trailing zeros if requested
      if (removeTrailingZeros) {
        decimalPart = decimalPart.replaceAll(RegExp(r"0+$"), "");
      }

      // Only add decimal part if it's not empty after removing zeros
      if (decimalPart.isNotEmpty) {
        return "$integerPart.$decimalPart";
      }
    }

    // For integer values, always show exactly 2 decimal places
    return "$integerPart.00";
  }
}
