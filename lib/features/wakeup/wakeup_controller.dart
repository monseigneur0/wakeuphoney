import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/firebase_providers.dart';
import '../auth/auth_controller.dart';
import 'wakeup_model.dart';
import 'wakeup_repository.dart';

final wakeUpControllerProvider = StateNotifierProvider<WakeUpController, bool>(
    (ref) => WakeUpController(
        wakeUpRepository: ref.watch(wakeUpRepositoryProvider), ref: ref));

final getWakeUpLettersListProvider = StreamProvider(
    (ref) => ref.watch(wakeUpControllerProvider.notifier).getLettersList());

final getALetterforResponseProvider = FutureProvider.autoDispose<WakeUpModel>(
    (ref) => ref
        .watch(wakeUpControllerProvider.notifier)
        .getALetterforResponse(ref.watch(authProvider).currentUser!.uid));

final getTomorrowWakeUpMeProvider = FutureProvider.autoDispose<WakeUpModel>(
    (ref) => ref
        .watch(wakeUpControllerProvider.notifier)
        .getTomorrowWakeUpMeProvider());
final getTomorrowWakeUpYouProvider = FutureProvider.autoDispose<WakeUpModel>(
    (ref) => ref
        .watch(wakeUpControllerProvider.notifier)
        .getTomorrowWakeUpYouProvider());

class WakeUpController extends StateNotifier<bool> {
  final WakeUpRepository _wakeUpRepository;
  final Ref _ref;

  WakeUpController(
      {required WakeUpRepository wakeUpRepository, required Ref ref})
      : _wakeUpRepository = wakeUpRepository,
        _ref = ref,
        super(false);
  Logger logger = Logger();

  createWakeUp(DateTime wakeUpTime, String letter, String photoUrl,
      double volumn, bool vibrate) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    logger.d(uid);
    final coupleUidFuture = _ref.watch(getFutureMyUserDataProvider).value;
    String? coupleUid = coupleUidFuture!.couple;
    logger.d(coupleUid);
    WakeUpModel wakeUpModel = WakeUpModel(
        wakeUpUid: const Uuid().v4(),
        createdTime: DateTime.now(),
        modifiedTimes: DateTime.now(),
        alarmId: DateTime.now().millisecondsSinceEpoch % 100000,
        wakeTime: wakeUpTime,
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
        senderUid: uid,
        letter: letter,
        letterPhoto: photoUrl,
        letterAudio: "",
        letterVideo: "",
        reciverUid: coupleUid!,
        answer: "",
        answerPhoto: "",
        answerAudio: "",
        answerVideo: "");
    _wakeUpRepository.createWakeUp(uid, wakeUpModel);
    _wakeUpRepository.createWakeUp(coupleUid, wakeUpModel);
  }

  Stream<List<WakeUpModel>> getLettersList() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    //오늘 날짜 이전으로 받는사람이 나인것만, 보낸사람이 나인건 모두 보여주기.
    //날짜순 정렬하기
    return _wakeUpRepository.getLettersList(uid);
  }

  letterEdit(String letterId, String message) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple!
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";
    if (coupleUid == "PyY5skHRgPJP0CMgI2Qp") logger.d("noooooooo $coupleUid");

    _wakeUpRepository.letterEditMessage(uid, letterId, message);
    _wakeUpRepository.letterEditMessage(coupleUid, letterId, message);
  }

  letterDelete(String letterId) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidFuture = _ref.watch(getFutureMyUserDataProvider);

    coupleUidFuture.whenData((value) {
      String coupleUid = value!.couple!;

      _wakeUpRepository.letterDeleteMessage(uid, letterId);
      _wakeUpRepository.letterDeleteMessage(coupleUid, letterId);
    });
  }

  Future<WakeUpModel> getALetterforResponse(String uid) {
    return _wakeUpRepository.getALetterforResponse(uid);
  }

  createResponseLetter(
      String wakeUpUid, String responseLetter, String imageUrl) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple!
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";
    if (coupleUid == "PyY5skHRgPJP0CMgI2Qp") logger.d("noooooooo $coupleUid");

    _wakeUpRepository.createResponseLetter(
        uid, wakeUpUid, responseLetter, imageUrl);
    _wakeUpRepository.createResponseLetter(
        coupleUid, wakeUpUid, responseLetter, imageUrl);
  }

  Future<WakeUpModel> getTomorrowWakeUpYouProvider() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    return _wakeUpRepository.getTomorrowWakeUpYou(uid);
  }

  Future<WakeUpModel> getTomorrowWakeUpMeProvider() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    return _wakeUpRepository.getTomorrowWakeUpMe(uid);
  }

  wakeUpAprove(String reciverUid, String senderUid, String wakeUpUid) {
    _wakeUpRepository.wakeUpAprove(reciverUid, wakeUpUid);
    _wakeUpRepository.wakeUpAprove(senderUid, wakeUpUid);
  }
}