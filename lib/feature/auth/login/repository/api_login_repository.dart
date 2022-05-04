import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';

class ApiLoginRepository {
  final Dio _dio = new Dio();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  Future<User> getUser(String firebaseToken, String role) async {
    try {
      Response response = await _dio.get(ApiService.PRODUCT);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      UserData userData = UserData.fromJson(baseResponse.data);

      _dio.clear();
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<bool> apiLogin(String tokenId) async {
    String url = ApiService.ACCOUNT + '/login';

    UserRequest userRequest =
        UserRequest(firebaseToken: tokenId, role: ApiStrings.userRole);

    print(userRequest.toJson());

    try {
      Response response = await _dio.post(
        url,
        data: userRequest.toJson(),
      );
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      UserDataResponse userDataResponse =
          UserDataResponse.fromJson(baseResponse.data);

      UserData userData = UserData();

      

      userData = userDataResponse.residents[0];

      userData.profileImage = userDataResponse.profileImage;

      UserPreferences.updateUser(userData);

      print(userDataResponse.residents[0].toString());

      TokenPreferences.updateUserToken(userDataResponse.refreshTokens[0]);

      _dio.clear();
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<void> updateExpiredToken(
      String refreshToken, String accesssToken) async {
    String url = ApiService.ACCOUNT + '/refresh-token';

    TokenRequest tokenRequest =
        TokenRequest(token: refreshToken, accessToken: accesssToken);

    try {
      Response response = await _dio.post(url, data: tokenRequest.toJson());
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));
      TokenPreferences.updateUserToken(baseResponse.data);

      _dio.clear();
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }
}
