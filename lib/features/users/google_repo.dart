import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'user_model.dart';

final googleSignInApiProbider =
    Provider<GoogleSignInApi>((reg) => GoogleSignInApi());

class GoogleSignInApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get user => _firebaseAuth.currentUser;
  bool get isLoggedIn => user != null;

  static final _googleSignIn = GoogleSignIn();
  Future<UserCredential?> loginWithGoogle() async {
    // Trigger the authentication flow
    GoogleSignInAccount? user = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    GoogleSignInAuthentication? googleAuth = await user!.authentication;
    // Create a new credential
    var credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    UserModel userModel = UserModel(
        displayName: userCredential.user!.displayName ?? 'No Name',
        email: userCredential.user!.email ?? 'noemail@hello.com',
        photoURL: userCredential.user!.photoURL ?? 'no image',
        uid: userCredential.user?.uid ?? '1234',
        creationTime:
            userCredential.user?.metadata.creationTime ?? DateTime.now(),
        lastSignInTime:
            userCredential.user?.metadata.lastSignInTime ?? DateTime.now(),
        isLoggedIn: true);

    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print(user.uid);
          print(user);
          print('db user check before write');
          final userdb = <String, dynamic>{
            "displayName": user.displayName,
            "email": user.email,
            "photoURL": user.photoURL,
            "uid": user.uid,
            "creationTime": user.metadata.creationTime,
            "lastSignInTime": user.metadata.lastSignInTime,
            "isLoggedIn": true,
          };
          print(userdb);
        }
      },
    );
    return userCredential;
  }

  static Future logout() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.disconnect();
  }
}
