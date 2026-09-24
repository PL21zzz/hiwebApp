import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiweb_app_management/features/auth/models/user_model.dart';

abstract class AuthRepository {
  Future<AuthLocalData> load();
  Future<void> save(AuthLocalData data);
  Future<void> clearRememberedCredentials();
}

class AuthLocalData {
  final List<UserModel> users;
  final Map<String, String> credentials;
  final UserModel? currentUser;
  final String? rememberedIdentifier;
  final String? rememberedPassword;

  const AuthLocalData({
    this.users = const [],
    this.credentials = const {},
    this.currentUser,
    this.rememberedIdentifier,
    this.rememberedPassword,
  });
}

class LocalAuthRepository implements AuthRepository {
  static const _usersKey = 'auth_registered_users';
  static const _credentialsKey = 'auth_registered_credentials';
  static const _currentUserKey = 'auth_current_user';
  static const _rememberIdKey = 'auth_remembered_identifier';
  static const _rememberPassKey = 'auth_remembered_password';

  @override
  Future<AuthLocalData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final users = <UserModel>[];
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null && usersJson.isNotEmpty) {
      for (final item in jsonDecode(usersJson) as List<dynamic>) {
        users.add(UserModel.fromJson(Map<String, dynamic>.from(item)));
      }
    }

    final credentials = <String, String>{};
    final credentialsJson = prefs.getString(_credentialsKey);
    if (credentialsJson != null && credentialsJson.isNotEmpty) {
      final map = jsonDecode(credentialsJson) as Map<String, dynamic>;
      map.forEach((key, value) => credentials[key] = value.toString());
    }

    final currentUserJson = prefs.getString(_currentUserKey);
    return AuthLocalData(
      users: users,
      credentials: credentials,
      currentUser: currentUserJson == null
          ? null
          : UserModel.fromJson(jsonDecode(currentUserJson)),
      rememberedIdentifier: prefs.getString(_rememberIdKey),
      rememberedPassword: prefs.getString(_rememberPassKey),
    );
  }

  @override
  Future<void> save(AuthLocalData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _usersKey,
      jsonEncode(data.users.map((user) => user.toJson()).toList()),
    );
    await prefs.setString(_credentialsKey, jsonEncode(data.credentials));
    if (data.currentUser == null) {
      await prefs.remove(_currentUserKey);
    } else {
      await prefs.setString(
        _currentUserKey,
        jsonEncode(data.currentUser!.toJson()),
      );
    }
    if (data.rememberedIdentifier == null || data.rememberedPassword == null) {
      await clearRememberedCredentials();
    } else {
      await prefs.setString(_rememberIdKey, data.rememberedIdentifier!);
      await prefs.setString(_rememberPassKey, data.rememberedPassword!);
    }
  }

  @override
  Future<void> clearRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberIdKey);
    await prefs.remove(_rememberPassKey);
  }
}
