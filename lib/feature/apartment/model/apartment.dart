import 'package:flutter/cupertino.dart';

class Apartment {
  String apartmentId;
  String apartmentName;
  String address;

  Apartment({this.apartmentId, this.apartmentName, this.address});

  @override
  String toString() {
    return 'UserData{apartmentId: $apartmentId, apartmentName: $apartmentName, addess: $address}';
  }
}

List<String> lstApartment = [
  'Chung cư Sky9',
  'Chung cư Vinhome',
  'Chung cư Xala'
];
