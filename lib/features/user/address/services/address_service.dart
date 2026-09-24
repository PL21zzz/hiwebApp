import 'package:flutter/foundation.dart';
import 'package:hiweb_app_management/core/state/async_state.dart';
import 'package:hiweb_app_management/features/user/address/models/address_model.dart';
import 'package:hiweb_app_management/features/user/address/repositories/address_repository.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';

class AddressService extends ChangeNotifier {
  static final AddressService _instance = AddressService._internal();
  static AddressService get instance => _instance;

  AddressService._internal() : _repository = LocalAddressRepository() {
    _loadAddresses();
  }

  final AddressRepository _repository;
  final List<AddressModel> _addresses = [];
  AsyncState<void> _actionState = const AsyncState.initial();
  List<AddressModel> get addresses => List.unmodifiable(_addresses);
  AsyncState<List<AddressModel>> get state => AsyncState.success(addresses);
  AsyncState<void> get actionState => _actionState;
  bool get isSubmitting => _actionState.isLoading;

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
      await _repository.clear();
    } catch (e) {
      debugPrint('Error clearing addresses: $e');
    }
    notifyListeners();
  }

  Future<void> _loadAddresses() async {
    try {
      final addresses = await _repository.getAddresses();
      if (addresses.isNotEmpty) {
        _addresses
          ..clear()
          ..addAll(addresses);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    }
  }

  Future<void> _saveAddresses() async {
    try {
      await _repository.saveAddresses(_addresses);
    } catch (e) {
      debugPrint('Error saving addresses: $e');
    }
  }

  Future<bool> addAddress(AddressModel address) async {
    if (isSubmitting) return false;
    _actionState = _actionState.loading(keepData: false);
    notifyListeners();
    if (address.isDefault || _addresses.isEmpty) {
      // Set all other addresses isDefault to false
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
      _addresses.add(address.copyWith(isDefault: true));
    } else {
      _addresses.add(address);
    }
    await _saveAddresses();
    _actionState = AsyncState.success(null);
    notifyListeners();
    return true;
  }

  Future<bool> updateAddress(AddressModel address) async {
    if (isSubmitting) return false;
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index == -1) return false;
    _actionState = _actionState.loading(keepData: false);
    notifyListeners();

    if (address.isDefault) {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
      _addresses[index] = address.copyWith(isDefault: true);
    } else {
      _addresses[index] = address;
    }
    await _saveAddresses();
    _actionState = AsyncState.success(null);
    notifyListeners();
    return true;
  }

  Future<bool> deleteAddress(String id) async {
    if (isSubmitting) return false;
    final wasDefault = _addresses.any((a) => a.id == id && a.isDefault);
    if (!_addresses.any((a) => a.id == id)) return false;
    _actionState = _actionState.loading(keepData: false);
    notifyListeners();
    _addresses.removeWhere((a) => a.id == id);
    if (wasDefault && _addresses.isNotEmpty) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    await _saveAddresses();
    _actionState = AsyncState.success(null);
    notifyListeners();
    return true;
  }

  Future<bool> setDefaultAddress(String id) async {
    if (isSubmitting) return false;
    if (!_addresses.any((a) => a.id == id)) return false;
    _actionState = _actionState.loading(keepData: false);
    notifyListeners();
    for (int i = 0; i < _addresses.length; i++) {
      final isTarget = _addresses[i].id == id;
      _addresses[i] = _addresses[i].copyWith(isDefault: isTarget);
    }
    await _saveAddresses();
    _actionState = AsyncState.success(null);
    notifyListeners();
    return true;
  }
}
