import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class NetworkService extends ChangeNotifier {
  static final NetworkService _instance = NetworkService._internal();
  static NetworkService get instance => _instance;

  NetworkService._internal() {
    _startMonitoring();
  }

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  bool _isChecking = false;
  bool get isChecking => _isChecking;

  Timer? _timer;

  void _startMonitoring() {
    checkConnection();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      checkConnection();
    });
  }

  Future<bool> checkConnection() async {
    if (_isChecking) return !_isOffline;
    _isChecking = true;
    notifyListeners();

    bool offline;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 2));
      offline = result.isEmpty || result[0].rawAddress.isEmpty;
    } catch (_) {
      offline = true;
    }

    _isChecking = false;

    if (_isOffline != offline) {
      _isOffline = offline;
      notifyListeners();
    } else {
      notifyListeners();
    }

    return !_isOffline;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
