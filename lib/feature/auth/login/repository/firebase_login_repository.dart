import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lcp_mobile/api/api_services.dart';
import 'package:lcp_mobile/feature/auth/login/repository/api_login_repository.dart';
import 'package:lcp_mobile/feature/auth/login/repository/api_update_user_repository.dart';
import 'package:lcp_mobile/feature/auth/login/repository/login_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/references/user_preference.dart';

class FirebaseLoginRepository extends LoginRepository {
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  ApiLoginRepository _apiLoginRepository = new ApiLoginRepository();
  ApiUpdateUserRepository _apiUpdateUserRepository =
      new ApiUpdateUserRepository();
  String baseUrl = ApiService.ACCOUNT;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  FirebaseLoginRepository() {
    _auth = FirebaseAuth.instance;
    // _apiLoginRepository = new ApiLoginRepository();
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

      // print("Token is:");
      // print(token);
      await _apiLoginRepository.apiLogin(token);
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
      'role': userData.role,
      'apartmentId': userData.apartmentId
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

  Future<bool> updateProfile(UserData userData) async {
    FirebaseLoginRepository _authBloc = FirebaseLoginRepository();

    if (_authBloc.isSignedIn() != null) {
      try {
        return await _apiUpdateUserRepository.updateUser(userData);
      } on Exception catch (e) {
        return false;
      }
    } else {
      try {
        final idToken = await _auth.currentUser.getIdToken();
        userData.uid = _auth.currentUser.uid;
        userData.email = _auth.currentUser.email;
        userData.fullName = _auth.currentUser.displayName;
        userData.username = _auth.currentUser.displayName;
        print("//==============");
        print(userData.toString());
        await updateUserData(userData);
        await _apiLoginRepository.apiLogin(idToken);
        return true;
      } on FirebaseAuthException catch (e) {
        print(e);
        return false;
      }
    }
  }

  Future<bool> googleLogin() async {
    // _googleSignIn.signOut();

    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return false;
    _googleUser = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final _userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(_auth.currentUser.uid);
    var userFirebase = await userCollection.doc(_userCredential.user.uid).get();
    final idToken = await _auth.currentUser.getIdToken();
    try {
      if (userFirebase.data() == null) {
        return false;
      } else {
        await _apiLoginRepository.apiLogin(idToken);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
    return _googleUser != null;
  }
}
