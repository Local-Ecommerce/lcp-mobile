import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/payment/model/payment.dart';
import 'package:lcp_mobile/references/user_preference.dart';

class ApiPaymentRepository {
  final Dio _dio = new Dio();

  RefreshTokens _refreshTokens;

  Future<PaymentResponses> createPayment(
      PaymentRequest paymentRequest, String paymentMethod) async {
    // paymentRequest.redirectUrl = "lcp-mobile://";
    paymentRequest.redirectUrl = "https://lcpmobile.page.link";
    print(paymentRequest.orderId);
    if (paymentMethod == "momo") {
      paymentRequest.paymentMethodId = "PM_MOMO";
    } else {
      paymentRequest.paymentMethodId = "PM_CASH";
    }

    String jsonRequest = jsonEncode(paymentRequest);
    String _url = ApiService.PAYMENT;

    _refreshTokens = TokenPreferences.getRefreshTokens();

    _dio.options.headers["Authorization"] =
        "Bearer ${_refreshTokens.accessToken}";

    try {
      Response _response = await _dio.post(_url, data: jsonRequest);
      BaseResponse _baseResponse =
          BaseResponse.fromJson(jsonDecode(_response.data));

      // Data data = Data.fromJson(_baseResponse.data);

      // List<PaymentResponses> _lstPayment = List.from(_baseResponse.data)
      //     .map((e) => PaymentResponses.fromJson(e))
      //     .toList();
      PaymentResponses paymentResponse;
      _baseResponse.data != null
          ? paymentResponse = PaymentResponses.fromJson(_baseResponse.data)
          : paymentResponse = null;

      _dio.clear();
      return paymentResponse;
    } on DioError catch (ex) {
      log(jsonEncode(ex.response));
      _dio.clear();
    }
  }
}
