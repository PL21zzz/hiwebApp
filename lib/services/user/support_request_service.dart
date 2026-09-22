import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/support/support_request_model.dart';

class SupportRequestService extends ChangeNotifier {
  static final SupportRequestService _instance = SupportRequestService._internal();
  static SupportRequestService get instance => _instance;

  static const String _prefSupportKey = 'user_support_requests';

  SupportRequestService._internal() {
    _loadRequests();
  }

  final List<SupportRequestModel> _requests = [];
  List<SupportRequestModel> get requests => List.unmodifiable(_requests);

  Future<void> _loadRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefSupportKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _requests.clear();
        for (final item in jsonList) {
          _requests.add(SupportRequestModel.fromMap(Map<String, dynamic>.from(item)));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading support requests: $e');
    }
  }

  Future<void> _saveRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _requests.map((r) => r.toMap()).toList();
      await prefs.setString(_prefSupportKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving support requests: $e');
    }
  }

  void addRequest(SupportRequestModel request) {
    _requests.insert(0, request);
    _saveRequests();
    notifyListeners();
  }
}
