import 'package:flutter/cupertino.dart';

class UserData {
  String uid;
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

  UserData(
      {this.uid,
      this.username,
      this.email,
      this.password,
      this.dob,
      this.fullName,
      this.phoneNumber,
      this.gender,
      this.tokenId,
      this.role,
      this.apartmentId});

  @override
  String toString() {
    return 'UserData{uid: $uid, username: $username, email: $email, dob: $dob, lastname: $fullName, firstname: $tokenId}';
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
}
