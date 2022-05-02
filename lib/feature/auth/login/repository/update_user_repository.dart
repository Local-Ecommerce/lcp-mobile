import 'package:flutter/cupertino.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

abstract class UpdateRepository extends ChangeNotifier {
  Future<bool> updateUser(UserData userData);

  Future<UserDataResponse> getUserById(String id);

  Future<UserData> getResidentById(String id);
}