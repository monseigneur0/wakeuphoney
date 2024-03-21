import 'dart:async';
import 'dart:convert';

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

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  User? get currentUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => currentUser != null;
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  var logger = Logger();

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    if (googleAuth == null) {
      return null;
    }
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    UserModel userModel;

    if (userCredential.additionalUserInfo!.isNewUser) {
      userModel = UserModel(
        displayName: userCredential.user!.displayName ?? "이름을 입력해주세요.",
        email: userCredential.user!.email ?? "noemail@hello.com",
        photoURL: userCredential.user!.photoURL ??
            "https://firebasestorage.googleapis.com/v0/b/wakeuphoneys2.appspot.com/o/images%2F2024-01-08%2019:23:12.693630?alt=media&token=643f9416-0203-4e75-869a-ea0240e14ca4",
        uid: userCredential.user!.uid,
        couple: "",
        couples: [],
        creationTime: DateTime.now(),
        lastSignInTime: DateTime.now(),
        isLoggedIn: true,
        chatGPTMessageCount: 0,
        gender: "male",
        birthDate: DateTime.now(),
        location: const GeoPoint(0, 0),
        wakeUpTime: DateTime.now(),
        coupleDisplayName: "",
        couplePhotoURL: "",
        coupleGender: "",
        coupleBirthDate: DateTime.now(),
        coupleLocation: const GeoPoint(0, 0),
        coupleWakeUpTime: DateTime.now(),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid", userCredential.user!.uid);
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      return userCredential;
    } else if (userCredential.user!.uid.isNotEmpty) {
      await _users.doc(userCredential.user!.uid).update({"lastSignInTime": DateTime.now()});
    }
    return userCredential;
  }

  Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.fullName,
          AppleIDAuthorizationScopes.email,
        ],
      );
      appleCredential.familyName;
      appleCredential.givenName;
      appleCredential.identityToken;
      logger.d("appleCredential $appleCredential");
      logger.d("appleCredential.givenName: ${appleCredential.givenName}");
      logger.d("appleCredential.identityToken: ${appleCredential.identityToken}");
      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      logger.d("oAuthCredential: $oAuthCredential");
      logger.d("oAuthCredential.rawNonce: ${oAuthCredential.rawNonce}");

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      logger.d("userCredential: $userCredential");
      logger.d("userCredential.user!.displayName: ${userCredential.user!.displayName}");
      UserModel userModel;
      logger.d("userCredential.additionalUserInfo!.profile: ${userCredential.additionalUserInfo!.profile}");
      logger.d("userCredential.additionalUserInfo!.username: ${userCredential.additionalUserInfo!.username}");

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          displayName: appleCredential.givenName ?? "닉네임",
          email: userCredential.user!.email ?? "noemail@hello.com",
          photoURL: userCredential.user!.photoURL ??
              "https://firebasestorage.googleapis.com/v0/b/wakeuphoneys2.appspot.com/o/images%2F2024-01-08%2019:23:12.693630?alt=media&token=643f9416-0203-4e75-869a-ea0240e14ca4",
          uid: userCredential.user!.uid,
          couple: "",
          couples: [],
          creationTime: DateTime.now(),
          lastSignInTime: DateTime.now(),
          isLoggedIn: true,
          chatGPTMessageCount: 0,
          gender: "male",
          birthDate: DateTime.now(),
          location: const GeoPoint(0, 0),
          wakeUpTime: DateTime.now(),
          coupleDisplayName: "",
          couplePhotoURL: "",
          coupleGender: "",
          coupleBirthDate: DateTime.now(),
          coupleLocation: const GeoPoint(0, 0),
          coupleWakeUpTime: DateTime.now(),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", userCredential.user!.uid);
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        return userCredential;
      } else if (userCredential.user!.uid.isNotEmpty) {
        await _users.doc(userCredential.user!.uid).update({"lastSignInTime": DateTime.now()});
      }
      return userCredential;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Future<UserModel> getFutureUserData(String uid) async {
    try {
      final me = await _users.doc(uid).get().then((event) {
        return UserModel.fromMap(event.data() as Map<String, dynamic>);
      });
      return me;
    } catch (e) {
      logger.e(e.toString());
    }
    throw Exception("Failed to get user data."); //이거 왜 함? 이미 try catch
  }

  //shared preference 에 user data 저장.
  saveUserData(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = user.toString();

    prefs.setString("uid", userString);
  }

  void logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    isLoggedIn;
    await _firestore.terminate();
    await _firestore.clearPersistence();
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
