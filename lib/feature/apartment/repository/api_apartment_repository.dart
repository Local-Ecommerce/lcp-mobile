import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';

import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';

class ApiApartmentRepository {
  final Dio _dio = new Dio();

  Future<List<Apartment>> getAllApartments() async {
    List<Apartment> apartments;
    try {
      Response response = await _dio.get(ApiService.APARTMENT);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      Data data = Data.fromJson(baseResponse.data);

      apartments =
          List.from(data.list).map((e) => Apartment.fromJson(e)).toList();
      _dio.clear();
      return apartments;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
    return apartments;
  }

  Future<List<Apartment>> getApartmentById(String id) async {
    List<Apartment> apartments;
    String _url = ApiService.APARTMENT + "?id=$id";

    try {
      Response response = await _dio.get(_url);
      BaseResponse baseResponse =
          BaseResponse.fromJson(jsonDecode(response.data));

      Data data = Data.fromJson(baseResponse.data);

      apartments =
          List.from(data.list).map((e) => Apartment.fromJson(e)).toList();
      _dio.clear();
      return apartments;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
    return apartments;
  }
}
