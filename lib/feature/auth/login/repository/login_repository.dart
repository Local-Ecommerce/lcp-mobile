import 'package:flutter/cupertino.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:dio/dio.dart';

abstract class LoginRepository extends ChangeNotifier {
  Future<bool> signIn(String email, String password);
  Future<bool> isSignedIn();
  Future<void> updateUserData(UserData userData);
  Future<bool> register(UserData userData);
  Future<bool> googleLogin();
}
