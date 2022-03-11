class BaseResponse {
  int _resultCode;
  String _resultMessage;
  dynamic _data;

  BaseResponse({int resultCode, String resultMessage, dynamic data}) {
    this._resultCode = resultCode;
    this._resultMessage = resultMessage;
    this._data = data;
  }

  int get resultCode => _resultCode;
  set resultCode(int resultCode) => _resultCode = resultCode;
  String get resultMessage => _resultMessage;
  set resultMessage(String resultMessage) => _resultMessage = resultMessage;
  dynamic get data => _data;
  set data(dynamic data) => _data = data;

  BaseResponse.fromJson(Map<String, dynamic> json) {
    _resultCode = json['ResultCode'];
    _resultMessage = json['ResultMessage'];
    _data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResultCode'] = this._resultCode;
    data['ResultMessage'] = this._resultMessage;
    data['Data'] = this._data;
    return data;
  }
}

class Data {
  dynamic _list;
  int _page;
  int _total;
  int _lastPage;

  Data({dynamic list, int page, int total, int lastPage}) {
    this._list = list;
    this._page = page;
    this._total = total;
    this._lastPage = lastPage;
  }

  dynamic get list => _list;
  set list(dynamic list) => _list = list;
  int get page => _page;
  set page(int page) => _page = page;
  int get total => _total;
  set total(int total) => _total = total;
  int get lastPage => _lastPage;
  set lastPage(int lastPage) => _lastPage = lastPage;

  Data.fromJson(Map<String, dynamic> json) {
    _list = json['List'];
    _page = json['Page'];
    _total = json['Total'];
    _lastPage = json['LastPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['List'] = this._list;
    data['Page'] = this._page;
    data['Total'] = this._total;
    data['LastPage'] = this._lastPage;
    return data;
  }
}
