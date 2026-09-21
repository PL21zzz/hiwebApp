import 'package:flutter/foundation.dart';
import '../models/auth/user_model.dart';

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

  AuthService._internal() {
    _seedDefaultUsers();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  final List<UserModel> _users = [];
  final Map<String, String> _credentials = {}; // key: identifier (user_name or email lowercased), value: password

  void _seedDefaultUsers() {
    final sampleUser = UserModel(
      id: 'usr_phongtuan_01',
      userName: 'phongtuan',
      password: '123456',
      firstName: 'Nguyễn Tuấn',
      lastName: 'Phong',
      phoneNumber: '0912345678',
      email: 'phongtuan@hiweb.vn',
      coins: 0,
      memberSince: '16/09/2026',
      rank: 'Thành viên từ: 16/09/2026',
    );
    _users.add(sampleUser);
    _credentials['phongtuan'] = '123456';
    _credentials['phongtuan@hiweb.vn'] = '123456';
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

    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      userName: userName.trim(),
      password: password,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phoneNumber: phoneNumber.trim(),
      email: email.trim(),
      points: 200,
      voucherCount: 2,
      rank: 'Thành viên Mới',
    );

    _users.add(newUser);
    _credentials[userNameKey] = password;
    _credentials[emailKey] = password;

    // Auto login after registration
    _currentUser = newUser;
    notifyListeners();

    return AuthResult(
      isSuccess: true,
      message: 'Đăng ký tài khoản thành công!',
      user: newUser,
    );
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
