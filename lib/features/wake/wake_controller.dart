import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/firebase_providers.dart';
import '../auth/auth_controller.dart';
import 'wake_model.dart';
import 'wake_repository.dart';

final getWakesListProvider = FutureProvider.autoDispose<List<WakeModel>>(
    (ref) => ref.watch(wakeControllerProvider.notifier).getWakesList());

final wakeControllerProvider = StateNotifierProvider<WakeController, bool>(
    (ref) => WakeController(
        wakeRepository: ref.watch(wakeRepositoryProvider), ref: ref));

class WakeController extends StateNotifier<bool> {
  final WakeRepository _wakeRepository;
  final Ref _ref;

  WakeController({required WakeRepository wakeRepository, required Ref ref})
      : _wakeRepository = wakeRepository,
        _ref = ref,
        super(false);
  Logger logger = Logger();

  createWake(DateTime wakeTime, String letter, String photoUrl, String voiceUrl,
      double volumn, bool vibrate) async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    final coupleUidFuture = _ref.watch(getFutureMyUserDataProvider).value;
    String? coupleUid = coupleUidFuture!.couple;

    WakeModel wakeModel = WakeModel(
        wakeUid: const Uuid().v4(),
        createdTime: DateTime.now(),
        modifiedTimes: DateTime.now(),
        alarmId: DateTime.now().millisecondsSinceEpoch % 100000,
        alarmTime: wakeTime,
        assetAudioPath: "",
        loopAudio: true,
        vibrate: vibrate,
        volume: volumn,
        fadeDuration: 0.1,
        notificationTitle: "알람이 울려요",
        notificationBody: "확인해보세요",
        enableNotificationOnKill: true,
        androidFullScreenIntent: true,
        isDeleted: false,
        isApproved: false,
        approveTime: null,
        senderUid: uid,
        wakeMessage: letter,
        wakePhoto: photoUrl,
        wakeAudio: voiceUrl,
        wakeVideo: "",
        isAnswered: false,
        reciverUid: coupleUid!,
        answerTime: null,
        answerMessage: "",
        answerPhoto: "",
        answerAudio: "",
        answerVideo: "");
    _wakeRepository.createWake(uid, wakeModel);
    _wakeRepository.createWake(coupleUid, wakeModel);
  }

  Future<List<WakeModel>> getWakesList() async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    //오늘 날짜 이전으로 받는사람이 나인것만, 보낸사람이 나인건 모두 보여주기.
    //날짜순 정렬하기
    return _wakeRepository.getWakesList(uid);
  }

  wakeDelete(String wakeUid) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    final coupleUidFuture = _ref.watch(getFutureMyUserDataProvider).value;
    String? coupleUid = coupleUidFuture!.couple;

    _wakeRepository.wakeDelete(uid, wakeUid);
    _wakeRepository.wakeDelete(coupleUid!, wakeUid);
  }
}
