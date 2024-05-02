import 'dart:async';
import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/screen/auth/login_controller.dart';
import 'package:wakeuphoney/screen/main/tabs/match/match_tab_repository.dart';

final matchNumberProvider = StreamProvider<String>((ref) {
  return ref.watch(matchTabControllerProvider.notifier).getMatchNumber();
});

final matchTabControllerProvider = AsyncNotifierProvider<MatchTabController, void>(() => MatchTabController());

class MatchTabController extends AsyncNotifier<void> {
  late final MatchTabRepository _repository;

  String get uid => ref.read(uidProvider);
  @override
  FutureOr<void> build() {
    _repository = ref.read(matchTabRepositoryProvider);
  }

  Stream<String> getMatchNumber() {
    //시간 지난 것들 삭제
    repository.deleteMatch();
    //가져오기
    final String  repository.getMatchNumber(uid);
    //없으면 생성
    int vertifyNumber = Random().nextInt(900000) + 100000;

    repository.createMatch(uid, vertifyNumber);
    return repository.getMatchNumber(uid);
  }
}
