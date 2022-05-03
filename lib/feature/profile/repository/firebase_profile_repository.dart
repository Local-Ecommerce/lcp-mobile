import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lcp_mobile/db/db_provider.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/profile/repository/profile_repository.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:sqflite/sqflite.dart';

class FirebaseProfileRepository extends ProfileRepository {
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Database db;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  FirebaseProfileRepository() {
    _auth = FirebaseAuth.instance;
    db = DBProvider.instance.database;
  }

  @override
  Future<void> logout() async {
    if (_auth.currentUser != null) {
      TokenPreferences.clearToken();
      UserPreferences.clearUser();
      db.delete(DBProvider.TABLE_CART_ITEMS);
      return await _auth.signOut();
    } else {
      TokenPreferences.clearToken();
      UserPreferences.clearUser();
      db.delete(DBProvider.TABLE_CART_ITEMS);
      return await _googleSignIn.signOut();
    }
  }

  @override
  Future<UserData> getUserInfo() async {
    if (_auth.currentUser == null) return null;
    print(_auth.currentUser.toString());

    print('User là');
    print(UserPreferences.getUser());

    var userFirebase = await userCollection.doc(_auth.currentUser.uid).get();

    UserData data = UserPreferences.getUser();

    data.email = userFirebase.data()['email'];

    return data;
  }

  UserData _mapDocumentToUserData(DocumentSnapshot data) {
    return UserData(
      uid: data.data()['uid'],
      apartmentId: data.data()['apartmentId'],
      email: data.data()['email'],
      fullName: data.data()['fullname'],
      username: data.data()['username'],
      dob: data.data()['dob'],
    );
  }
}
