import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';

import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/tabs/match/match_model.dart';
import 'package:wakeuphoney/tabs/match/match_tab_repository.dart';

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

  Future<MatchModel> getFutureMatchNumber() {
    //시간 지난 것들 삭제
    _repository.deleteMatchAfterAHour();
    logger.d(uid);
    //많이 생성된것들 삭제
    //가져오기//없으면 생성
    final getNumber = _repository.getFutureMatchNumber(uid);

    return getNumber;
  }

  void checkMatchProcess(String matchCode) async {
    //text input
    int honeyCode = int.parse(matchCode);

    //check if exist
    final match = await _repository.checkMatchWithCode(honeyCode, uid);
    logger.d("match : $match");

    //성공하면 couple uid 기록, 화면 전환 필요.

    if (match == true) {
      showToast("Matching successful.".tr());
    }

    //실패하면 실패 메시지
    if (match == false) {
      logger.d("match : $match,  Future.value(null) : ${Future.value(null)}");
      showToast("Matching failed. Please try again.".tr());
    }

    return;
  }

  void breakUp() {
    logger.d("breakup $uid");
    _repository.breakUp(uid);
    final coupleUid = ref.read(userModelProvider)!.couple.toString();

    logger.d("breakup $coupleUid");
    _repository.breakUp(coupleUid);
    ref.read(friendUserModelProvider.notifier).state = null;
  }
}
