class Payments {
  String paymentId;
  int paymentAmount;
  String dateTime;
  String orderId;
  String paymentMethodId;
  int status;

  Payments(
      {this.paymentId,
      this.paymentAmount,
      this.dateTime,
      this.orderId,
      this.paymentMethodId,
      this.status});

  Payments.fromJson(Map<String, dynamic> json) {
    paymentId = json['PaymentId'];
    paymentAmount = json['PaymentAmount'];
    dateTime = json['DateTime'];
    orderId = json['OrderId'];
    paymentMethodId = json['PaymentMethodId'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PaymentId'] = this.paymentId;
    data['PaymentAmount'] = this.paymentAmount;
    data['DateTime'] = this.dateTime;
    data['OrderId'] = this.orderId;
    data['PaymentMethodId'] = this.paymentMethodId;
    data['Status'] = this.status;
    return data;
  }
}

class PaymentRequest {
  double paymentAmount;
  String orderId;
  String paymentMethodId;
  String redirectUrl;

  PaymentRequest(
      {this.paymentAmount,
      this.orderId,
      this.paymentMethodId,
      this.redirectUrl});

  PaymentRequest.fromJson(Map<String, dynamic> json) {
    paymentAmount = json['paymentAmount'];
    orderId = json['orderId'];
    paymentMethodId = json['paymentMethodId'];
    redirectUrl = json['redirectUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentAmount'] = this.paymentAmount;
    data['orderId'] = this.orderId;
    data['paymentMethodId'] = this.paymentMethodId;
    data['redirectUrl'] = this.redirectUrl;
    return data;
  }
}

class PaymentResponses {
  String _payUrl;
  // String _deeplink;

  PaymentResponses({String payUrl, String deeplink}) {
    this._payUrl = payUrl;
    // this._deeplink = deeplink;
  }

  String get payUrl => _payUrl;
  set payUrl(String payUrl) => _payUrl = payUrl;
  // String get deeplink => _deeplink;
  // set deeplink(String deeplink) => _deeplink = deeplink;

  PaymentResponses.fromJson(Map<String, dynamic> json) {
    _payUrl = json['PayUrl'] != null ? json['PayUrl'] : '';
    // _deeplink = json['Deeplink'] != null ? json['Deeplink'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PayUrl'] = this._payUrl;
    // data['Deeplink'] = this._deeplink;
    return data;
  }

  @override
  toString() {
    return 'payment( payUrl: $_payUrl)';
  }
}
