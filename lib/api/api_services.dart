import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const BASE_URL = "https://localhost:5001/api/";
  static const PRODUCT = "${BASE_URL}/product";
  static const APARTMENT = "${BASE_URL}/apartment";
  static const COLLECTION = "${BASE_URL}/collection";
  static const MENU = "${BASE_URL}/menu";
  static const STORE = "${BASE_URL}/store";
  static const NEWS = "${BASE_URL}/news";
  static const PAYMENT = "${BASE_URL}/payment";
  static const PAYMENTMETHOD = "${BASE_URL}/payment";

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
}
