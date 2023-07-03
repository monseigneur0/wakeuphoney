import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/auth/user_model.dart';
import 'package:wakeuphoney/features/profile/profile_repo.dart';

import 'match_model.dart';

final getUserProfileStreamProvider = StreamProvider<UserModel>((ref) {
  return ref.watch(profileControllerProvider.notifier).getUserProfileStream();
});

final getMatchProcessProvider = StreamProvider<MatchModel>((ref) {
  return ref.watch(profileControllerProvider.notifier).getMatchProcess();
});

final checkMatchProcessProvider = StreamProvider.family((ref, int honeyCode) {
  return ref
      .watch(profileControllerProvider.notifier)
      .checkMatchProcess(honeyCode);
});

final coupleIdProvider = StateProvider((ref) {
  return "coupleid";
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

  Stream<UserModel> getUserProfileStream() {
    String uid = _ref.watch(authProvider).currentUser!.uid;
    return _profileRepo.getUserProfileStream(uid);
  }

  void matchProcess() async {
    String uid = _ref.watch(authProvider).currentUser!.uid;

    int inthoneycode = Random().nextInt(900000) + 100000;
    await _profileRepo.matchStartProcess(uid, inthoneycode);
  }

  Stream<MatchModel> getMatchProcess() {
    String uid = _ref.watch(authProvider).currentUser!.uid;
    // String useruid = _ref.watch(userModelProvider)!.uid;
    // print(useruid);
    return _profileRepo.getMatchStartProcess(uid);
    //_ref.watch(userProvider)!.uid is null, why?
  }

  Stream<MatchModel> checkMatchProcess(int honeyCode) {
    return _profileRepo.checkMatchProcess(honeyCode);
  }

  void matchCoupleIdProcessDone(int honeycode) async {
    print("coupleid");
    print(_ref.watch(coupleIdProvider));
    await _profileRepo.matchCoupleIdProcessDone(
        _ref.watch(authProvider).currentUser!.uid,
        _ref.watch(coupleIdProvider),
        honeycode);
  }
}
