import 'package:flutter/cupertino.dart';

class ApartmentRepository {
  int _resultCode;
  String _resultMessage;
  Apartment _apartment;

  ApartmentRepository({int resultCode, String resultMessage, Apartment apartment}) {
    if (resultCode != null) {
      this._resultCode = resultCode;
    }
    if (resultMessage != null) {
      this._resultMessage = resultMessage;
    }
    if (apartment != null) {
      this._apartment = apartment;
    }
  }

  int get resultCode => _resultCode;
  set resultCode(int resultCode) => _resultCode = resultCode;
  String get resultMessage => _resultMessage;
  set resultMessage(String resultMessage) => _resultMessage = resultMessage;
  Apartment get apartment => _apartment;
  set apartment(Apartment apartment) => _apartment = apartment;

  ApartmentRepository.fromJson(Map<String, dynamic> json) {
    _resultCode = json['ResultCode'];
    _resultMessage = json['ResultMessage'];
    _apartment =
        json['Data'] != null ? new Apartment.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResultCode'] = this._resultCode;
    data['ResultMessage'] = this._resultMessage;
    if (this._apartment != null) {
      data['Data'] = this._apartment.toJson();
    }
    return data;
  }
}

class Apartment {
  String apartmentId;
  String apartmentName;
  String address;
  int status;

  Apartment({this.apartmentId, this.apartmentName, this.address, this.status});

  @override
  String toString() {
    return 'UserData{apartmentId: $apartmentId, apartmentName: $apartmentName, addess: $address}';
  }

  Apartment.fromJson(Map<String, dynamic> json) {
    apartmentId = json['ApartmentId'];
    apartmentName = json['ApartmentName'];
    address = json['Address'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ApartmentId'] = this.apartmentId;
    data['ApartmentName'] = this.apartmentName;
    data['Address'] = this.address;
    data['Status'] = this.status;
    return data;
  }
}

List<String> lstApartment = [
  'Chung cư Sky9',
  'Chung cư Vinhome',
  'Chung cư Xala'
];
