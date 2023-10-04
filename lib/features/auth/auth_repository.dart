import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../core/constants/firebase_constants.dart';
import '../../core/providers/firebase_providers.dart';
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

  User? get currentUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => currentUser != null;
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();
  var logger = Logger();

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleAuth == null) {
      return null;
    }
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    UserModel userModel;

    if (userCredential.additionalUserInfo!.isNewUser) {
      userModel = UserModel(
        displayName: userCredential.user!.displayName ?? "Please restart app",
        email: userCredential.user!.email ?? "noemail@hello.com",
        photoURL: userCredential.user!.photoURL ??
            "https://firebasestorage.googleapis.com/v0/b/wakeuphoneys2.appspot.com/o/images%2Fgoogleprofileimg.png?alt=media&token=76e62fad-11c3-4c66-ba8a-2400efbedb5a",
        uid: userCredential.user!.uid,
        couple: "",
        couples: [],
        creationTime: DateTime.now(),
        lastSignInTime: DateTime.now(),
        isLoggedIn: true,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid", userCredential.user!.uid);
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      return userCredential;
    } else if (userCredential.user!.uid.isNotEmpty) {
      await _users
          .doc(userCredential.user!.uid)
          .update({"lastSignInTime": DateTime.now()});
    }
    return userCredential;
  }

  Future<UserCredential> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();

      final UserCredential appleUserCredential =
          await _firebaseAuth.signInWithProvider(appleProvider);
      logger.d(
          "appleUserCredential UserName:${appleUserCredential.additionalUserInfo?.username}");

      UserModel userModel;

      if (appleUserCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          displayName:
              appleUserCredential.user!.displayName ?? "Please restart app",
          email: appleUserCredential.user!.email ?? "noemail@hello.com",
          photoURL: appleUserCredential.user!.photoURL ??
              "https://firebasestorage.googleapis.com/v0/b/wakeuphoneys2.appspot.com/o/images%2Fgoogleprofileimg.png?alt=media&token=76e62fad-11c3-4c66-ba8a-2400efbedb5a",
          uid: appleUserCredential.user!.uid,
          couple: "",
          couples: [],
          creationTime: DateTime.now(),
          lastSignInTime: DateTime.now(),
          isLoggedIn: true,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", appleUserCredential.user!.uid);
        await _users.doc(appleUserCredential.user!.uid).set(userModel.toMap());
        return appleUserCredential;
      } else if (appleUserCredential.user!.uid.isNotEmpty) {
        await _users
            .doc(appleUserCredential.user!.uid)
            .update({"lastSignInTime": DateTime.now()});
      }
      return appleUserCredential;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential> signInWithApple2() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.fullName,
          AppleIDAuthorizationScopes.email,
        ],
      );
      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      logger.d(userCredential);
      logger.d(userCredential.user!.displayName);
      UserModel userModel;
      logger.d(userCredential.additionalUserInfo!.profile);
      logger.d(userCredential.additionalUserInfo!.username);

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          displayName: userCredential.user!.displayName ?? "Please restart app",
          email: userCredential.user!.email ?? "noemail@hello.com",
          photoURL: userCredential.user!.photoURL ??
              "https://firebasestorage.googleapis.com/v0/b/wakeuphoneys2.appspot.com/o/images%2Fgoogleprofileimg.png?alt=media&token=76e62fad-11c3-4c66-ba8a-2400efbedb5a",
          uid: userCredential.user!.uid,
          couple: "",
          couples: [],
          creationTime: DateTime.now(),
          lastSignInTime: DateTime.now(),
          isLoggedIn: true,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", userCredential.user!.uid);
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        return userCredential;
      } else if (userCredential.user!.uid.isNotEmpty) {
        await _users
            .doc(userCredential.user!.uid)
            .update({"lastSignInTime": DateTime.now()});
      }
      return userCredential;
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

  void logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  void deleteUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        user.delete();
      }
    });
  }

  void brokeup(String uid) {
    _users.doc(uid).update({"couple": "", "couples": []});
  }
}
