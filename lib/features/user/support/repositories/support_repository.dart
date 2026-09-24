import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiweb_app_management/features/user/support/models/support_request_model.dart';

abstract class SupportRepository {
  Future<List<SupportRequestModel>> getRequests();
  Future<void> saveRequests(List<SupportRequestModel> requests);
  Future<void> clear();
}

class LocalSupportRepository implements SupportRepository {
  static const _key = 'user_support_requests';

  @override
  Future<List<SupportRequestModel>> getRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final values = jsonDecode(raw) as List<dynamic>;
    return values
        .map((item) => SupportRequestModel.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<void> saveRequests(List<SupportRequestModel> requests) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(requests.map((item) => item.toMap()).toList()));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
