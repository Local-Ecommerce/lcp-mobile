import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/api/base_response.dart';
import 'package:lcp_mobile/feature/auth/login/repository/login_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

import 'package:dio/dio.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';

class FirebaseLoginRepository extends LoginRepository {
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Dio _dio;
  String baseUrl = ApiService.ACCOUNT;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  FirebaseLoginRepository() {
    _auth = FirebaseAuth.instance;
  }

  GoogleSignInAccount _googleUser;

  GoogleSignInAccount get googleUser => _googleUser;

  @override
  Future<bool> isSignedIn() async {
    return _auth.currentUser != null;
  }

  @override
  Future<bool> signIn(String email, String password) async {
    try {
      print('$email - $password');
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var token = await _auth.currentUser.getIdToken();

      print(result.user.toString());

      print("Token is:");
      print(token);
      apiLogin(token);

      return result.user != null;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateUserData(UserData userData) async {
    return await userCollection.doc(userData.uid).set({
      'username': userData.username,
      'email': userData.email,
      'dob': userData.dob,
      'fullname': userData.fullName,
    });
  }

  Future<bool> register(UserData userData) async {
    try {
      print(userData.email);
      print(userData.password);
      var result = await _auth.createUserWithEmailAndPassword(
          email: userData.email, password: userData.password);
      userData.uid = result.user.uid;
      print("//==============================");
      print(userData.toString());
      await updateUserData(userData);
      return result.user != null;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  // Future<Map<dynamic, dynamic>> get _userClaims async {
  //   final user = _auth.currentUser;

  //   // If refresh is set to true, a refresh of the id token is forced.
  //   final idTokenResult = await user.getIdTokenResult(true);

  //   return idTokenResult.claims;
  // }

  Future<bool> googleLogin() async {
    // _googleSignIn.signOut();

    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return false;
    _googleUser = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    UserData _user = UserData(
      uid: _auth.currentUser.uid,
      email: _auth.currentUser.email,
      fullName: _auth.currentUser.displayName,
      username: _auth.currentUser.displayName,
    );

    // print(userCollection.doc(_user.uid));

    var userFirebase = await userCollection.doc(_user.uid).get();
    try {
      if (userFirebase.data() == null) {
        await updateUserData(_user);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
    return _googleUser != null;
  }

  Future<bool> apiLogin(String tokenId) async {
    Response response = await _dio.post(baseUrl +
        '/login?firebaseToken=${tokenId}&role=${ApiStrings.userRole}');

    if (response.statusCode == 415) {
      if (_auth.currentUser != null) {
        await _auth.signOut();
        return false;
      } else {
        await _googleSignIn.signOut();
        return false;
      }
    }

    print("Response:");
    print(response);
    BaseResponse baseResponse =
        BaseResponse.fromJson(jsonDecode(response.data));

    UserDataResponse userDataResponse =
        UserDataResponse.fromJson(baseResponse.data);

    print("userDataResponse:");
    print(userDataResponse);
    // UserData userData = UserData.fromJson(userDataResponse.residents);
    // print(googleAuth.idToken);
    // UserPreferences.setUser(data);
  }

  Future<bool> clearUserPreference() {}
}
