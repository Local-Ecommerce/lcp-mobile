import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/auth/login/repository/api_login_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';

class ApiDiscoverRepository {
  final Dio _dio = new Dio();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");
  RefreshTokens _refreshTokens;
  ApiLoginRepository _apiLoginRepository = new ApiLoginRepository();

  Future<List<Product>> getAllProduct() async {
    try {
      Response response = await _dio.get(ApiService.PRODUCT);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      List<Product> organizations =
          List.from(baseResponse.data).map((e) => Product.fromJson(e)).toList();

      _dio.clear();
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<List<Product>> getProductListByApartment(String apartmentId) async {
    String _url = ApiService.PRODUCT +
        "?apartmentid=${apartmentId}&status=${ApiStrings.activeProduct}";

    _refreshTokens = TokenPreferences.getRefreshTokens();
    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<Product> _listProduct =
          List.from(data.list).map((e) => Product.fromJson(e)).toList();

      _dio.clear();
      return _listProduct;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<List<Product>> getProductByApartmentCategory(
      String apartmentId, String categoryId) async {
    String _url = ApiService.PRODUCT +
        "?apartmentid=${apartmentId}&categoryid=${categoryId}&status=${ApiStrings.activeProduct}";

    _refreshTokens = TokenPreferences.getRefreshTokens();
    if (_refreshTokens != null) {
      _dio.options.headers["Authorization"] =
          "Bearer ${_refreshTokens.accessToken}";
      // _dio.options.headers["Authorization"] = "Bearer ${ApiStrings.token}";
    }

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<Product> _listProduct =
          List.from(data.list).map((e) => Product.fromJson(e)).toList();
      _dio.clear();
      return _listProduct;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<Product> getProductDetail(String productId) async {
    String _url = ApiService.PRODUCT + "?id=${productId}";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";
    // _dio.options.headers["Authorization"] = "Bearer ${ApiStrings.token}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<Product> _listProduct =
          List.from(data.list).map((e) => Product.fromJson(e)).toList();

      // print(_listProduct[0].children);
      _dio.clear();
      return _listProduct[0];
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<List<Product>> searchProductByName(String name) async {
    String _url = ApiService.PRODUCT + "?search=${name}";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";
    // _dio.options.headers["Authorization"] = "Bearer ${ApiStrings.token}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<Product> _listProduct =
          List.from(data.list).map((e) => Product.fromJson(e)).toList();

      // print(_listProduct[0].children);
      _dio.clear();
      return _listProduct;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }
}
