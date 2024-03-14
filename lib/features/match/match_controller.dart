import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeuphoney/features/match/match_repo.dart';

import '../../core/providers/firebase_providers.dart';
import '../profile/profile_controller.dart';
import 'match_model.dart';

final getMatchCodeFutureProvider = FutureProvider<MatchModel>((ref) {
  return ref.watch(matchConrollerProvider.notifier).getOrCreateMatchCode();
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
  var logger = Logger();

  Future<MatchModel> getOrCreateMatchCode() async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    //일단 가져와 한시간 지난 애들 삭제랑 가져오기
    int inthoneycode = Random().nextInt(900000) + 100000;
    MatchModel? currentCode =
        await _matchRepository.getMatchCodeFuture(uid, inthoneycode);
    if (currentCode == null) {
      currentCode = MatchModel(
          uid: uid, time: DateTime.now(), vertifynumber: inthoneycode);
      _matchRepository.matchStartProcess(uid, inthoneycode);
    }
    return currentCode;
  }

  Stream<MatchModel> checkMatchProcess(int honeyCode) async* {
    try {
      logger.d("checkMatchProcess");
      Stream<MatchModel> matched =
          _matchRepository.checkMatchProcess(honeyCode);
      matched.asyncMap(
          (event) => _ref.watch(coupleIdProvider.notifier).state = event.uid);
      logger.d("matched.toString()${matched.toString()}");
      final coupleIdMatchModel = await matched.first;
      logger.d("coupleIdMatchModel : $coupleIdMatchModel");
      yield coupleIdMatchModel;
    } catch (e) {
      logger.d("checkMatchProcess error : $e");
    }
  }

  void matchCoupleIdProcessDone(String coupleId) async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    logger.d("await _matchRepository.deleteMatches(uid);");
    await _matchRepository.deleteMatches(uid);
    logger.d("await _matchRepository.deleteMatches(uid); @@@@@@@@");
    if (uid == coupleId) {
      print("wtf");
      return null;
    }
    logger.d("coupleID : $coupleId");
    var couple = await _matchRepository.getUser(coupleId);
    logger.d("couple@@@@@@@@@ : $couple");
    if (couple == null) {
      logger.d("couple is null");
      return null;
    }
    final analytics = _ref.watch(analyticsProvider);
    analytics.logEvent(name: 'match_success', parameters: {
      'uid': uid,
      'coupleId': coupleId,
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sharedCoupleUid', coupleId);

    // await _matchRepository.matchCoupleIdProcessDone(
    //     uid,
    //     _ref.watch(getMatchedCoupleIdProvider(honeycode)).toString(),
    //     honeycode);
    // String coupleId = _ref.watch(coupleIdProvider.notifier).toString();
    // String coupleId = _ref.watch(checkMatchProcessProvider(honeycode)).whenData((value) => value.uid);

    await _matchRepository.getUser(coupleId).then((value) async {
      if (value == null) {
        logger.d("_matchRepository.getUser(coupleId). value is null");
        return null;
      }
      logger.d("couple : $value");
      logger.d("couple : ${value.uid}");
      await _matchRepository.matchCoupleIdProcessDone(
          uid,
          auser!.displayName ?? "",
          auser.photoURL ?? "",
          coupleId,
          value.displayName,
          value.photoURL);

      await _matchRepository.addFriend(uid, auser.displayName ?? "",
          auser.photoURL ?? "", coupleId, value.displayName, value.photoURL);
    });
  }
}
