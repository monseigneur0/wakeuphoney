import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wakeuphoney/auth/login_type.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/passwords.dart';

import '../common/providers/firebase_providers.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) => LoginRepository(
      firebaseAuth: ref.watch(authProvider),
      firestore: ref.watch(firestoreProvider),
      googleSignIn: ref.watch(googleSignInProvider),
    ));

class LoginRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  LoginRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  Logger logger = Logger();

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  User? get currentUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => currentUser != null;

  //email login
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      logger.d(userCredential);
      //when no user found
      if (userCredential.user!.email != email) {
        showToast("로그인에 실패했습니다. 이메일 또는 비밀번호를 확인해주세요.");
        return null;
      }

      //new user ?

      //existing user
      final user = userCredential.user;
      await _users.doc(user!.uid).update({
        "isLoggedIn": true,
        "lastSignInTime": DateTime.now(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      emailSignInErrorHandling(e);
    }
    return null;
  }

  //apple login
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider("apple.com");
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      //new user
      if (userCredential.additionalUserInfo!.isNewUser) {
        final user = userCredential.user;
        await createNewUser(user, 'apple');

        return userCredential;
      }

      //existing user
      final user = userCredential.user;
      await _users.doc(user!.uid).update({
        "isLoggedIn": true,
        "lastSignInTime": DateTime.now(),
      });

      return userCredential;
    } on FirebaseException catch (e) {
      snsLoginExceptionHandling(e);
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
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

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      //new user
      if (userCredential.additionalUserInfo!.isNewUser) {
        final user = userCredential.user;
        await createNewUser(user, 'google');

        return userCredential;
      }

      //existing user
      final user = userCredential.user;
      await _users.doc(user!.uid).update({
        "isLoggedIn": true,
        "lastSignInTime": DateTime.now(),
      });

      return userCredential;
    } on FirebaseException catch (e) {
      snsLoginExceptionHandling(e);
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  signInWithManager() async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: Passwords.managerEmail,
      password: Passwords.managerpassword,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> createNewUser(User? user, String loginType) async {
    final newUser = UserModel(
      displayName: user!.displayName ?? "",
      email: user.email ?? "",
      photoURL: user.photoURL ?? "",
      uid: user.uid,
      loginType: loginType,
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
    await _users.doc(user.uid).set(
          newUser.toMap(),
        );
  }

  String getUidByFirebaseAuth() {
    final user = _firebaseAuth.currentUser;
    return user!.uid;
  }

  Future<UserModel> getUserById(String uid) async {
    final user = await _users.doc(uid).get();
    return UserModel.fromMap(user.data() as Map<String, dynamic>);
  }

  Stream<UserModel> getUserStreamById(String uid) {
    final user = _users.doc(uid).snapshots();
    return user.map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void snsLoginExceptionHandling(FirebaseException e) {
    switch (e.code) {
      case 'credential-already-in-use':
        logger.e("The credential is already in use by another account.");
        showToast("The credential is already in use by another account.");
        break;
      case 'operation-not-supported-in-this-environment':
        logger.e("This operation is not supported in this environment.");
        showToast("This operation is not supported in this environment.");
        break;
      case 'popup-closed-by-user':
        logger.e("The user closed the popup before completing the sign-in flow.");
        showToast("The user closed the popup before completing the sign-in flow.");
        break;
      case 'keychain-error':
        logger.e("An error occurred when accessing the keychain.");
        showToast("An error occurred when accessing the keychain.");
        break;
      case 'network-error':
        logger.e("A network error occurred.");
        showToast("A network error occurred.");
        break;
      case 'unknown':
        logger.e("An unknown error occurred.");
        showToast("An unknown error occurred.");
        break;

      default:
        logger.e(e.code);
        showToast(e.code);
    }
  }

  void emailSignInErrorHandling(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        logger.e("등록되지 않은 이메일입니다.");
        showToast("등록되지 않은 이메일입니다.");
        //analytics
        break;
      case 'wrong-password':
        logger.e("비밀번호가 틀렸습니다.");
        showToast("비밀번호가 틀렸습니다.");
        break;
      case 'invalid-email':
        logger.e("유효하지 않은 이메일입니다.");
        showToast("유효하지 않은 이메일입니다.");
        break;
      case 'user-disabled':
        logger.e("사용이 비활성화된 계정입니다.");
        showToast("사용이 비활성화된 계정입니다.");
        break;
      case 'too-many-requests':
        logger.e("요청이 너무 많습니다. 나중에 다시 시도해주세요.");
        showToast("요청이 너무 많습니다. 나중에 다시 시도해주세요.");
        break;
      case 'operation-not-allowed':
        logger.e("이메일 및 비밀번호 인증이 비활성화되었습니다.");
        showToast("이메일 및 비밀번호 인증이 비활성화되었습니다.");
        break;
      default:
        logger.e(e.code);
        showToast(e.code);
    }
  }

  Future<void> updateFcmToken(String? token) async {
    if (token == null) {
      return;
    }
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }
    // await _users.doc(user.uid).update({
    //   "fcmToken": token,
    // });
  }

  updateProfileImage(String imageUrl) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }
    await _users.doc(user.uid).update({
      "photoURL": imageUrl,
    });
  }

  updateGender(String gender) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }
    await _users.doc(user.uid).update({
      "gender": gender,
    });
  }

  updateBirthday(DateTime birthDate) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }
    await _users.doc(user.uid).update({
      "birthDate": birthDate,
    });
  }

  deleteUser(String uid) async {
    //delete in firebase auth
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }
    await user.delete(); //error
    await _users.doc(uid).delete();
  }

  updateGPTcount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }
    //all users update chatGPTMessageCount to 10

    List<String> userUids = getUserList();
    for (String uid in userUids) {
      await _users.doc(uid).update({
        "chatGPTMessageCount": 10,
      });
    }
  }

  List<String> getUserList() {
    List<String> userlist = [];
    _users.get().then((value) {
      for (var docSnapshot in value.docs) {
        userlist.add(docSnapshot.id);
      }
    });
    return userlist;
  }

  updateDisplayName(String displayName) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return;
    }
    await _users.doc(user.uid).update({
      "displayName": displayName,
    });
  }
}
