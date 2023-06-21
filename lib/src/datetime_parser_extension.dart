extension DateTimeParser on DateTime {
  static DateTime parseCsvSetDate(String value) {
    final dateRegExp = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
    if (!dateRegExp.hasMatch(value)) {
      throw const FormatException(
        'Date not recognized. Expected format: dd/mm/yyyy',
      );
    }
    final match = dateRegExp.firstMatch(value)!;
    final day = int.parse(match[1]!);
    final month = int.parse(match[2]!);
    final year = int.parse(match[3]!);

    final resultDate = DateTime(year, month, day);
    bool dateOverflow() {
      return day != resultDate.day ||
          month != resultDate.month ||
          year != resultDate.year;
    }

    if (dateOverflow()) {
      throw const FormatException('Invalid date');
    }
    return resultDate;
  }
}
