class AppConfig {
  /// Toggle between Local authentication (false) and Remote Backend API authentication (true).
  static const bool useApiAuth = false;

  /// Base API URL for backend services
  static const String baseUrl = 'https://api.hiweb.vn/api/v1';

  /// Timeout duration for HTTP requests
  static const Duration timeoutDuration = Duration(seconds: 15);

  /// Toggle mock data vs live backend data for categories, products, etc.
  static const bool useMockData = false;
}
