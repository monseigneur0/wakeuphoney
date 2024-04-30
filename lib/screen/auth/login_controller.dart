import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/features/oldauth/user_model.dart';
import 'package:wakeuphoney/screen/auth/login_repository.dart';
import 'package:wakeuphoney/screen/auth/login_tabscreen.dart';
import 'package:wakeuphoney/screen/main/main_tabscreen.dart';

final loginControllerProvider = StateNotifierProvider<LoginController, UserModel>((ref) => LoginController(
      loginRepository: ref.watch(loginRepositoryProvider),
      ref: ref,
    ));

final loginStateProvider = StateProvider<bool>((ref) => ref.watch(loginRepositoryProvider).isLoggedIn);

class LoginController extends StateNotifier<UserModel> {
  final LoginRepository _loginRepository;
  final Ref ref;
  LoginController({required LoginRepository loginRepository, required this.ref})
      : _loginRepository = loginRepository,
        super(UserModel(
          displayName: '',
          email: '',
          photoURL: '',
          uid: '',
          couple: '',
          couples: [],
          coupleDisplayName: '',
          couplePhotoURL: '',
          creationTime: DateTime.now(),
          lastSignInTime: DateTime.now(),
          isLoggedIn: false,
          chatGPTMessageCount: 0,
          gender: 'male',
          birthDate: DateTime.now(),
          location: const GeoPoint(0, 0),
          wakeUpTime: DateTime.now(),
          coupleGender: '',
          coupleBirthDate: null,
          coupleLocation: null,
          coupleWakeUpTime: null,
        ));

  Logger logger = Logger();

  //email login
  Future<UserCredential?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    final userCredential = await _loginRepository.signInWithEmailAndPassword(email, password);
    if (userCredential == null) {
      showToast("로그인에 실패했습니다. 이메일 또는 비밀번호를 확인해주세요.");
    } else {
      //existing user
      final user = userCredential.user;
      logger.d("user: $user");

      final userState = ref.watch(loginStateProvider);
      logger.d("userState: $userState");

      if (context.mounted) {
        // context.go(MainTabsScreen.routeUrl);
        Nav.push(const MainTabsScreen());
      }
      return userCredential;
    }
    return null;
  }

  //apple login

  void signInWithApple(BuildContext context) async {
    final userCredential = await _loginRepository.signInWithApple();
    if (context.mounted) {
      context.go("/maintabs");
    }
  }

  //google login
  void signInWithGoogle(BuildContext context) async {
    final userCredential = await _loginRepository.signInWithGoogle();
    if (context.mounted) {
      context.go("/maintabs");
    }
  }

  void signOut() async {
    await _loginRepository.signOut();
    Nav.push(const LoginNewScreen());
    ref.watch(loginStateProvider.notifier).state = false;
  }
}
