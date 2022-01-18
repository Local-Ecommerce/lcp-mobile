import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/profile/repository/profile_repository.dart';

class FirebaseProfileRepository extends ProfileRepository {
  FirebaseAuth _auth;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  FirebaseProfileRepository() {
    _auth = FirebaseAuth.instance;
  }

  @override
  Future<void> logout() {
    return _auth.signOut();
  }

  @override
  Future<UserData> getUserInfo() async {
    if (_auth.currentUser == null) return null;
    var userFirebase = await userCollection.doc(_auth.currentUser.uid).get();
    return _mapDocumentToUserData(userFirebase);
  }

  UserData _mapDocumentToUserData(DocumentSnapshot data) {
    return UserData(
      uid: data.data()['uid'],
      email: data.data()['email'],
      firstname: data.data()['firstname'],
      lastname: data.data()['lastname'],
      username: data.data()['username'],
      dob: data.data()['dob'],
    );
  }
}
