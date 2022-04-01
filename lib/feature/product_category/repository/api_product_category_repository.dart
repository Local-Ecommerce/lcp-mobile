import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/product_category/model/product_category.dart';
import 'package:lcp_mobile/feature/product_category/model/system_category.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';

class ApiProductCategoryRepository {
  final Dio _dio = new Dio();
  FirebaseAuth _auth = FirebaseAuth.instance;

  RefreshTokens _refreshTokens;

  Future<List<SysCategory>> getAllCategories() async {
    String _url = ApiService.SYSTEMCATEGORY;

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response response = await _dio.get(ApiService.SYSTEMCATEGORY);
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

  Future<List<SysCategory>> getCategoryByType(String productType) async {
    String _url = ApiService.SYSTEMCATEGORY + "?type=${productType}";

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
    String _url = ApiService.SYSTEMCATEGORY + "?id=${categoryId}";

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
      _dio.clear();
      return listSysCate;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }
}
