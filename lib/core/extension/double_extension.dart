import "package:intl/intl.dart";
import "package:dth_v4/core/constants/symbol.dart";

extension DoubeX on double {
  String toMoney({bool truncate = false}) {
    // Split integer and decimal parts
    final List<String> parts = toString().split(".");

    // Format the integer part with commas
    final String integerPart = NumberFormat(
      "#,###",
      "en_US",
    ).format(int.parse(parts[0]));

    // Reconstruct the number with the formatted integer and original decimals
    String formattedAmount = (parts.length > 1)
        ? "$integerPart.${parts[1]}" // If there's a decimal part, include it
        : integerPart; // If no decimal part, return only the integer part

    // If truncate is true, format to exactly two decimal places
    if (truncate) {
      final double truncatedAmount = double.parse(
        formattedAmount.replaceAll(",", ""),
      );
      formattedAmount = NumberFormat(
        "#,###.00",
        "en_US",
      ).format(truncatedAmount);
    }

    return formattedAmount;
  }

  String toMoneyWholeNumber({String symbol = ""}) {
    // money format pattern
    // final _moneyFormat = NumberFormat('#,###,###,###.00', 'en_US');
    // if (this == 0.0) return "0.00";
    // String _moneyFormatted = _moneyFormat.format(this);

    // // /to avoid it from showing $ .90
    // if (this > 0 && this < 1) return _moneyFormatted.replaceRange(0, 2, "0");
    // return _moneyFormatted;

    final double amount = this;
    String formattedAmount = amount.toStringAsFixed(
      2,
    ); // Add a dollar sign and two decimal places
    formattedAmount = formattedAmount.replaceAllMapped(
      // Add commas to separate the thousands
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (Match match) => "${match[1]},",
    );

    return symbol + formattedAmount.split(".")[0];
  }

  String toMoneyDecimalNumber({String symbol = "", int decimalPlace = 2}) {
    // money format pattern
    // final _moneyFormat = NumberFormat('#,###,###,###.00', 'en_US');
    // if (this == 0.0) return "0.00";
    // String _moneyFormatted = _moneyFormat.format(this);

    // // /to avoid it from showing $ .90
    // if (this > 0 && this < 1) return _moneyFormatted.replaceRange(0, 2, "0");
    // return _moneyFormatted;

    final double amount = this;
    String formattedAmount = amount.toStringAsFixed(
      decimalPlace, // 2,
    ); // Add a dollar sign and two decimal places
    formattedAmount = formattedAmount.replaceAllMapped(
      // Add commas to separate the thousands
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (Match match) => "${match[1]},",
    );

    return formattedAmount.split(".")[1];
  }

  String toMoneyShowFree() {
    // money format pattern
    if (this == 0.0) return "Free";
    return "N${toMoney()}";
  }

  // String toMoneyWithSymbol() {
  //   return "N${toMoney()}";
  // }
  String toMoneyWithSymbol({String symbol = AppSymbols.naria, int dec = 2}) {
    return "$symbol${toMoneyDecimalNumber(decimalPlace: dec)}";
  }

  String abbrivate() {
    final number = this;
    if (number < 1000) {
      return number.toInt().toString();
    } else if (number < 1000000) {
      final double result = number / 1000.0;
      return "${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}k";
    } else if (number < 1000000000) {
      final double result = number / 1000000.0;
      return "${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M";
    } else {
      final double result = number / 1000000000.0;
      return "${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}B";
    }
  }
}
