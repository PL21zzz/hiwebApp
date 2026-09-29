class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formats a number to Vietnamese Dong currency format (e.g. 450000 -> 450.000đ)
  static String format(num amount) {
    final text = amount.toInt().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) buffer.write('.');
      buffer.write(text[i]);
    }
    return '$bufferđ';
  }
}
