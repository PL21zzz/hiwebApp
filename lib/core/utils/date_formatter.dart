class DateFormatter {
  DateFormatter._();

  /// Formats seconds into HH:mm:ss format
  static String formatSecondsToHMS(int remainingSeconds) {
    final hours = (remainingSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$hours : $minutes : $seconds';
  }

  /// Formats duration into m:ss format
  static String formatDurationMS(Duration d) {
    if (d.isNegative) d = Duration.zero;
    final minutes = d.inMinutes;
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
