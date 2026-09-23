import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/address/address_model.dart';
import '../auth_service.dart';

class AddressService extends ChangeNotifier {
  static final AddressService _instance = AddressService._internal();
  static AddressService get instance => _instance;

  static const String _prefAddressKey = 'user_saved_addresses';

  AddressService._internal() {
    _loadAddresses();
  }

  final List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => List.unmodifiable(_addresses);

  AddressModel? get defaultAddress {
    if (!AuthService.instance.isLoggedIn || _addresses.isEmpty) return null;
    return _addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _addresses.first,
    );
  }

  Future<void> clear() async {
    _addresses.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefAddressKey);
    } catch (e) {
      debugPrint('Error clearing addresses: $e');
    }
    notifyListeners();
  }

  Future<void> _loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefAddressKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _addresses.clear();
        for (final item in jsonList) {
          _addresses.add(AddressModel.fromMap(Map<String, dynamic>.from(item)));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    }
  }

  Future<void> _saveAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _addresses.map((a) => a.toMap()).toList();
      await prefs.setString(_prefAddressKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving addresses: $e');
    }
  }

  void addAddress(AddressModel address) {
    if (address.isDefault || _addresses.isEmpty) {
      // Set all other addresses isDefault to false
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
      _addresses.add(address.copyWith(isDefault: true));
    } else {
      _addresses.add(address);
    }
    _saveAddresses();
    notifyListeners();
  }

  void updateAddress(AddressModel address) {
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index == -1) return;

    if (address.isDefault) {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
      _addresses[index] = address.copyWith(isDefault: true);
    } else {
      _addresses[index] = address;
    }
    _saveAddresses();
    notifyListeners();
  }

  void deleteAddress(String id) {
    final wasDefault = _addresses.any((a) => a.id == id && a.isDefault);
    _addresses.removeWhere((a) => a.id == id);
    if (wasDefault && _addresses.isNotEmpty) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    _saveAddresses();
    notifyListeners();
  }

  void setDefaultAddress(String id) {
    for (int i = 0; i < _addresses.length; i++) {
      final isTarget = _addresses[i].id == id;
      _addresses[i] = _addresses[i].copyWith(isDefault: isTarget);
    }
    _saveAddresses();
    notifyListeners();
  }
}
