import 'package:flutter/cupertino.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

abstract class UpdateRepository extends ChangeNotifier {
  Future<bool> updateUser(UserData userData);
}