import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/product_category/model/system_category.dart';

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

class UserDataResponse {
  List<UserData> residents;
  List<RefreshTokens> refreshTokens;
  String accountId;
  String username;
  String profileImage;
  String avatarImage;
  String createdDate;
  String updatedDate;
  int status;
  String roleId;

  UserDataResponse(
      {this.residents,
      this.refreshTokens,
      this.accountId,
      this.username,
      this.profileImage,
      this.avatarImage,
      this.createdDate,
      this.updatedDate,
      this.status,
      this.roleId});

  UserDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Residents'] != null) {
      residents = <UserData>[];
      json['Residents'].forEach((v) {
        residents.add(new UserData.fromJson(v));
      });
    }
    if (json['RefreshTokens'] != null) {
      refreshTokens = <RefreshTokens>[];
      json['RefreshTokens'].forEach((v) {
        refreshTokens.add(new RefreshTokens.fromJson(v));
      });
    }
    accountId = json['AccountId'];
    username = json['Username'];
    profileImage = json['ProfileImage'];
    avatarImage = json['AvatarImage'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
    status = json['Status'];
    roleId = json['RoleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.residents != null) {
      data['Residents'] = this.residents.map((v) => v.toJson()).toList();
    }
    if (this.refreshTokens != null) {
      data['RefreshTokens'] =
          this.refreshTokens.map((v) => v.toJson()).toList();
    }
    data['AccountId'] = this.accountId;
    data['Username'] = this.username;
    data['ProfileImage'] = this.profileImage;
    data['AvatarImage'] = this.avatarImage;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedDate'] = this.updatedDate;
    data['Status'] = this.status;
    data['RoleId'] = this.roleId;
    return data;
  }
}

class ChildrenDataResponse {
  List<SysCategory> children;
  String systemCategoryId;
  String sysCategoryName;
  String type;
  int status;
  int categoryLevel;
  String belongTo;

  ChildrenDataResponse(
      {this.children,
      this.systemCategoryId,
      this.sysCategoryName,
      this.type,
      this.status,
      this.categoryLevel,
      this.belongTo});

  ChildrenDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['Children'] != null) {
      children = <SysCategory>[];
      json['Children'].forEach((v) {
        children.add(new SysCategory.fromJson(v));
      });
    }
    systemCategoryId = json['SystemCategoryId'];
    sysCategoryName = json['SysCategoryName'];
    type = json['Type'];
    status = json['Status'];
    categoryLevel = json['CategoryLevel'];
    belongTo = json['BelongTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.children != null) {
      data['Children'] = this.children.map((v) => v.toMapSql()).toList();
    }
    data['SystemCategoryId'] = this.systemCategoryId;
    data['SysCategoryName'] = this.sysCategoryName;
    data['Type'] = this.type;
    data['Status'] = this.status;
    data['CategoryLevel'] = this.categoryLevel;
    data['BelongTo'] = this.belongTo;
    return data;
  }
}
