import 'dart:convert';

import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences _preferences;

  static const _keyUser = 'appUser';
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future updateUser(UserData user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static UserData getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? null : UserData.fromJson(jsonDecode(json));
  }

  static void clearUser() async {
    await _preferences.clear();
  }
}

class TokenPreferences {
  static SharedPreferences _preferences;

  static const _token = "accessToken";
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future updateUserToken(RefreshTokens refreshTokens) async {
    final json = jsonEncode(refreshTokens.toJson());

    await _preferences.setString(_token, json);
  }

  static RefreshTokens getRefreshTokens() {
    final json = _preferences.getString(_token);

    return json == null ? null : RefreshTokens.fromJson(jsonDecode(json));
  }

  static void clearToken() async {
    await _preferences.clear();
  }
}
