import 'package:AppSynergy_Chat_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userfromFirebase(User user) {
    return user != null ? UserModel(userId: user.uid) : null;
  }

  Future signInwithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User firebaseUser = result.user;
      return _userfromFirebase(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpwithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User firebaseUser = result.user;
      return _userfromFirebase(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
