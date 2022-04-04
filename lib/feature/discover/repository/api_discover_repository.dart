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

  Future<List<Product>> getProductListByApartmentType(
      String productType) async {
    String _url = ApiService.PRODUCT + "?type=${productType}";

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
      // _dio.options.headers["Authorization"] =
      //     "Bearer ${_refreshTokens.accessToken}";
      _dio.options.headers["Authorization"] = "Bearer ${ApiStrings.token}";
    }

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      // print("data: ");
      // print(_response);

      List<Product> _listProduct =
          List.from(data.list).map((e) => Product.fromJson(e)).toList();
      _dio.clear();
      return _listProduct;
    } on DioError catch (ex) {
      if (ex.response.statusCode == 408 || ex.response.statusCode == 401) {
        _dio.clear();
        // await _apiLoginRepository.updateExpiredToken(
        //     _refreshTokens.token, _refreshTokens.accessToken);
        String url = ApiService.ACCOUNT + '/refresh-token';

        TokenRequest tokenRequest = TokenRequest(
            token: _refreshTokens.token,
            accessToken: _refreshTokens.accessToken);

        try {
          Response response = await _dio.post(url,
              data: tokenRequest.toJson(),
              options: Options(
                  followRedirects: false, validateStatus: (status) => true));
          BaseResponse baseResponse =
              BaseResponse.fromJson(jsonDecode(response.data));

          print(response);

          TokenPreferences.updateUserToken(baseResponse.data);

          _dio.clear();
        } on DioError catch (ex) {
          log(jsonEncode(ex.response));
          _dio.clear();
        }
      } else {
        log(jsonEncode(ex.response));
      }
      // log(jsonEncode(ex.response));
    }
  }

  Future<Product> getProductDetail(String productId) async {
    String _url = ApiService.PRODUCT + "?id=${productId}";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    // _dio.options.headers["Authorization"] =
    // "Bearer ${_refreshTokens.accessToken}";
    _dio.options.headers["Authorization"] = "Bearer ${ApiStrings.token}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      print("data: ");
      print(data.list);

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
}
