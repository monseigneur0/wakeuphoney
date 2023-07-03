import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/core/type_defs.dart';

import '../../core/constants/firebase_constants.dart';
import '../../practice_home_screen.dart';
import 'login_screen.dart';
import 'user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
      auth: ref.watch(authProvider),
      googleSignIn: ref.watch(googleSignInProvider),
      firestore: ref.watch(firestoreProvider),
    ));

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  AuthRepository({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = auth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      GoogleSignInAccount? user = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      GoogleSignInAuthentication? googleAuth = await user!.authentication;
      // Create a new credential
      var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

///////////////////////////////////////////////////////////////////////////////////////////

      _firebaseAuth.authStateChanges().listen(
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
              couple: "this is right",
              couples: [],
              creationTime: DateTime.now(),
              lastSignInTime: DateTime.now(),
              isLoggedIn: true,
            );

            _users.where("uid", isEqualTo: user.uid).get().then((event) {
              event.docs.isEmpty
                  ? _firestore
                      .collection("users")
                      .doc(user.uid)
                      .set(userModelNow.toMap())
                      .then((value) =>
                          print("documentSnapshot add with id : ${user.uid}"))
                  : _firestore
                      .collection("users")
                      .doc(event.docs.first.id)
                      .update({
                      "lastSignInTime": user.metadata.lastSignInTime
                    }).then(
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
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  FutureEither<UserModel> signInWithGoogleUser(BuildContext context) async {
    try {
      // Trigger the authentication flow
      GoogleSignInAccount? user = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      GoogleSignInAuthentication? googleAuth = await user!.authentication;
      // Create a new credential
      var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

///////////////////////////////////////////////////////////////////////////////////////////
      UserModel userModelNow = UserModel(
          displayName: "displayName",
          email: "email",
          photoURL: "photoURL",
          uid: "uid",
          couple: "couple",
          couples: ["couples"],
          creationTime: DateTime.now(),
          lastSignInTime: DateTime.now(),
          isLoggedIn: isLoggedIn);

      _firebaseAuth.authStateChanges().listen(
        (User? user) {
          if (user == null) {
            print('User is currently signed out!');
            context.goNamed(LoginHome.routeName);
          } else {
            print(user);
            userModelNow = UserModel(
              displayName: user.displayName ?? "no Name",
              email: user.email ?? "noemail@hello.com",
              photoURL: user.photoURL ?? "",
              uid: user.uid,
              couple: "",
              couples: [],
              creationTime: user.metadata.creationTime ?? DateTime.now(),
              lastSignInTime: user.metadata.lastSignInTime ?? DateTime.now(),
              isLoggedIn: true,
            );

            _firestore
                .collection("users")
                .where("uid", isEqualTo: user.uid)
                .get()
                .then((event) {
              event.docs.isEmpty
                  ? _firestore
                      .collection("users")
                      .doc(user.uid)
                      .set(userModelNow.toMap())
                      .then((value) {
                      print("documentSnapshot add with id : ${user.uid}");
                    })
                  : _firestore
                      .collection("users")
                      .doc(event.docs.first.id)
                      .update({
                      "lastSignInTime": user.metadata.lastSignInTime
                    }).then(
                      (value) => print(
                          "user already exists, don't write in db ${event.docs.first.id}"),
                      onError: (e) => print("Error getting document: $e"),
                    );
            });
            context.go(PracticeHome.routeURL);
          }
        },
      );

      return right(userModelNow);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential> signInWithApple(BuildContext context) async {
    try {
      final appleProvider = AppleAuthProvider();

      final UserCredential appleUserCredential =
          await _firebaseAuth.signInWithProvider(appleProvider);

      return appleUserCredential;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Future logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.disconnect();
  }
}
