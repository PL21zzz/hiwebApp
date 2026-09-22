import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  static final ApiClient instance = ApiClient._internal();
  ApiClient._internal();

  final http.Client _client = http.Client();

  Map<String, String> _buildHeaders({String? authToken}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  /// Perform HTTP GET Request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    String? authToken,
  }) async {
    final baseUrl = AppConfig.baseUrl.endsWith('/')
        ? AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)
        : AppConfig.baseUrl;

    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    var uri = Uri.parse('$baseUrl$path');

    if (queryParameters != null && queryParameters.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    try {
      debugPrint('GET $uri');
      final response = await _client
          .get(uri, headers: _buildHeaders(authToken: authToken))
          .timeout(AppConfig.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('ApiClient GET Error: $e');
      rethrow;
    }
  }

  /// Perform HTTP POST Request
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    String? authToken,
  }) async {
    final baseUrl = AppConfig.baseUrl.endsWith('/')
        ? AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)
        : AppConfig.baseUrl;

    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final uri = Uri.parse('$baseUrl$path');

    try {
      debugPrint('POST $uri');
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(authToken: authToken),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConfig.timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      debugPrint('ApiClient POST Error: $e');
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic jsonBody;

    try {
      if (response.body.isNotEmpty) {
        jsonBody = jsonDecode(response.body);
      }
    } catch (_) {
      jsonBody = response.body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return jsonBody;
    } else {
      final msg = (jsonBody is Map && jsonBody.containsKey('message'))
          ? jsonBody['message'].toString()
          : 'HTTP Error $statusCode';

      throw ApiException(
        statusCode: statusCode,
        message: msg,
      );
    }
  }
}
