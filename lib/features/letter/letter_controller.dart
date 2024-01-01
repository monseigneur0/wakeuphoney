import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

final getLettersListProvider = StreamProvider(
    (ref) => ref.watch(letterControllerProvider.notifier).getLettersList());

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

    LetterModel letterModel = LetterModel(
      letterId: "",
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

  Stream<List<LetterModel>> getLettersList() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    return _letterRepository.getLettersList(uid);
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
