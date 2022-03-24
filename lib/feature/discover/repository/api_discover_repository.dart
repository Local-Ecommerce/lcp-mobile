import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

import 'package:lcp_mobile/feature/discover/model/product.dart';

class ApiDiscoverRepository {
  final Dio _dio = new Dio();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

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

  Future<List<Product>> getProductByApartmentId(Apartment apartmentId) async {}

  Future<List<Product>> getProductByCategoryId(Apartment apartmentId) async {}

  Future<List<Product>> getProductDetail(Apartment apartmentId) async {}
}
