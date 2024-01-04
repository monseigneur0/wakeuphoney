import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/firebase_providers.dart';
import '../../core/providers/providers.dart';
import '../auth/auth_controller.dart';
import 'letter_model.dart';
import 'letter_repository.dart';

final letterControllerProvider =
    StateNotifierProvider<LetterController, bool>((ref) => LetterController(
          letterRepository: ref.watch(letterRepositoryProvider),
          ref: ref,
        ));

final getLetters2ListProvider = StreamProvider(
    (ref) => ref.watch(letterControllerProvider.notifier).getLetters2List());

class LetterController extends StateNotifier<bool> {
  final LetterRepository _letterRepository;
  final Ref _ref;

  LetterController(
      {required LetterRepository letterRepository, required Ref ref})
      : _letterRepository = letterRepository,
        _ref = ref,
        super(false);

  createLetter(String message, String photoUrl) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple!
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";

    String uuid = const Uuid().v4();

    LetterModel letterModel = LetterModel(
      letterId: uuid,
      dateTimeNow: DateTime.now(),
      sender: uid,
      letterTime: _ref.watch(selectedDateTime),
      letter: message,
      letterPhoto: photoUrl,
      letterAudio: "",
      letterVideo: "",
      reciver: coupleUid,
      answer: "",
      answerTime: DateTime.now(),
      answerPhoto: "",
      answerAudio: "",
      answerVideo: "",
    );

    _letterRepository.createLetter(letterModel, uid);
    _letterRepository.createLetter(letterModel, coupleUid);
  }

  Stream<List<LetterModel>> getLetters2List() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    final letterList = _letterRepository.getLetters2List(uid);
    //오늘 날짜 이전으로 받는사람이 나인것만, 보낸사람이 나인건 모두 보여주기.
    //날짜순 정렬하기
    Logger().d(letterList);
    return letterList;
  }

  letterEdit(String message, String letterId) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple!
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";

    _letterRepository.letterEditMessage(uid, letterId, message);
    _letterRepository.letterEditMessage(coupleUid, letterId, message);
  }

  letterDelete(String letterId) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple!
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";

    _letterRepository.letterDelete(uid, letterId);
    _letterRepository.letterDelete(coupleUid, letterId);
  }
}
