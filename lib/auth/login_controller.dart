import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/auth/login_repository.dart';
import 'package:wakeuphoney/auth/login_tabscreen.dart';
import 'package:wakeuphoney/tabs/main_tabscreen.dart';

final getUserByUidProvider = FutureProvider.family<UserModel, String>((ref, uid) {
  return ref.watch(loginRepositoryProvider).getUserById(uid);
});

final getUserFutureProvider = FutureProvider<UserModel>((ref) async {
  ref.watch(loginRepositoryProvider).currentUser;
  // ref.read(friendUserModelProvider.notifier).state = ref.read(getUserByUidProvider('couple'));
  final user = await ref.read(loginControllerProvider.notifier).getUser();
  if (user.couples!.isNotEmpty) {
    ref.read(friendUserModelProvider.notifier).state = await ref.watch(loginRepositoryProvider).getUserById(user.couples!.first);
  }
  ref.watch(loginControllerProvider);
  return user;
});

final getUserStreamProvider = StreamProvider<UserModel>((ref) {
  ref.watch(friendUserModelProvider);
  return ref.watch(loginControllerProvider.notifier).getUserStream();
});

final uidProvider = Provider<String>((ref) {
  return ref.watch(loginRepositoryProvider).currentUser!.uid;
});

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
      showToast('loginFail'.tr());
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
      context.go("/main");
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
      context.go("/main");
    }
  }

  void signInWithManager(BuildContext context) async {
    final userCredential = await _loginRepository.signInWithManager();
    if (userCredential == null) {
      return;
    }

    await setUserByNow(userCredential);

    if (context.mounted) {
      context.go("/main");
    }
  }

  ///앱 설치 이후 로그아웃 상태. stream에 유저 들고 있지 않음. uid 도 없어
  ///first login. uid 생성
  ///main 진입.
  ///main에는 항상 uid 들고 있어야해. main initialize 할 때 가져오자.main screen을 이 위에 그리자.
  ///바로 future, stream. 둘 다 가져와서 사용.
  ///stream에 유저 들고 있음. uid 도 있어
  ///app open after first login
  ///app logged in. stream에도 uid 있어. uid는 어디서 가져와야할거아니야. 로컬shared, firestore. future로 가져와있는거 그냥 계속 사용하면 안되나.
  ///second login

  Future<UserModel> getUser() async {
    if (_loginRepository.currentUser == null) {
      return UserModel.empty();
    }
    final uid = _loginRepository.currentUser!.uid;
    final userModel = await _loginRepository.getUserById(uid);
    ref.read(userModelProvider.notifier).state = userModel;
    ref.read(loginControllerProvider.notifier).state = userModel;
    return userModel;
  }

  Stream<UserModel> getUserStream() {
    final uid = _loginRepository.currentUser!.uid;
    final userModel = _loginRepository.getUserStreamById(uid);
    return userModel;
  }

  Future<void> setUserByNow(UserCredential userCredential) async {
    final userModelByNow = await _loginRepository.getUserById(userCredential.user!.uid);
    state = userModelByNow;
    ref.read(userModelProvider.notifier).state = userModelByNow;
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

  void updateFcmToken(String token) {
    state = state.copyWith(fcmToken: token);
    _loginRepository.updateFcmToken(token);
  }

//현재 이 앱은 notifiyListeners()를 사용하지 않고 있음 그냥 항상 이동해줘야함. 하지만 다시 돌아올 수는 없겠지 작동여부확인필요
  void signJustOut(BuildContext context) async {
    await _loginRepository.signOut();
    // if (context.mounted) {
    //   context.go(LoginNewScreen.routeUrl);
    // }
    state = UserModel.empty();
  }

//stete set aefw작동여부확인필요
  String? guard(BuildContext context, GoRouterState state) {
    final bool signedIn = _loginRepository.isLoggedIn;

    final bool signingIn = state.matchedLocation == '/logintabs';
    // logger.d("signedIn: $signedIn, signingIn: $signingIn");

    // Go to /signin if the user is not signed in
    if (!signedIn && !signingIn) {
      return '/loginonboardnewscreen';
    }
    // Go to /books if the user is signed in and tries to go to /signin.
    else if (signedIn && signingIn) {
      return '/';
    }

    // no redirect
    return null;
  }

  void updateProfileImage(String imageUrl) {
    _loginRepository.updateProfileImage(imageUrl);
    ref.read(userModelProvider.notifier).state = state.copyWith(photoURL: imageUrl);
  }

  void updateGender(int gender) {
    if (gender == 1) {
      _loginRepository.updateGender('male');
    }
    if (gender == 2) {
      _loginRepository.updateGender('female');
    }
  }

  void updateBirthday(DateTime birthDate) {
    _loginRepository.updateBirthday(birthDate);
  }

  void deleteUser() {
    final uid = _loginRepository.currentUser!.uid;

    _loginRepository.deleteUser(uid);
  }

  void updateGPTcount() {
    _loginRepository.updateGPTcount();
  }

  void updateDisplayName(String displayName) {
    _loginRepository.updateDisplayName(displayName);
    ref.read(userModelProvider.notifier).state = state.copyWith(displayName: displayName);
  }
}
