import 'package:flutter/cupertino.dart';

class Apartment {
  String apartmentId;
  String apartmentName;
  String address;
  int status;

  Apartment({this.apartmentId, this.apartmentName, this.address, this.status});

  @override
  String toString() {
    return 'Apartment{apartmentId: $apartmentId, apartmentName: $apartmentName, addess: $address}';
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

List<String> genderList = ['Nam', 'Nữ', 'Khác'];

