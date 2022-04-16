import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/auth/login/repository/update_user_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';

class ApiUpdateUserRepository extends UpdateRepository {
  final Dio _dio = new Dio();

  RefreshTokens _refreshTokens;

  UserData _userData;

  Future<bool> updateUser(UserData userData) async {
    _userData = UserPreferences.getUser();

    String id = _userData.residentId;

    String url = ApiService.RESIDENT + "?id=$id";

    print(url);

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    await _dio.put(
      url,
      data: userData.toJson(),
    );
    return true;
  }
}
