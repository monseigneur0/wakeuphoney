import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/auth/auth_repository.dart';
import 'package:wakeuphoney/features/auth/login_screen.dart';
import 'package:wakeuphoney/features/auth/user_model.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(() => AuthController());

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});
final getMyUserDataProvider = StreamProvider(
    (ref) => ref.watch(authControllerProvider.notifier).getMyUserData());

final loginCheckProvider = StreamProvider(
    (ref) => ref.watch(authControllerProvider.notifier).authStateChange);

final getFutureMyUserDataProvider = FutureProvider<UserModel>(
    (ref) => ref.watch(authControllerProvider.notifier).getFutureMyUserData());

class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _authRepository;
  @override
  FutureOr<void> build() {
    _authRepository = ref.read(authRepositoryProvider);
  }

  Logger logger = Logger();

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _authRepository.signInWithGoogle(),
    );
    if (state.hasError) {
    } else {
      // final wow = await getFutureMyUserData();
      // if (wow == null) {
      //   if (context.mounted) {
      //     context.go("/match");
      //   }
      // } else if (wow.couple.isEmpty) {
      //   if (context.mounted) {
      //     context.go("/match");
      //   }
      // } else {
      //   if (context.mounted) {
      //     context.go("/main");
      //   }
      // }
      if (context.mounted) {
        context.go("/main");
      }
    }
    // _authRepository.signInWithGoogle().then((value) => value != null
    //     ? context.goNamed(MatchScreen.routeName)
    //     : context.goNamed(LoginHome.routeName));

    // context.goNamed(MatchScreen.routeName);
  }

  void signInWithApple(BuildContext context) async {
    await _authRepository.signInWithApple();
    if (state.hasError) {
    } else {
      if (context.mounted) {
        context.go("/main");
      }
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Stream<UserModel> getMyUserData() {
    User? auser = ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    return _authRepository.getUserData(uid);
  }

  Future<UserModel> getFutureMyUserData() {
    User? auser = ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    logger.d(uid);
    return _authRepository.getFutureUserData(uid);
  }

  void logout(BuildContext context) async {
    _authRepository.logout();
    context.go(LoginHome.routeURL);
  }

  void brokeup() {
    User? auser = ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    _authRepository.brokeup(uid);
    final coupleUidValue = ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple!
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";
    _authRepository.brokeup(coupleUid);
  }
}
