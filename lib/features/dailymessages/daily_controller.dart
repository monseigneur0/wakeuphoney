import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/auth/auth_controller.dart';

import '../../core/providers/providers.dart';
import 'daily_model.dart';
import 'daily_repo.dart';

final dailyControllerProvider =
    StateNotifierProvider<DailyController, bool>((ref) => DailyController(
          dailyRepository: ref.watch(dailyRepositoryProvider),
          ref: ref,
        ));

final getDailyMessageProvider = StreamProvider.family((ref, String date) {
  final dailyController = ref.watch(dailyControllerProvider.notifier);
  return dailyController.getDailyMessage(date);
});
final getDailyCoupleMessageProvider = StreamProvider.family((ref, String date) {
  final dailyController = ref.watch(dailyControllerProvider.notifier);
  return dailyController.getDailyCoupleMessage(date);
});

final getDailyMessageListProvider = StreamProvider((ref) {
  final dailyController = ref.watch(dailyControllerProvider.notifier);
  return dailyController.getDailyMessageList();
});

final getDailyMessageHistoryListProvider = StreamProvider((ref) {
  final dailyController = ref.watch(dailyControllerProvider.notifier);
  return dailyController.getDailyMessageHistoryList();
});
final getDailyCoupleMessageHistoryListProvider = StreamProvider((ref) {
  final dailyController = ref.watch(dailyControllerProvider.notifier);
  return dailyController.getDailyCoupleMessageHistoryList();
});

class DailyController extends StateNotifier<bool> {
  final DailyRepository _dailyRepository;

  final Ref _ref;

  DailyController({required DailyRepository dailyRepository, required Ref ref})
      : _dailyRepository = dailyRepository,
        _ref = ref,
        super(false); //loading

  Stream<DailyMessageModel> getDailyMessage(String date) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    return _dailyRepository.getDailyMessage(uid, date, "messages");
  }

  Stream<DailyMessageModel> getDailyCoupleMessage(String date) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";

    return _dailyRepository.getDailyMessage(coupleUid, date, "messages");
  }

  Stream<List<DailyMessageModel>> getDailyMessageList() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    return _dailyRepository.getDailyMessageList(uid);
  }

  Stream<List<DailyMessageModel>> getDailyCoupleMessageHistoryList() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";
    //그냥 uid 에서 커플꺼로 바꿈
    return _dailyRepository.getDailyMessageHistoryList(coupleUid);
  }

  Stream<List<DailyMessageModel>> getDailyMessageHistoryList() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    return _dailyRepository.getDailyMessageHistoryList(uid);
  }

  void createDailyMessage(messagef) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";

    DailyMessageModel messagehere = DailyMessageModel(
        message: messagef,
        messagedate: _ref.watch(selectedDate),
        messagedatetime: _ref.watch(selectedDateTime),
        time: DateTime.now(),
        sender: uid,
        reciver: coupleUid,
        photo: "",
        audio: "",
        video: "");

    await _dailyRepository.createDailyMessage(messagehere, uid);
  }

  void createDailyMessageImage(messagef, imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";

    DailyMessageModel messagehere = DailyMessageModel(
        message: messagef,
        messagedate: _ref.watch(selectedDate),
        messagedatetime: _ref.watch(selectedDateTime),
        time: DateTime.now(),
        sender: uid,
        reciver: coupleUid,
        photo: imageUrl,
        audio: "",
        video: "");

    await _dailyRepository.createDailyMessage(messagehere, uid);
  }

  void updateDailyMessage(message) async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    await _dailyRepository.updateDailyMessage(
        message, _ref.watch(selectedDate), uid);
  }

  void updateDailyImage(image) async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    await _dailyRepository.updateDailyImage(
        image, _ref.watch(selectedDate), uid);
  }

  void createResponseMessage(message, imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";

    DailyMessageModel messagehere = DailyMessageModel(
        message: message,
        messagedate:
            DateFormat.yMMMd().format(_ref.watch(dateTimeStateProvider)[0]),
        messagedatetime: _ref.watch(selectedDateTime),
        time: DateTime.now(),
        sender: uid,
        reciver: coupleUid,
        photo: imageUrl,
        audio: "",
        video: "");
    await _dailyRepository.createResponseMessage(messagehere, uid, coupleUid);
  }
}
