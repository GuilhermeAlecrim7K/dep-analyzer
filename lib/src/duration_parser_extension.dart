extension DurationParser on Duration {
  static Duration parse(String durationString) {
    final durationRegExp =
        RegExp(r'^(\d{1,2}):([0-5]?\d):([0-5]?\d)\.?(\d{0,6})$');
    if (!durationRegExp.hasMatch(durationString)) {
      throw FormatException('$durationString is not a valid Duration String');
    }
    final match = durationRegExp.firstMatch(durationString)!;
    final hours = int.parse(match[1]!);
    final minutes = int.parse(match[2]!);
    final seconds = int.parse(match[3]!);
    final milliseconds = int.tryParse(match[4] ?? '0') ?? 0;

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }
}
