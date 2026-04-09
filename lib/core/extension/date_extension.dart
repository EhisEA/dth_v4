import "package:intl/intl.dart";

extension DateExtension on DateTime {
  bool isSameDay(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  String format(String formatPattern, {bool addDayExtension = true}) {
    return (DateFormat(formatPattern).format(
      this,
    )).replaceAll(",", addDayExtension ? "${_addDaySuffix(day)}," : "");
  }

  String _addDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return "th";
    }

    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  String convertToOrdinalDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);

    // Get the day
    final int day = date.day;

    // Get the ordinal suffix
    final String suffix = getOrdinalSuffix(day);

    return "$day$suffix";
  }

  String getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return "th";
    }

    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  String formatCustom(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    final timeFormat = DateFormat("hh:mm a");
    final ordinalSuffix = _addDaySuffix(date.day);

    if (dateToCheck == today) {
      return "Today,  ${timeFormat.format(date)}";
    } else if (dateToCheck == yesterday) {
      return "Yesterday,  ${timeFormat.format(date)}";
    } else {
      return '${date.day}$ordinalSuffix ${DateFormat('MMMM, yyyy').format(date)},  ${timeFormat.format(date)}';
    }
  }

  String formatTransactionItemDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    final timeFormat = DateFormat("hh:mm a");

    if (dateToCheck == today) {
      return "Today,  ${timeFormat.format(date)}";
    } else if (dateToCheck == yesterday) {
      return "Yesterday,  ${timeFormat.format(date)}";
    } else {
      return '${date.day} ${DateFormat('MMM ‘yy').format(date)},  ${timeFormat.format(date)}';
    }
  }
}

extension MonthStringExtensions on String {
  // Get the immediate next month
  String get nextMonth {
    const monthCycle = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    final index = _monthIndex;
    if (index == -1) return "";

    return monthCycle[(index + 1) % 12];
  }

  // Get the immediate previous month
  String get previousMonth {
    const monthCycle = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    final index = _monthIndex;
    if (index == -1) return "";

    return monthCycle[(index - 1 + 12) % 12];
  }

  // Get next N months
  List<String> nextMonths(int count) {
    const monthCycle = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    final index = _monthIndex;
    if (index == -1) return [];

    final result = <String>[];
    for (int i = 1; i <= count; i++) {
      result.add(monthCycle[(index + i) % 12]);
    }
    return result;
  }

  // Get previous N months
  List<String> previousMonths(int count) {
    const monthCycle = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    final index = _monthIndex;
    if (index == -1) return [];

    final result = <String>[];
    for (int i = 1; i <= count; i++) {
      result.add(monthCycle[(index - i + 12) % 12]);
    }
    return result.reversed.toList(); // Return in chronological order
  }

  // Get the month that comes before another month
  // Example: 'April'.monthBefore('March') returns 'March'
  String? monthBefore(String otherMonth) {
    final thisIndex = _monthIndex;
    final otherIndex = otherMonth._monthIndex;

    if (thisIndex == -1 || otherIndex == -1) return null;

    // Check if otherMonth is the month before this month
    if (otherIndex == (thisIndex - 1 + 12) % 12) {
      return otherMonth;
    }

    return null;
  }

  // Get the month that comes after another month
  // Example: 'March'.monthAfter('April') returns 'April'
  String? monthAfter(String otherMonth) {
    final thisIndex = _monthIndex;
    final otherIndex = otherMonth._monthIndex;

    if (thisIndex == -1 || otherIndex == -1) return null;

    // Check if otherMonth is the month after this month
    if (otherIndex == (thisIndex + 1) % 12) {
      return otherMonth;
    }

    return null;
  }

  // Check if this month is immediate before another (returns boolean)
  bool isImmediateBefore(String otherMonth) {
    return monthAfter(otherMonth) != null;
  }

  // Check if this month is immediate after another (returns boolean)
  bool isImmediateAfter(String otherMonth) {
    return monthBefore(otherMonth) != null;
  }

  // Get month index (private helper)
  int get _monthIndex {
    const monthMap = {
      "january": 0,
      "jan": 0,
      "february": 1,
      "feb": 1,
      "march": 2,
      "mar": 2,
      "april": 3,
      "apr": 3,
      "may": 4,
      "june": 5,
      "jun": 5,
      "july": 6,
      "jul": 6,
      "august": 7,
      "aug": 7,
      "september": 8,
      "sep": 8,
      "sept": 8,
      "october": 9,
      "oct": 9,
      "november": 10,
      "nov": 10,
      "december": 11,
      "dec": 11,
    };

    final key = toLowerCase().trim();

    // Direct lookup
    if (monthMap.containsKey(key)) {
      return monthMap[key]!;
    }

    // Partial match
    for (final month in monthMap.keys) {
      if (month.startsWith(key) && key.length >= 3) {
        return monthMap[month]!;
      }
    }

    return -1;
  }

  // Get abbreviated month (3 or 4 letters)
  String get toMonthAbbreviation {
    const abbreviations = {
      "january": "Jan",
      "february": "Feb",
      "march": "March",
      "april": "April",
      "may": "May",
      "june": "June",
      "july": "July",
      "august": "Aug",
      "september": "Sept",
      "october": "Oct",
      "november": "Nov",
      "december": "Dec",
    };

    final key = toLowerCase().trim();

    // Direct match
    if (abbreviations.containsKey(key)) {
      return abbreviations[key]!;
    }

    // Match with 3+ letter input
    for (final month in abbreviations.keys) {
      if (month.startsWith(key) && key.length >= 3) {
        return abbreviations[month]!;
      }
    }

    // Default: return first 3 chars capitalized
    if (length >= 3) {
      return substring(0, 3).toLowerCase().replaceFirstMapped(
        RegExp(r"^."),
        (match) => match.group(0)!.toUpperCase(),
      );
    }

    return this;
  }
}
