import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

import 'package:lcp_mobile/feature/discover/model/product.dart';
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

    try {
      Response response = await _dio.post(
        url,
        data: userRequest.toJson(),
      );
      print("Response là:");
      print(response);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      UserDataResponse userDataResponse =
          UserDataResponse.fromJson(baseResponse.data);

      print("userDataResponse:");
      print(userDataResponse);
      _dio.clear();
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
    // Response response = await _dio.post(baseUrl +
    //     '/login?firebaseToken=${tokenId}&role=${ApiStrings.userRole}');

    // if (response.statusCode == 415) {
    //   if (_auth.currentUser != null) {
    //     await _auth.signOut();
    //     return false;
    //   } else {
    //     await _googleSignIn.signOut();
    //     return false;
    //   }
    // }

    // UserData userData = UserData.fromJson(userDataResponse.residents);
    // print(googleAuth.idToken);
    // UserPreferences.setUser(data);
  }

  Future<bool> clearUserPreference() {}
}
