import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:wakeuphoney/features/auth/user_model.dart';
import 'package:wakeuphoney/features/profile/profile_repo.dart';

import '../../core/providers/firebase_providers.dart';
import '../auth/auth_controller.dart';

final getUserProfileStreamProvider = StreamProvider<UserModel>((ref) {
  return ref.watch(profileControllerProvider.notifier).getUserProfileStream();
});

final getMyUserInfoProvider = FutureProvider(
    (ref) => ref.watch(profileControllerProvider.notifier).getMyUserInfo());

final getUserProfileStreamByIdProvider =
    StreamProvider.family((ref, String uid) {
  return ref
      .watch(profileControllerProvider.notifier)
      .getUserProfileStreamById(uid);
});

final getCoupleProfileStreamProvider = StreamProvider((ref) {
  return ref.watch(profileControllerProvider.notifier).getCoupleProfileStream();
});

////////////////////////////////////////////////////
final coupleIdProvider = StateProvider((ref) {
  return ref.watch(profileControllerProvider.notifier).getCoupleUidWow();
});

final coupleIdStateProvider = StateProvider<String>((ref) {
  String gogogo = ref.watch(profileControllerProvider.notifier).getCoupleUid();
  return gogogo;
});

final coupleIdFutureProvider = FutureProvider((ref) {
  var gogogo =
      ref.watch(profileControllerProvider.notifier).getCoupleUiFuture();
  return gogogo;
});

final StateNotifierProvider<ProfileController, bool> profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return ProfileController(profileRepo: profileRepo, ref: ref);
});

class ProfileController extends StateNotifier<bool> {
  final ProfileRepo _profileRepo;
  final Ref _ref;
  ProfileController({
    required ProfileRepo profileRepo,
    required Ref ref,
  })  : _profileRepo = profileRepo,
        _ref = ref,
        super(false);
  var logger = Logger();

  Stream<UserModel> getUserProfileStream() {
    logger.d("getUserProfileStream");
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    logger.d("uid : $uid");
    return _profileRepo.getUserProfileStream(uid);
  }

  Stream<UserModel> getUserProfileStreamById(String uid) {
    return _profileRepo.getUserProfileStream(uid);
  }

  Stream<UserModel> getCoupleProfileStream() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";

    return _profileRepo.getUserProfileStream(coupleUid);
  }

  String getCoupleUid() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    String ghghgh = _profileRepo.getCoupleUid(uid);

    return ghghgh;
  }

  getCoupleUiFuture() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    var ghghgh = _profileRepo.getCoupleUidFuture(uid);
    return ghghgh;
  }

  getCoupleUidWow() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    return _ref.watch(getUserDataProvider(uid)).when(
        data: (data) {
          _ref.watch(coupleIdProvider.notifier).state = data.couple;
          return data.couple;
        },
        error: (error, stackTrace) {
          return "error getUserDataProvider ${_ref.watch(coupleIdProvider)}";
        },
        loading: () =>
            "loading getUserDataProvider ${_ref.watch(coupleIdProvider)}");
  }

  void createFeedback(contents, imageUrl) async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    await _profileRepo.createFeedback(uid, contents, imageUrl);
  }

  Future<UserModel> getMyUserInfo() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    return _profileRepo.getUserInfo(uid);
  }

  updateProfileImage(String url) async {
    User? user = _ref.watch(authProvider).currentUser;
    String uid;
    user != null ? uid = user.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";
    await _profileRepo.updateProfileImage(uid, url);
    await _profileRepo.updateProfileImage(coupleUid, url);
  }
}
