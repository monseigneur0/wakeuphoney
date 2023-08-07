import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {}
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
        displayName: userCredential.user!.displayName ?? "no Name",
        email: userCredential.user!.email ?? "noemail@hello.com",
        photoURL: userCredential.user!.photoURL ?? "",
        uid: userCredential.user!.uid,
        couple: "this is right",
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
    return null;
  }

//   Future<UserCredential?> loginWithGoogle(BuildContext context) async {
//     try {
//       // Trigger the authentication flow
//       GoogleSignInAccount? user = await _googleSignIn.signIn();
//       if (user == null) throw Exception("Not logged in");

//       // Obtain the auth details from the request
//       GoogleSignInAuthentication? googleAuth = await user.authentication;
//       // Create a new credential
//       var credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       // Once signed in, return the UserCredential
//       final UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       return userCredential;
//     } on FirebaseException catch (e) {
//       throw e.message!;
//     } catch (e) {
//       throw e.toString();
//     }
//   }

//   void loginWithGoogleDb(BuildContext context) {
//     _firebaseAuth.authStateChanges().listen(
//       (User? user) {
//         if (user == null) {
//           // print('User is currently signed out!');
//           context.goNamed(LoginHome.routeName);
//         } else {
//           // print(user);
//           UserModel userModelNow = UserModel(
//             displayName: user.displayName ?? "no Name",
//             email: user.email ?? "noemail@hello.com",
//             photoURL: user.photoURL ?? "",
//             uid: user.uid,
//             couple: "this is right",
//             couples: [],
//             creationTime: DateTime.now(),
//             lastSignInTime: DateTime.now(),
//             isLoggedIn: true,
//           );

//           _users.where("uid", isEqualTo: user.uid).get().then((event) {
//             event.docs.isEmpty
//                 ? _firestore
//                     .collection("users")
//                     .doc(user.uid)
//                     .set(userModelNow.toMap())
//                     .then(
//                       (value) =>
//                           print("documentSnapshot add with id : ${user.uid}"),
//                     )
//                 : _firestore
//                     .collection("users")
//                     .doc(event.docs.first.id)
//                     .update(
//                         {"lastSignInTime": user.metadata.lastSignInTime}).then(
//                     (value) => print(
//                         "user already exists, don't write in db ${event.docs.first.id}"),
//                     onError: (e) => print("Error getting document: $e"),
//                   );
//           });
//           context.go(MatchScreen.routeURL);
//         }
//       },
//     );
//   }

//   Future<UserCredential?> signInWithGoogleEnd() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         return null;
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );

//       // Once signed in, return the UserCredential
//       return await FirebaseAuth.instance.signInWithCredential(credential);
//     } on FirebaseAuthException catch (e) {
//       print(e.message);
//     }
//     return null;
//   }

//   static Future<User?> signInWithGoogleWow(
//       {required BuildContext context}) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;

//     final GoogleSignIn googleSignIn = GoogleSignIn();

//     final GoogleSignInAccount? googleSignInAccount =
//         await googleSignIn.signIn();

//     if (googleSignInAccount != null) {
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       try {
//         final UserCredential userCredential =
//             await auth.signInWithCredential(credential);

//         user = userCredential.user;
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'account-exists-with-different-credential') {
//           // handle the error here
//         } else if (e.code == 'invalid-credential') {
//           // handle the error here
//         }
//       } catch (e) {
//         // handle the error here
//       }
//     }

//     return user;
//   }

//   static Future<FirebaseApp> initializeFirebase({
//     required BuildContext context,
//   }) async {
//     FirebaseApp firebaseApp = await Firebase.initializeApp();

//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => const LoginHome(),
//         ),
//       );
//     }

//     return firebaseApp;
//   }

//   FutureEither<UserModel> signInWithGoogle() async {
//     try {
//       UserCredential userCredential;

//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       final googleAuth = await googleUser?.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );

//       userCredential = await _firebaseAuth.signInWithCredential(credential);

//       UserModel userModel;

//       if (userCredential.additionalUserInfo!.isNewUser) {
//         userModel = UserModel(
//           displayName: userCredential.user!.displayName ?? "no Name",
//           email: userCredential.user!.email ?? "noemail@hello.com",
//           photoURL: userCredential.user!.photoURL ?? "",
//           uid: userCredential.user!.uid,
//           couple: "",
//           couples: [],
//           creationTime:
//               userCredential.user!.metadata.creationTime ?? DateTime.now(),
//           lastSignInTime:
//               userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
//           isLoggedIn: true,
//         );
//         await _users.doc(userCredential.user!.uid).set(userModel.toMap());
//       } else {
//         userModel = await getUserData(userCredential.user!.uid).first;
//       }
//       return right(userModel);
//     } on FirebaseException catch (e) {
//       throw e.message!;
//     } catch (e) {
//       return left(Failure(e.toString()));
//     }
//   }

//   FutureEither<UserModel> signInWithGoogleUser(BuildContext context) async {
//     try {
//       // Trigger the authentication flow
//       GoogleSignInAccount? user = await _googleSignIn.signIn();

//       // Obtain the auth details from the request
//       GoogleSignInAuthentication? googleAuth = await user?.authentication;
//       // Create a new credential
//       var credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//       // Once signed in, return the UserCredential
//       final UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

// ///////////////////////////////////////////////////////////////////////////////////////////
//       UserModel userModelNow = UserModel(
//           displayName: "displayName",
//           email: "email",
//           photoURL: "photoURL",
//           uid: "uid",
//           couple: "couple",
//           couples: ["couples"],
//           creationTime: DateTime.now(),
//           lastSignInTime: DateTime.now(),
//           isLoggedIn: isLoggedIn);

//       UserModel userModel;

//       if (userCredential.additionalUserInfo!.isNewUser) {
//         userModel = UserModel(
//           displayName: userCredential.user!.displayName ?? "no Name",
//           email: userCredential.user!.email ?? "noemail@hello.com",
//           photoURL: userCredential.user!.photoURL ?? "",
//           uid: userCredential.user!.uid,
//           couple: "",
//           couples: [],
//           creationTime:
//               userCredential.user!.metadata.creationTime ?? DateTime.now(),
//           lastSignInTime:
//               userCredential.user!.metadata.lastSignInTime ?? DateTime.now(),
//           isLoggedIn: true,
//         );
//         await _users.doc(userCredential.user!.uid).set(userModel.toMap());
//       } else {
//         userModel = await getUserData(userCredential.user!.uid).first;
//       }

//       _firebaseAuth.authStateChanges().listen(
//         (User? user) {
//           if (user == null) {
//             print('User is currently signed out!');
//             context.goNamed(LoginHome.routeName);
//           } else {
//             print(user);
//             userModelNow = UserModel(
//               displayName: user.displayName ?? "no Name",
//               email: user.email ?? "noemail@hello.com",
//               photoURL: user.photoURL ?? "",
//               uid: user.uid,
//               couple: "",
//               couples: [],
//               creationTime: user.metadata.creationTime ?? DateTime.now(),
//               lastSignInTime: user.metadata.lastSignInTime ?? DateTime.now(),
//               isLoggedIn: true,
//             );

//             _firestore
//                 .collection("users")
//                 .where("uid", isEqualTo: user.uid)
//                 .get()
//                 .then((event) {
//               event.docs.isEmpty
//                   ? _firestore
//                       .collection("users")
//                       .doc(user.uid)
//                       .set(userModelNow.toMap())
//                       .then((value) {
//                       print("documentSnapshot add with id : ${user.uid}");
//                     })
//                   : _firestore
//                       .collection("users")
//                       .doc(event.docs.first.id)
//                       .update({
//                       "lastSignInTime": user.metadata.lastSignInTime
//                     }).then(
//                       (value) => print(
//                           "user already exists, don't write in db ${event.docs.first.id}"),
//                       onError: (e) => print("Error getting document: $e"),
//                     );
//             });
//             context.go(PracticeHome.routeURL);
//           }
//         },
//       );

//       return right(userModelNow);
//     } on FirebaseException catch (e) {
//       throw e.message!;
//     } catch (e) {
//       throw e.toString();
//     }
//   }

  Future<UserCredential> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();

      final UserCredential appleUserCredential =
          await _firebaseAuth.signInWithProvider(appleProvider);

      UserModel userModel;

      if (appleUserCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          displayName: appleUserCredential.user!.displayName ?? "no Name",
          email: appleUserCredential.user!.email ?? "noemail@hello.com",
          photoURL: appleUserCredential.user!.photoURL ?? "",
          uid: appleUserCredential.user!.uid,
          couple: "this is right",
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

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  void deleteUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        user.delete();
      }
    });
  }
}
