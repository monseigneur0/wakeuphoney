import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeuphoney/features/match/match_repo.dart';

import '../../core/providers/firebase_providers.dart';
import '../../core/providers/providers.dart';
import '../profile/profile_controller.dart';
import 'match_model.dart';

final getMatchCodeProvider = StreamProvider<MatchModel>((ref) {
  return ref.watch(matchConrollerProvider.notifier).getMatchCode();
});
final getMatchCodeFutureProvider = FutureProvider<MatchModel>((ref) {
  return ref.watch(matchConrollerProvider.notifier).getOrCreateMatchCode();
});

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

  static const tenMinutes = 3600;
  int totalSeconds = tenMinutes;
  bool isRunning = false;
  bool onceClickedMatch3 = false;

  late Timer timer;

  String leftCodeTime() {
    return format(totalSeconds);
  }

  void onTick(Timer timer) {
    if (totalSeconds < 1) {
      totalSeconds = _ref.watch(leftSecondsMatch.notifier).state--;
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
  }

  void onPausePressed() {
    timer.cancel();
  }

  String format(int seconds) {
    if (_ref.watch(leftSecondsMatch) <= seconds) {
      seconds = _ref.watch(leftSecondsMatch);
    }

    var duration = Duration(seconds: seconds);
    // print("duration $duration");
    return duration.toString().split(".").first.substring(2, 7);
  }

  MatchModel createMatch() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    int inthoneycode = Random().nextInt(900000) + 100000;

    _matchRepository.matchStartProcess(uid, inthoneycode);
    final MatchModel match = MatchModel(
      uid: uid,
      time: DateTime.now(),
      vertifynumber: inthoneycode,
    );
    return match;
  }

  void matchProcess() async {
    print("matchProcess");
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    await _matchRepository.deleteMatches(uid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("startMatchingTime", DateTime.now().toString());
    int inthoneycode = Random().nextInt(900000) + 100000;
    await _matchRepository.matchStartProcess(uid, inthoneycode);
  }

  Future<MatchModel> getOrCreateMatchCode() async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    late final MatchModel old;
    try {
      MatchModel old = await _matchRepository.getMatchCodeFuture(uid);
      print("old $old");
      if (old.uid == uid) {}
    } catch (e) {
      int inthoneycode = Random().nextInt(900000) + 100000;
      _matchRepository.matchStartProcess(uid, inthoneycode);
      print("getOrCreateMatchCode Error $e");
    }

    return _matchRepository.getMatchCodeFuture(uid);
  }

  Stream<MatchModel> getMatchCode() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    int inthoneycode = Random().nextInt(900000) + 100000;
    // final MatchModel match =
    //     MatchModel(uid: uid, time: DateTime.now(), vertifynumber: inthoneycode);
    // _matchRepository.matchModelStartProcess(match);
    //이거 전부 컨트롤러로 만들어서 하나하나 다시 가져와서 만들어야겠네;;;;
    //있는지 없는지 판단 자기 uid 로 검사
    matchProcess();
    print("new code");
    return _matchRepository.getMatchCodeView(uid);
  }

  Stream<MatchModel> createMatchCode() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    int inthoneycode = Random().nextInt(900000) + 100000;
    // final MatchModel match =
    //     MatchModel(uid: uid, time: DateTime.now(), vertifynumber: inthoneycode);
    // _matchRepository.matchModelStartProcess(match);
    //이거 전부 컨트롤러로 만들어서 하나하나 다시 가져와서 만들어야겠네;;;;
    //있는지 없는지 판단 자기 uid 로 검사

    print("new code");
    return _matchRepository.getMatchCodeView(uid);
  }

  Stream<MatchModel> getMatchCodeView() {
    print("getMatchCodeView");
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    // String useruid = _ref.watch(userModelProvider)!.uid;
    // print(useruid);
    return _matchRepository.getMatchCodeView(uid);
    //_ref.watch(userProvider)!.uid is null, why?
  }

  Stream<MatchModel> checkMatchProcess(int honeyCode) {
    print("checkMatchProcess");
    Stream<MatchModel> matched = _matchRepository.checkMatchProcess(honeyCode);
    matched.asyncMap(
        (event) => _ref.watch(coupleIdProvider.notifier).state = event.uid);
    return matched;
  }

  void matchCoupleIdProcessDone(String coupleId) async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    await _matchRepository.deleteMatches(uid);
    if (uid == coupleId) {
      return null;
    }
    // await _matchRepository.matchCoupleIdProcessDone(
    //     uid,
    //     _ref.watch(getMatchedCoupleIdProvider(honeycode)).toString(),
    //     honeycode);
    // String coupleId = _ref.watch(coupleIdProvider.notifier).toString();
    // String coupleId = _ref.watch(checkMatchProcessProvider(honeycode)).whenData((value) => value.uid);
    await _matchRepository.matchCoupleIdProcessDone(uid, coupleId, 123);
  }

  MatchModel getCreateCode() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    int inthoneycode = Random().nextInt(900000) + 100000;

    _matchRepository.matchStartProcess(uid, inthoneycode);
    final MatchModel match = MatchModel(
      uid: uid,
      time: DateTime.now(),
      vertifynumber: inthoneycode,
    );
    return match;
  }
}
