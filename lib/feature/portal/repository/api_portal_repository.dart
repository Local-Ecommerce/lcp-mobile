import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/references/user_preference.dart';

class ApiPortalRepository {
  final Dio _dio = new Dio();

  RefreshTokens _refreshTokens;

  Future<List> getAllPoisByApartmentId(String apartmentId, String type) async {
    String _url = type == null
        ? ApiService.POIS + "?apartmentid=${apartmentId}"
        : ApiService.POIS + "?apartmentid=${apartmentId}&type=${type}";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<POI> _listPOI =
          List.from(data.list).map((e) => POI.fromJson(e)).toList();

      _dio.clear();
      return _listPOI;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<POI> getPOIDetail(String poiId) async {
    String _url = ApiService.POIS + "?id=${poiId}&status=7001";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<POI> _listPOI =
          List.from(data.list).map((e) => POI.fromJson(e)).toList();

      _dio.clear();
      return _listPOI[0];
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<List> getAllNewsByApartmentId(String apartmentId, String type) async {
    String _url = type == null
        ? ApiService.NEWS + "?apartmentid=${apartmentId}&status=7001"
        : ApiService.NEWS + "?apartmentid=${apartmentId}&type=${type}";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<New> _listNews =
          List.from(data.list).map((e) => New.fromJson(e)).toList();

      _dio.clear();
      return _listNews;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<New> getNewDetail(String poiId) async {
    String _url = ApiService.NEWS + "?id=${poiId}";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<New> _listNews =
          List.from(data.list).map((e) => New.fromJson(e)).toList();

      _dio.clear();
      return _listNews[0];
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }
}
