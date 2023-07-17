import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/auth/auth_repository.dart';
import 'package:wakeuphoney/features/auth/login_screen.dart';
import 'package:wakeuphoney/features/auth/user_model.dart';

final userModelProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(authRepositoryProvider), ref: ref));

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void singInWithGoogle() async {
    final user = _authRepository.signInWithGoogle();
  }

  // void signInWithGoogleUser(BuildContext context) async {
  //   final user = await _authRepository
  //       .signInWithGoogleUser(context)
  //       .then((_) => _authRepository.loginWithGoogleDb(context))
  //       .then((value) => context.go(MatchScreen.routeURL));

  //   // user.fold(
  //   //     (l) => showSnackBar(context, l.message),
  //   //     (userModel) =>
  //   //         _ref.read(userModelProvider.notifier).update((state) => userModel));
  // }

  // void signInWithGoogle(BuildContext context) async {
  //   final user = await _authRepository.signInWithGoogle();

  //   // .then((value) => _authRepository.loginWithGoogleDb(context))
  //   // .then((value) => context.go(MatchScreen.routeURL));

  //   user.fold(
  //       (l) => context.go(LoginHome.routeURL),
  //       (userModel) =>
  //           _ref.read(userModelProvider.notifier).update((state) => userModel));
  // }

  // void signInWithGoogleEnd(BuildContext context) async {
  //   await _authRepository.signInWithGoogleEnd();

  //   // .then((value) => _authRepository.loginWithGoogleDb(context))
  //   // .then((value) => context.go(MatchScreen.routeURL));
  // }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout(BuildContext context) async {
    _authRepository.logout();
    context.go(LoginHome.routeURL);
  }
}
