import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/match/match_repo.dart';

import '../../core/providers/firebase_providers.dart';
import '../profile/profile_controller.dart';
import 'match_model.dart';

final getMatchCodeViewProvider = StreamProvider<MatchModel>((ref) {
  return ref.watch(matchConrollerProvider.notifier).getMatchCodeView();
});

final checkMatchProcessProvider = StreamProvider.family((ref, int honeyCode) {
  return ref
      .watch(matchConrollerProvider.notifier)
      .checkMatchProcess(honeyCode);
});

final matchConrollerProvider =
    StateNotifierProvider<MatchController, bool>((ref) {
  final matchRepository = ref.watch(matchRepositoryProvider);
  return MatchController(matchRepository: matchRepository, ref: ref);
});

class MatchController extends StateNotifier<bool> {
  final MatchRepository _matchRepository;
  final Ref _ref;
  MatchController({
    required MatchRepository matchRepository,
    required Ref ref,
  })  : _matchRepository = matchRepository,
        _ref = ref,
        super(false);

  void matchProcess() async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    await _matchRepository.deleteMatches(uid);

    int inthoneycode = Random().nextInt(900000) + 100000;
    await _matchRepository.matchStartProcess(uid, inthoneycode);
  }

  Stream<MatchModel> getMatchCodeView() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    // String useruid = _ref.watch(userModelProvider)!.uid;
    // print(useruid);
    return _matchRepository.getMatchCodeView(uid);
    //_ref.watch(userProvider)!.uid is null, why?
  }

  Stream<MatchModel> checkMatchProcess(int honeyCode) {
    return _matchRepository.checkMatchProcess(honeyCode);
  }

  void matchCoupleIdProcessDone(int honeycode) async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    await _matchRepository.deleteMatches(uid);
    await _matchRepository.matchCoupleIdProcessDone(
        uid, _ref.watch(coupleIdProvider.notifier).toString(), honeycode);
  }
}
