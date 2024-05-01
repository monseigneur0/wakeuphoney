import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/features/oldauth/user_model.dart';
import 'package:wakeuphoney/screen/auth/login_repository.dart';
import 'package:wakeuphoney/screen/auth/login_tabscreen.dart';
import 'package:wakeuphoney/screen/main/main_tabscreen.dart';

final loginControllerProvider = StateNotifierProvider<LoginController, UserModel>((ref) {
  return LoginController(
    loginRepository: ref.watch(loginRepositoryProvider),
    ref: ref,
  );
});

class LoginController extends StateNotifier<UserModel> {
  final LoginRepository _loginRepository;
  final Ref ref;
  LoginController({required LoginRepository loginRepository, required this.ref})
      : _loginRepository = loginRepository,
        super(UserModel.empty());

  Logger logger = Logger();

  /// Whether user has signed in.
  bool get signedIn => _loginRepository.isLoggedIn;

  //email login
  Future<UserCredential?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    final userCredential = await _loginRepository.signInWithEmailAndPassword(email, password);
    if (userCredential == null) {
      showToast("로그인에 실패했습니다. 이메일 또는 비밀번호를 확인해주세요.");
      return null;
    }
    //existing user
    final user = userCredential.user;
    logger.d("user: $user");

    await setUserByNow(userCredential);

    if (context.mounted) {
      // context.go(MainTabsScreen.routeUrl);
      context.go(MainTabsScreen.routeUrl);
    }

    return userCredential;
  }

  //apple login
  void signInWithApple(BuildContext context) async {
    final userCredential = await _loginRepository.signInWithApple();
    if (userCredential == null) {
      return;
    }

    await setUserByNow(userCredential);

    if (context.mounted) {
      context.go("/maintabs");
    }
  }

  //google login
  void signInWithGoogle(BuildContext context) async {
    final userCredential = await _loginRepository.signInWithGoogle();
    if (userCredential == null) {
      return;
    }

    await setUserByNow(userCredential);

    if (context.mounted) {
      context.go("/maintabs");
    }
  }

  Future<void> setUserByNow(UserCredential userCredential) async {
    final userModelByNow = await _loginRepository.getUserById(userCredential.user!.uid);
    state = userModelByNow;
  }

  void setUserByUserModel(UserModel user) {
    state = user;
  }

  void signOut(BuildContext context) async {
    await _loginRepository.signOut();
    if (context.mounted) {
      context.go(LoginNewScreen.routeUrl);
    }
    state = UserModel.empty();
  }

//현재 이 앱은 notifiyListeners()를 사용하지 않고 있음 그냥 항상 이동해줘야함. 하지만 다시 돌아올 수는 없겠지
  void signJustOut(BuildContext context) async {
    await _loginRepository.signOut();
    // if (context.mounted) {
    //   context.go(LoginNewScreen.routeUrl);
    // }
    state = UserModel.empty();
  }

//stetesetaefw
  String? guard(BuildContext context, GoRouterState state) {
    final bool signedIn = _loginRepository.isLoggedIn;

    final bool signingIn = state.matchedLocation == '/logintabs';
    // logger.d("signedIn: $signedIn, signingIn: $signingIn");

    // Go to /signin if the user is not signed in
    if (!signedIn && !signingIn) {
      return '/logintabs';
    }
    // Go to /books if the user is signed in and tries to go to /signin.
    else if (signedIn && signingIn) {
      return '/';
    }

    // no redirect
    return null;
  }
}
// /// An inherited notifier to host [LoginAuth] for the subtree.
// class LoginAuthScope extends InheritedNotifier<LoginController> {
//   /// Creates a [LoginControllerScope].
//   const LoginAuthScope({
//     required LoginController super.notifier,
//     required super.child,
//     super.key,
//   });

//   /// Gets the [LoginController] above the context.
//   static LoginController of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<LoginAuthScope>()!.notifier!;
// }
