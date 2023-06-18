import 'package:firebase_auth/firebase_auth.dart';
import 'package:wakeuphoney/chatapp/helper/helper_function.dart';
import 'package:wakeuphoney/chatapp/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future registerUserWithEmailandPassword(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      await DatabaseService(uid: user.uid).savingUserdData(fullName, email);
      return true;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: $e");
      return e.message;
    }
  }

  //signout
  Future signout() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");

      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
