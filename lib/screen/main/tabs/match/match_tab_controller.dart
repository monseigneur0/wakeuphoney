import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/features/oldmatch/match_model.dart';
import 'package:wakeuphoney/screen/auth/login_controller.dart';
import 'package:wakeuphoney/screen/main/tabs/match/match_tab_repository.dart';

final matchNumberProvider = StreamProvider<MatchModel>((ref) {
  return ref.watch(matchTabControllerProvider.notifier).getMatchNumber();
});

final futureMatchNumberProvider = FutureProvider<MatchModel>((ref) {
  return ref.watch(matchTabControllerProvider.notifier).getFutureMatchNumber();
});

final matchTabControllerProvider = AsyncNotifierProvider<MatchTabController, void>(() => MatchTabController());

class MatchTabController extends AsyncNotifier<void> {
  late final MatchTabRepository _repository;

  Logger logger = Logger();

  String get uid => ref.read(uidProvider);
  @override
  FutureOr<void> build() {
    _repository = ref.read(matchTabRepositoryProvider);
  }

  Stream<MatchModel> getMatchNumber() {
    //시간 지난 것들 삭제
    _repository.deleteMatchAfterAHour();
    logger.d(uid);
    //많이 생성된것들 삭제
    //가져오기//없으면 생성
    final Stream<MatchModel> getNumber = _repository.getMatchNumber(uid);

    return getNumber;
  }

  Future<MatchModel> getFutureMatchNumber() {
    //시간 지난 것들 삭제
    _repository.deleteMatchAfterAHour();
    logger.d(uid);
    //많이 생성된것들 삭제
    //가져오기//없으면 생성
    final getNumber = _repository.getFutureMatchNumber(uid);

    return getNumber;
  }

  Future<void> checkMatchProcess(String matchCode) {
    //매칭된 것들 삭제
    //매칭된 것들 가져오기
    //매칭된 것들이 없으면 생성
    int honeyCode = int.parse(matchCode);
    return _repository.checkMatchProcess(honeyCode, uid);
  }
}
