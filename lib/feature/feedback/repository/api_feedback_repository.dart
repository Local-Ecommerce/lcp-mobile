import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

import 'package:lcp_mobile/feature/feedback/model/feedback.dart';
import 'package:lcp_mobile/references/user_preference.dart';

class ApiFeedBackRepository {
  final Dio _dio = new Dio();

  RefreshTokens _refreshTokens;

  Future<bool> createFeedback(FeedbackRequest feedback) async {
    String _url = ApiService.FEEDBACK;

    _refreshTokens = TokenPreferences.getRefreshTokens();
    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.post(_url, data: jsonEncode(feedback));
      // BaseResponse _baseResponse =
      //     BaseResponse.fromJson(jsonDecode(_response.data));

      // Data data = Data.fromJson(_baseResponse.data);

      // List<Product> _listProduct =
      //     List.from(data.list).map((e) => Product.fromJson(e)).toList();

      _dio.clear();
      return true;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
      return false;
    }
  }
}
