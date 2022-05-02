import 'package:flutter/cupertino.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

abstract class LoginRepository extends ChangeNotifier {
  Future<bool> signIn(String email, String password);
  Future<bool> isSignedIn();
  Future<void> updateUserData(UserData userData);
  Future<bool> register(UserData userData);
  Future<bool> updateProfile(UserData userData);
  Future<bool> googleLogin();
  Future<bool> resetPassword(String email);
  Future<bool> changePassword(String password, String newPassword);
}
