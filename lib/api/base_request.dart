class PaymentRequest {
  String _customerId;
  int _amount;
  String _message;
  String _payType;
  bool _isIncognito;
  String _sessionId;
  String _redirectUrl;

  PaymentRequest(
      {String donatorId,
      String donatorType,
      int amount,
      String message,
      String payType,
      bool isIncognito,
      String sessionId,
      String redirectUrl}) {
    this._customerId = _customerId;
    this._amount = amount;
    this._message = message;
    this._payType = payType;
    this._isIncognito = isIncognito;
    this._sessionId = sessionId;
    this._redirectUrl = redirectUrl;
  }

  String get donatorId => _customerId;
  set donatorId(String donatorId) => _customerId = donatorId;
  int get amount => _amount;
  set amount(int amount) => _amount = amount;
  String get message => _message;
  set message(String message) => _message = message;
  String get payType => _payType;
  set payType(String payType) => _payType = payType;
  bool get isIncognito => _isIncognito;
  set isIncognito(bool isIncognito) => _isIncognito = isIncognito;
  String get sessionId => _sessionId;
  set sessionId(String sessionId) => _sessionId = sessionId;
  String get redirectUrl => _redirectUrl;
  set redirectUrl(String redirectUrl) => _redirectUrl = redirectUrl;

  PaymentRequest.fromJson(Map<String, dynamic> json) {
    _customerId = json['DonatorId'];
    _amount = json['Amount'];
    _message = json['Message'];
    _payType = json['PayType'];
    _isIncognito = json['IsIncognito'];
    _sessionId = json['SessionId'];
    _redirectUrl = json['RedirectUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DonatorId'] = this._customerId;
    data['Amount'] = this._amount;
    data['Message'] = this._message;
    data['PayType'] = this._payType;
    data['IsIncognito'] = this._isIncognito;
    data['SessionId'] = this._sessionId;
    data['RedirectUrl'] = this._redirectUrl;
    return data;
  }
}
