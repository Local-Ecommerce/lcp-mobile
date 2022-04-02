import 'package:flutter/cupertino.dart';

class UserData {
  String uid;
  String residentId;
  String username;
  String email;
  String password;
  String confirmPassword;
  String dob;
  String fullName;
  String apartmentId;
  String phoneNumber;
  String gender;
  String tokenId;
  String role;
  String deliveryAddress;
  int status;
  String type;

  UserData(
      {this.uid,
      this.username,
      this.email,
      this.password,
      this.dob,
      this.fullName,
      this.phoneNumber,
      this.gender,
      this.role,
      this.apartmentId,
      this.residentId,
      this.type});

  UserData.fromJson(Map<String, dynamic> json)
      : uid = json['AccountId'],
        username = json['Username'],
        phoneNumber = json['PhoneNumber'],
        fullName = json['ResidentName'],
        email = json['Username'],
        dob = json['DateOfBirth'],
        gender = json['Gender'],
        status = json['Status'],
        deliveryAddress = json['DeliveryAddress'],
        residentId = json['ResidentId'],
        apartmentId = json['ApartmentId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResidentId'] = this.residentId;
    data['ResidentName'] = this.fullName;
    data['PhoneNumber'] = this.phoneNumber;
    data['DateOfBirth'] = this.dob;
    data['Gender'] = this.gender;
    data['Status'] = this.status;
    data['DeliveryAddress'] = this.deliveryAddress;
    data['Type'] = this.type;
    data['AccountId'] = this.uid;
    data['ApartmentId'] = this.apartmentId;
    return data;
  }

  @override
  String toString() {
    return 'UserData{uid: $uid, username: $username, email: $email, dob: $dob, lastname: $fullName, firstname: $tokenId, apartment: $apartmentId, }';
  }
}

class Credential {
  final String email;
  final String password;

  const Credential({this.email, this.password});

  @override
  String toString() => 'Credential{email: $email, password: $password}';
}

class UserModel {
  final String email;
  final String token;

  UserModel(@required this.email, @required this.token);
}

class RefreshTokens {
  String accessTokenExpiredDate;
  String token;
  String accessToken;

  RefreshTokens({this.accessTokenExpiredDate, this.token, this.accessToken});

  RefreshTokens.fromJson(Map<String, dynamic> json) {
    accessTokenExpiredDate = json['AccessTokenExpiredDate'];
    token = json['Token'];
    accessToken = json['AccessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AccessTokenExpiredDate'] = this.accessTokenExpiredDate;
    data['Token'] = this.token;
    data['AccessToken'] = this.accessToken;
    return data;
  }

  @override
  String toString() {
    return 'RefreshTokens{accessTokenExpiredDate: $accessTokenExpiredDate, token: $token, accessToken: $accessToken}';
  }
}

class UserRequest {
  String firebaseToken;
  String role;

  UserRequest({this.firebaseToken, this.role});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['firebaseToken'] = this.firebaseToken;
    data['role'] = this.role;
    return data;
  }

  UserRequest.fromJson(Map<String, dynamic> json) {
    firebaseToken = json['firebaseToken'];
    role = json['role'];
  }

  @override
  String toString() =>
      'UserRequest{ firebaseToken: $firebaseToken, role: $role}';
}

class TokenRequest {
  String token;
  String accessToken;

  TokenRequest({this.token, this.accessToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['token'] = this.token;
    data['accessToken'] = this.accessToken;

    return data;
  }

  TokenRequest.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    accessToken = json['accessToken'];
  }
}
