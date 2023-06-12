import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../practice_home_screen.dart';
import 'login_screen.dart';
import 'user_model.dart';

final googleSignInApiProbider =
    Provider<GoogleSignInApi>((reg) => GoogleSignInApi());

class GoogleSignInApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get user => _firebaseAuth.currentUser;
  bool get isLoggedIn => user != null;

  static final _googleSignIn = GoogleSignIn();

  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
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

///////////////////////////////////////////////////////////////////////////////////////////
    FirebaseFirestore db = FirebaseFirestore.instance;

    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          print('User is currently signed out!');
          context.goNamed(LoginHome.routeName);
        } else {
          print(user);
          UserModel userModelNow = UserModel(
            displayName: user.displayName ?? "no Name",
            email: user.email ?? "noemail@hello.com",
            photoURL: user.photoURL ?? "",
            uid: user.uid,
            couples: [],
            creationTime: user.metadata.creationTime ?? DateTime.now(),
            lastSignInTime: user.metadata.lastSignInTime ?? DateTime.now(),
            isLoggedIn: true,
          );

          db
              .collection("users")
              .where("uid", isEqualTo: user.uid)
              .get()
              .then((event) {
            event.docs.isEmpty
                ? db
                    .collection("users")
                    .doc(user.uid)
                    .set(userModelNow.toMap())
                    .then((value) =>
                        print("documentSnapshot add with id : ${user.uid}"))
                : db.collection("users").doc(event.docs.first.id).update(
                    {"lastSignInTime": user.metadata.lastSignInTime}).then(
                    (value) => print(
                        "user already exists, don't write in db ${event.docs.first.id}"),
                    onError: (e) => print("Error getting document: $e"),
                  );
          });
          context.go(PracticeHome.routeURL);
        }
      },
    );

    return userCredential;
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.disconnect();
  }
}
