import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/product_category/model/product_category.dart';
import 'package:lcp_mobile/feature/product_category/model/system_category.dart';
import 'package:lcp_mobile/feature/profile/repository/profile_repository.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';
import 'package:lcp_mobile/widget/alert_dialog.dart';

class ApiProductCategoryRepository {
  final Dio _dio = new Dio();
  FirebaseAuth _auth = FirebaseAuth.instance;
  ProfileRepository _profileRepository;
  RefreshTokens _refreshTokens;

  Future<List<SysCategory>> getAllCategories() async {
    String _url = ApiService.SYSTEMCATEGORY + "?status=3001";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    if (_refreshTokens != null) {
      _dio.options.headers["Authorization"] =
          "Bearer ${_refreshTokens.accessToken}";
    }

    try {
      Response response = await _dio.get(_url);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      Data data = Data.fromJson(baseResponse.data);

      List<SysCategory> listSysCate =
          List.from(data.list).map((e) => SysCategory.fromJson(e)).toList();
      _dio.clear();
      return listSysCate;
    } on DioError catch (ex) {
      if (ex.response.statusCode == 408) {
        _dio.clear();
        // await _apiLoginRepository.updateExpiredToken(
        //     _refreshTokens.token, _refreshTokens.accessToken);
        String url = ApiService.ACCOUNT + '/refresh-token';

        TokenRequest tokenRequest = TokenRequest(
            token: _refreshTokens.token,
            accessToken: _refreshTokens.accessToken);

        Response response = await _dio.post(url,
            data: tokenRequest.toJson(),
            options: Options(
                followRedirects: false, validateStatus: (status) => true));
        BaseResponse baseResponse =
            BaseResponse.fromJson(jsonDecode(response.data));

        print(baseResponse.data);
        RefreshTokens _token = RefreshTokens.fromJson(baseResponse.data);
        print(_token);

        TokenPreferences.updateUserToken(_token);

        _dio.clear();
      } else if (ex.response.statusCode == 401) {
        // confirm(context)(
        //     "H???t h???n ????ng nh???p",
        //     "Phi??n ????ng nh???p ???? h???t h???n b???n vui l??ng ????ng nh???p l???i",
        //     () => _profileRepository.logout();
        // Fluttertoast.showToast(
        //   msg:
        //       "Phi??n ????ng nh???p ???? h???t h???n b???n vui l??ng ????ng nh???p l???i", // message
        //   toastLength: Toast.LENGTH_LONG, // length
        //   gravity: ToastGravity.CENTER, // location
        // );
        _profileRepository.logout();
      } else {
        log(jsonEncode(ex.response));
        _profileRepository.logout();
      }
    }
  }

  Future<List<SysCategory>> getCategoryByType(String productType) async {
    String _url =
        ApiService.SYSTEMCATEGORY + "?type=${productType}&status=3001";

    _refreshTokens = TokenPreferences.getRefreshTokens();
    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response response = await _dio.get(_url);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      Data data = Data.fromJson(baseResponse.data);

      List<SysCategory> listSysCate =
          List.from(data.list).map((e) => SysCategory.fromJson(e)).toList();
      _dio.clear();
      return listSysCate;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<List<SysCategory>> getChildListCategory(String categoryId) async {
    String _url = ApiService.SYSTEMCATEGORY + "?id=${categoryId}&status=3001";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response response = await _dio.get(_url);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      Data data = Data.fromJson(baseResponse.data);

      // ChildrenDataResponse child = ChildrenDataResponse.fromJson(data.list);

      List<SysCategory> listSysCate =
          List.from(data.list).map((e) => SysCategory.fromJson(e)).toList();

      List<SysCategory> listSysCateChild =
          List.from(listSysCate[0].lstSysCategories)
              .map((e) => SysCategory.fromJson(e))
              .toList();

      print(listSysCateChild);

      _dio.clear();
      return listSysCateChild;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }
}
