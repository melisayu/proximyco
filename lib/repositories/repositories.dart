import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';

abstract class IUserRepository {
  Future<User?> getCurrentUser();
  Future<User> createUser(String nickname, String postalCode);
  Future<void> updateUser(User user);
  Future<void> clearUser();
}

class InMemoryUserRepository implements IUserRepository {
  final SharedPreferences _prefs;
  static const String _userKey = 'current_user';

  InMemoryUserRepository(this._prefs);

  @override
  Future<User?> getCurrentUser() async {
    final String? userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  @override
  Future<User> createUser(String nickname, String postalCode) async {
    final user = User(
      id: const Uuid().v4(),
      nickname: nickname,
      postalCode: postalCode,
      rootMinutes: 120,
    );
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<void> updateUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }
}
