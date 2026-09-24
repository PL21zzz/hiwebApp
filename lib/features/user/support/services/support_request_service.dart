import 'package:flutter/foundation.dart';
import 'package:hiweb_app_management/features/user/support/models/support_request_model.dart';
import 'package:hiweb_app_management/features/user/support/repositories/support_repository.dart';

class SupportRequestService extends ChangeNotifier {
  static final SupportRequestService _instance = SupportRequestService._internal();
  static SupportRequestService get instance => _instance;

  SupportRequestService._internal() : _repository = LocalSupportRepository() {
    _loadRequests();
  }

  final SupportRepository _repository;
  final List<SupportRequestModel> _requests = [];
  List<SupportRequestModel> get requests => List.unmodifiable(_requests);

  Future<void> _loadRequests() async {
    try {
      final requests = await _repository.getRequests();
      if (requests.isNotEmpty) {
        _requests
          ..clear()
          ..addAll(requests);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading support requests: $e');
    }
  }

  Future<void> _saveRequests() async {
    try {
      await _repository.saveRequests(_requests);
    } catch (e) {
      debugPrint('Error saving support requests: $e');
    }
  }

  void addRequest(SupportRequestModel request) {
    _requests.insert(0, request);
    _saveRequests();
    notifyListeners();
  }

  Future<void> clear() async {
    _requests.clear();
    try {
      await _repository.clear();
    } catch (e) {
      debugPrint('Error clearing support requests: $e');
    }
    notifyListeners();
  }
}
