import "package:intl/intl.dart";

extension IntExtension on int {
  String formatNumber() {
    final number = this;
    if (number >= 1000000) {
      final double millions = number / 1000000;
      if (millions % 1 == 0) {
        return "${millions.toInt()}M";
      } else {
        return "${millions.toStringAsFixed(1)}M";
      }
    } else if (number >= 1000) {
      final double thousands = number / 1000;
      if (thousands % 1 == 0) {
        return "${thousands.toInt()}K";
      } else {
        return "${thousands.toStringAsFixed(1)}K";
      }
    } else {
      return number.toString();
    }
  }

  String formatNumberWithComma() {
    final number = this;
    final formatter = NumberFormat("#,###");
    return formatter.format(number);
  }

  String toMoneyWholeNumber({String symbol = ""}) {
    // money format pattern
    // final _moneyFormat = NumberFormat('#,###,###,###.00', 'en_US');
    // if (this == 0.0) return "0.00";
    // String _moneyFormatted = _moneyFormat.format(this);

    // // /to avoid it from showing $ .90
    // if (this > 0 && this < 1) return _moneyFormatted.replaceRange(0, 2, "0");
    // return _moneyFormatted;

    final int amount = this;
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

  String toMoneyWithSymbol({dynamic symbol = "N"}) {
    return "$symbol${toMoneyWholeNumber()}";
  }
}
