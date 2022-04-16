import 'package:lcp_mobile/feature/auth/login/repository/login_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

class LoginService extends LoginRepository {
  @override
  Future<bool> isSignedIn() {
    // TODO: implement isSignedIn
    throw UnimplementedError();
  }

  @override
  Future<bool> register(UserData userData) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<bool> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserData(UserData userData) {
    // TODO: implement updateUserData
    throw UnimplementedError();
  }

  @override
  Future<bool> googleLogin() {
    // TODO: implement googleLogin
    throw UnimplementedError();
  }

  @override
  Future<bool> updateProfile(UserData userData) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}
