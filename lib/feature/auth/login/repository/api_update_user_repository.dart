import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/auth/login/repository/api_login_repository.dart';
import 'package:lcp_mobile/feature/auth/login/repository/update_user_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

import 'package:lcp_mobile/references/user_preference.dart';

class ApiUpdateUserRepository extends UpdateRepository {
  ApiLoginRepository _apiLoginRepository = new ApiLoginRepository();

  final Dio _dio = new Dio();

  RefreshTokens _refreshTokens;

  UserData _userData;

  Future<bool> updateUser(UserData userData) async {
    _userData = UserPreferences.getUser();

    String id = _userData.residentId;
    

    UserUpdateRequest userUpdateRequest = UserUpdateRequest(
        deliveryAddress: userData.deliveryAddress,
        dob: userData.dob,
        fullName: userData.fullName,
        gender: userData.gender,
        phoneNumber: userData.phoneNumber,
        profileImage: userData.profileImage);

    final requestJson = userUpdateRequest.toJson();

    String url = ApiService.RESIDENT + "?id=$id";

    print(url);

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options
      ..headers["Authorization"] = "Bearer ${_refreshTokens.accessToken}";

    await _dio.put(
      url,
      data: requestJson,
    );
    print(_userData.uid);

    UserDataResponse userDataResponse = await getUserById(_userData.uid);

    UserData resident = await getResidentById(_userData.residentId);

    resident.profileImage = userDataResponse.profileImage;

    UserPreferences.updateUser(resident);

    _dio.clear();

    return true;
  }

  @override
  Future<UserDataResponse> getUserById(String id) async {
    UserDataResponse userDataResponse = UserDataResponse();

    String _url = ApiService.ACCOUNT + "?id=$id";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";
    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      userDataResponse = UserDataResponse.fromJson(_baseResponse.data);

      _dio.clear();
      return userDataResponse;
    } on Exception catch (e) {
      print(e);
    }
    return userDataResponse;
  }

  @override
  Future<UserData> getResidentById(String id) async {
    UserData userData = UserData();

    String _url = ApiService.RESIDENT + "?id=$id";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";
    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<UserData> _listResident =
          List.from(data.list).map((e) => UserData.fromJson(e)).toList();

      userData = _listResident[0];

      _dio.clear();
      return userData;
    } on Exception catch (e) {
      print(e);
    }
    return userData;
  }
}
