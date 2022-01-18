import 'package:lcp_mobile/feature/auth/model/user_app.dart';

abstract class ProfileRepository {
  Future<void> logout();

  Future<UserData> getUserInfo();
}
