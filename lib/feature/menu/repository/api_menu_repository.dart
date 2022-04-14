import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/menu/model/menu.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';

class ApiMenuRepository {
  final Dio _dio = new Dio();

  // RefreshTokens refreshTokens = TokenPreferences.getToken();

  Future<List<Menu>> getMenuByApartmentIdType(
      String apartmentId, String type) async {
    String url = ApiService.MENU + "?apartmentid=${apartmentId}&Type=${type}";

    _dio.options.headers["Authorization"] = "Bearer ${ApiStrings.token}";

    try {
      Response response = await _dio.get(url);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      Data data = Data.fromJson(baseResponse.data);

      List<Menu> menus =
          List.from(data.list).map((e) => Menu.fromJson(e)).toList();
      _dio.clear();
      return menus;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }
}
