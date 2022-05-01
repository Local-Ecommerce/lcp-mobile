import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/order/model/order.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/references/user_preference.dart';

class ApiOrderRepository {
  final Dio _dio = new Dio();

  RefreshTokens _refreshTokens;

  Future<Order> getOrderById(String orderId, bool isHavePayemt) async {
    String _url;

    isHavePayemt
        ? _url =
            ApiService.ORDER + "?id=${orderId}&include=product&include=payment"
        : _url = ApiService.ORDER + "?id=${orderId}&include=product";

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<Order> _lstOrder =
          List.from(data.list).map((e) => Order.fromJson(e)).toList();

      _dio.clear();
      return _lstOrder[0];
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<List<Order>> createOrder(List<OrderRequest> lstOrder) async {
    String _url = ApiService.ORDER;

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    String jsonOrder = jsonEncode(lstOrder);

    try {
      Response _response = await _dio.post(_url, data: jsonOrder);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      // Data data = Data.fromJson(_baseResponse.data);

      List<Order> _lstOrder =
          List.from(_baseResponse.data).map((e) => Order.fromJson(e)).toList();

      _dio.clear();
      return _lstOrder;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<List<Order>> getListOrderByStatus(String status) async {
    String _url = ApiService.ORDER + '?status=${status}&include=product';

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      // Data data = Data.fromJson(_baseResponse.data);

      List<Order> _lstOrder =
          List.from(_baseResponse.data).map((e) => Order.fromJson(e)).toList();

      _dio.clear();
      return _lstOrder;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<List<Order>> getListOrder() async {
    String _url = ApiService.ORDER + '?include=product&include=payment';

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.get(_url);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      Data data = Data.fromJson(_baseResponse.data);

      List<Order> _lstOrder =
          List.from(data.list).map((e) => Order.fromJson(e)).toList();

      _dio.clear();
      return _lstOrder;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }

  Future<bool> cancelOrder(String id) async {
    String _url = ApiService.ORDER + '?id=${id}&status=5002';

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.put(_url);
      _dio.clear();
      return true;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }
}
