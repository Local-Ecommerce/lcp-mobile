import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const BASE_URL ="https://localcommercialplatform-api.azurewebsites.net/api";
  // static const BASE_URL = "https://192.168.149.1:5001/api";
  static const ACCOUNT = "${BASE_URL}/accounts";
  static const RESIDENT = "${BASE_URL}/residents";
  static const PRODUCT = "${BASE_URL}/products";
  static const APARTMENT = "${BASE_URL}/apartments";
  static const COLLECTION = "${BASE_URL}/collection";
  static const MENU = "${BASE_URL}/menus";
  static const STORE = "${BASE_URL}/stores";
  static const NEWS = "${BASE_URL}/news";
  static const POIS = "${BASE_URL}/pois";
  static const PAYMENT = "${BASE_URL}/payments";
  static const PAYMENTMETHOD = "${BASE_URL}/payment-methods";
  static const PRODUCTCATEGORY = "${BASE_URL}/categories-products";
  static const SYSTEMCATEGORY = "${BASE_URL}/categories";
  static const ORDER = "${BASE_URL}/orders";

  Future<dynamic> get(String uri,
      {Map<String, dynamic> params, Map<String, String> headers}) async {
    try {
      http.Response response = await http.get(
          Uri(path: BASE_URL + uri, queryParameters: params),
          headers: headers);

      final statusCode = response.statusCode;
      final String jsonBody = response.body;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new Exception("Error request: $statusCode");
      }

      const JsonDecoder decoder = const JsonDecoder();
      return decoder.convert(response.body);
    } on Exception catch (ex) {
      throw new Exception(ex.toString());
    }
  }

  Future<dynamic> post(String uri, dynamic body,
      {Map<String, dynamic> params, Map<String, String> headers}) async {
    try {
      http.Response response = await http.post(
          Uri(path: BASE_URL + uri, queryParameters: params),
          headers: headers,
          body: body);

      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300) {
        throw new Exception("Error request: $statusCode");
      }

      const JsonDecoder decoder = const JsonDecoder();
      return decoder.convert(response.body);
    } on Exception catch (ex) {
      throw new Exception(ex.toString());
    }
  }

  Future<dynamic> put(String uri, dynamic body,
      {Map<String, dynamic> params, Map<String, String> headers}) async {
    try {
      http.Response response = await http.put(
          Uri(path: BASE_URL + uri, queryParameters: params),
          headers: headers,
          body: body);

      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300) {
        throw new Exception("Error request: $statusCode");
      }

      const JsonDecoder decoder = const JsonDecoder();
      return decoder.convert(response.body);
    } on Exception catch (ex) {
      throw new Exception(ex.toString());
    }
  }
}
