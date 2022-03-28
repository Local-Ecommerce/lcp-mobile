import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/profile/repository/profile_repository.dart';
import 'package:lcp_mobile/references/user_preference.dart';

class FirebaseProfileRepository extends ProfileRepository {
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  FirebaseProfileRepository() {
    _auth = FirebaseAuth.instance;
  }

  @override
  Future<void> logout() async {
    if (_auth.currentUser != null) {
      TokenPreferences.clearToken();
      UserPreferences.clearUser();
      return await _auth.signOut();
    } else {
      TokenPreferences.clearToken();
      UserPreferences.clearUser();
      return await _googleSignIn.signOut();
    }
  }

  @override
  Future<UserData> getUserInfo() async {
    if (_auth.currentUser == null) return null;
    print(_auth.currentUser.toString());

    var userFirebase = await userCollection.doc(_auth.currentUser.uid).get();

    return _mapDocumentToUserData(userFirebase);
  }

  UserData _mapDocumentToUserData(DocumentSnapshot data) {
    return UserData(
      uid: data.data()['uid'],
      email: data.data()['email'],
      fullName: data.data()['fullname'],
      username: data.data()['username'],
      dob: data.data()['dob'],
    );
  }
}
