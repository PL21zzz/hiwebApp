class NumberFormatter {
  NumberFormatter._();

  /// Formats count like 1800 -> 1.8k, 15800 -> 15.8k+
  static String formatSoldCount(num count) {
    if (count >= 1000) {
      final k = count / 1000;
      return '${k.toStringAsFixed(1).replaceAll('.0', '')}k+';
    }
    return count.toString();
  }

  /// Formats rating to 1 decimal place (e.g. 4.9)
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Formats discount percentage string (e.g. 13 -> -13%)
  static String formatDiscount(int percent) {
    return '-$percent%';
  }
}
