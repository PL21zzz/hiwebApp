class AppConfig {
  static String baseUrl = 'https://api.hiweb.vn/api/v1';

  /// Toggle between Mock Data (true) and Real Backend API (false)
  static bool useMockData = false;

  static const Duration timeoutDuration = Duration(seconds: 15);
}
