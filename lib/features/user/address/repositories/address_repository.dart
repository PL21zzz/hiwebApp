import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiweb_app_management/features/user/address/models/address_model.dart';

abstract class AddressRepository {
  Future<List<AddressModel>> getAddresses();
  Future<void> saveAddresses(List<AddressModel> addresses);
  Future<void> clear();
}

class LocalAddressRepository implements AddressRepository {
  static const _key = 'user_saved_addresses';

  @override
  Future<List<AddressModel>> getAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final values = jsonDecode(raw) as List<dynamic>;
    return values
        .map((item) => AddressModel.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<void> saveAddresses(List<AddressModel> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(addresses.map((item) => item.toMap()).toList()));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
