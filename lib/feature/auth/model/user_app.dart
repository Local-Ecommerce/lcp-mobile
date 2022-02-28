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

  UserData(
      {this.uid,
      this.username,
      this.email,
      this.password,
      this.dob,
      this.fullName,
      this.phoneNumber,
      this.gender,
      this.tokenId});

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
