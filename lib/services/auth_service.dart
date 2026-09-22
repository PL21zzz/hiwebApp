import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user/user_model.dart';

class AuthResult {
  final bool isSuccess;
  final String message;
  final UserModel? user;

  AuthResult({
    required this.isSuccess,
    required this.message,
    this.user,
  });
}

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  static AuthService get instance => _instance;

  static const String _prefUsersKey = 'auth_registered_users';
  static const String _prefCredentialsKey = 'auth_registered_credentials';
  static const String _prefCurrentUserKey = 'auth_current_user';
  static const String _prefRememberIdKey = 'auth_remembered_identifier';
  static const String _prefRememberPassKey = 'auth_remembered_password';

  AuthService._internal() {
    _loadDataFromLocal();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  final List<UserModel> _users = [];
  final Map<String, String> _credentials = {}; // key: identifier (user_name or email lowercased), value: password

  String? _rememberedIdentifier;
  String? _rememberedPassword;
  bool _hasRememberedCredentials = false;

  bool get hasRememberedCredentials => _hasRememberedCredentials;

  Future<void> _loadDataFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Load users list
      final usersJsonString = prefs.getString(_prefUsersKey);
      if (usersJsonString != null && usersJsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(usersJsonString);
        _users.clear();
        for (final item in jsonList) {
          _users.add(UserModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }

      // 2. Load credentials map
      final credsJsonString = prefs.getString(_prefCredentialsKey);
      if (credsJsonString != null && credsJsonString.isNotEmpty) {
        final Map<String, dynamic> map = jsonDecode(credsJsonString);
        _credentials.clear();
        map.forEach((k, v) => _credentials[k] = v.toString());
      }

      // 3. Load current user
      final currentUserJsonString = prefs.getString(_prefCurrentUserKey);
      if (currentUserJsonString != null && currentUserJsonString.isNotEmpty) {
        _currentUser = UserModel.fromJson(jsonDecode(currentUserJsonString));
      }

      // 4. Load remembered credentials
      _rememberedIdentifier = prefs.getString(_prefRememberIdKey);
      _rememberedPassword = prefs.getString(_prefRememberPassKey);
      _hasRememberedCredentials =
          _rememberedIdentifier != null && _rememberedPassword != null;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auth data from SharedPreferences: $e');
    }
  }

  Future<void> _saveDataToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Save users list
      final usersListJson = _users.map((u) => u.toJson()).toList();
      await prefs.setString(_prefUsersKey, jsonEncode(usersListJson));

      // 2. Save credentials map
      await prefs.setString(_prefCredentialsKey, jsonEncode(_credentials));

      // 3. Save current user state
      if (_currentUser != null) {
        await prefs.setString(
            _prefCurrentUserKey, jsonEncode(_currentUser!.toJson()));
      } else {
        await prefs.remove(_prefCurrentUserKey);
      }
    } catch (e) {
      debugPrint('Error saving auth data to SharedPreferences: $e');
    }
  }

  Map<String, String>? getRememberedCredentials() {
    if (!_hasRememberedCredentials ||
        _rememberedIdentifier == null ||
        _rememberedPassword == null) {
      return null;
    }
    return {
      'identifier': _rememberedIdentifier!,
      'password': _rememberedPassword!,
    };
  }

  void saveRememberedCredentials(String identifier, String password) async {
    _rememberedIdentifier = identifier;
    _rememberedPassword = password;
    _hasRememberedCredentials = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefRememberIdKey, identifier);
      await prefs.setString(_prefRememberPassKey, password);
    } catch (_) {}
  }

  void clearRememberedCredentials() async {
    _rememberedIdentifier = null;
    _rememberedPassword = null;
    _hasRememberedCredentials = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefRememberIdKey);
      await prefs.remove(_prefRememberPassKey);
    } catch (_) {}
  }

  bool isUserNameTaken(String userName) {
    final key = userName.trim().toLowerCase();
    return _credentials.containsKey(key) ||
        _users.any((u) => u.userName.toLowerCase() == key);
  }

  bool isEmailTaken(String email) {
    final key = email.trim().toLowerCase();
    return _credentials.containsKey(key) ||
        _users.any((u) => u.email.toLowerCase() == key);
  }

  bool isPhoneTaken(String phone) {
    final key = phone.trim();
    return _users.any((u) => u.phoneNumber == key);
  }

  AuthResult login(String identifier, String password) {
    final key = identifier.trim().toLowerCase();

    if (!_credentials.containsKey(key)) {
      return AuthResult(
        isSuccess: false,
        message: 'Tài khoản hoặc email không tồn tại',
      );
    }

    final storedPassword = _credentials[key];
    if (storedPassword != password) {
      return AuthResult(
        isSuccess: false,
        message: 'Mật khẩu không chính xác',
      );
    }

    // Match user model by email or username
    UserModel? matchedUser = _users.firstWhere(
      (u) => u.userName.toLowerCase() == key || u.email.toLowerCase() == key,
      orElse: () => _users.first,
    );

    _currentUser = matchedUser;
    _saveDataToLocal();
    notifyListeners();

    return AuthResult(
      isSuccess: true,
      message: 'Đăng nhập thành công!',
      user: matchedUser,
    );
  }

  AuthResult register({
    required String userName,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) {
    final userNameKey = userName.trim().toLowerCase();
    final emailKey = email.trim().toLowerCase();

    if (isUserNameTaken(userName)) {
      return AuthResult(
        isSuccess: false,
        message: 'Tên đăng nhập ($userName) đã được sử dụng',
      );
    }

    if (isEmailTaken(email)) {
      return AuthResult(
        isSuccess: false,
        message: 'Email ($email) đã được đăng ký tài khoản khác',
      );
    }

    if (isPhoneTaken(phoneNumber)) {
      return AuthResult(
        isSuccess: false,
        message: 'Số điện thoại ($phoneNumber) đã được đăng ký tài khoản khác',
      );
    }

    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final formattedDate = '$day/$month/${now.year}';

    final newUser = UserModel(
      id: 'usr_${now.millisecondsSinceEpoch}',
      userName: userName.trim(),
      password: password,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phoneNumber: phoneNumber.trim(),
      email: email.trim(),
      points: 200,
      voucherCount: 2,
      memberSince: formattedDate,
      rank: 'Thành viên từ: $formattedDate',
    );

    _users.add(newUser);
    _credentials[userNameKey] = password;
    _credentials[emailKey] = password;

    // Auto login after registration
    _currentUser = newUser;
    _saveDataToLocal();
    notifyListeners();

    return AuthResult(
      isSuccess: true,
      message: 'Đăng ký tài khoản thành công!',
      user: newUser,
    );
  }

  void updateAvatar(String avatarUrl) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(avatarUrl: avatarUrl);

    final index = _users.indexWhere((u) => u.id == _currentUser!.id);
    if (index != -1) {
      _users[index] = _currentUser!;
    }

    _saveDataToLocal();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _saveDataToLocal();
    notifyListeners();
  }
}
