import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
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

final getLettersListProvider = StreamProvider(
    (ref) => ref.watch(dailyControllerProvider.notifier).getLettersList());

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
final createAllMessageListProvider = StreamProvider((ref) {
  final dailyController = ref.watch(dailyControllerProvider.notifier);
  return dailyController.createAllMessageList();
});

class DailyController extends StateNotifier<bool> {
  final DailyRepository _dailyRepository;

  final Ref _ref;

  DailyController({required DailyRepository dailyRepository, required Ref ref})
      : _dailyRepository = dailyRepository,
        _ref = ref,
        super(false); //loading

  // Stream<DailyMessageModel> getDailyMessage(String date) {
  //   User? auser = _ref.watch(authProvider).currentUser;
  //   String uid;
  //   auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
  //   return _dailyRepository.getDailyMessage(uid, date, "messages");
  // }

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

  //23.11.30
  Stream<List<DailyMessageModel>> getLettersList() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    final myLetter = _dailyRepository.getLettersList(uid);
    return myLetter;
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
    String coupleUid = "";
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

  // void createDailyMessage(messagef) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   User? auser = _ref.watch(authProvider).currentUser;
  //   String uid;
  //   auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

  //   final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
  //   String coupleUid;
  //   coupleUidValue != null
  //       ? coupleUid = coupleUidValue.couple
  //       : coupleUid = "PyY5skHRgPJP0CMgI2Qp";

  //   DailyMessageModel messagehere = DailyMessageModel(
  //       message: messagef,
  //       messagedate: _ref.watch(selectedDate),
  //       messagedatetime: _ref.watch(selectedDateTime),
  //       time: DateTime.now(),
  //       sender: uid,
  //       reciver: coupleUid,
  //       photo: "",
  //       audio: "",
  //       video: "");

  //   await _dailyRepository.createDailyMessage(messagehere, uid);
  // }

  void createDailyMessageImage(messagef, imageUrl) async {
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
      video: "",
      isLetter: true,
    );

    await _dailyRepository.createDailyMessage(messagehere, uid);
    await _dailyRepository.createDailyMessage(messagehere, coupleUid);
  }

  void updateDailyMessage(message) async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    await _dailyRepository.updateDailyMessage(
        message, _ref.watch(selectedDate), uid);
  }

  void deleteDailyMessage() async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    await _dailyRepository.deleteDailyMessage(_ref.watch(selectedDate), uid);
  }

  void updateDailyImage(image) async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    await _dailyRepository.updateDailyImage(
        image, _ref.watch(selectedDate), uid);
  }

  void createResponseMessage(message, imageUrl) async {
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
      video: "",
      isLetter: false,
    );
    await _dailyRepository.createResponseMessage(messagehere, uid, coupleUid);
  }

  Stream<List<DailyMessageModel>> createAllMessageList() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    final allList = _dailyRepository.getDailyMessageList(uid);
    final historyList = _dailyRepository.getHistoryMessageList(uid);
    Stream<List<DailyMessageModel>> wow = allList;
    final historyFiltered = allList.where((event) =>
        event.single.messagedatetime.compareTo(DateTime.now()) == -1);

    final List<DateTime> listDateTime =
        _ref.watch(dateTimeNotTodayStateProvider);

    final wow1 = List<DateTime>.generate(
      100,
      (index) => DateTime.now()
          .add(Duration(
              seconds: 24 * 60 * 60 -
                  DateTime.now().hour * 3600 -
                  DateTime.now().minute * 60 -
                  DateTime.now().second))
          .add(Duration(days: index)),
    );
    // List<DailyMessageModel> pureList = _dailyRepository.getDailyMessageList(uid);
    // final hellow = List<DailyMessageModel>.generate(100, (index) => );

    // final wowowowow = List<DailyMessageModel>.generate(100, (index) {
    //   final wwww = allList.where((event) {
    //     return event.single.messagedate ==
    //         DateFormat.yMMMd().format(listDateTime[index]);
    //   });
    //  return  wwww.first.then((value) => value.isNotEmpty ? value.first. : DailyMessageModel(
    //     message: "메세지를 적어주세요",
    //     messagedate: "messagedate",
    //     messagedatetime: DateTime.now(),
    //     time: DateTime.now(),
    //     sender: "",
    //     reciver: "",
    //     photo: "",
    //     audio: "",
    //     video: "",
    //   ); );
    //   return DailyMessageModel(
    //     message: "메세지를 적어주세요",
    //     messagedate: "messagedate",
    //     messagedatetime: DateTime.now(),
    //     time: DateTime.now(),
    //     sender: "",
    //     reciver: "",
    //     photo: "",
    //     audio: "",
    //     video: "",
    //   );
    // });
    // logger.d(wowowowow);
    // var messageNow = allList.singleWhere(
    //   (element) =>
    //       element.messagedate == DateFormat.yMMMd().format(listDateTime[index]),
    //   orElse: () =>
    // DailyMessageModel(
    //     message: "메세지를 적어주세요",
    //     messagedate: "messagedate",
    //     messagedatetime: DateTime.now(),
    //     time: DateTime.now(),
    //     sender: "",
    //     reciver: "",
    //     photo: "",
    //     audio: "",
    //     video: "",
    //   ),
    // );
    // logger.d(wow);
    // logger.d(wow1);
    return allList;
  }
}
