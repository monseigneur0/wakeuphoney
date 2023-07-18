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
    const uid = "IZZ1HICxZ8ggCiJihcJKow38LPK2";
    return _dailyRepository.getDailyMessage(uid, date, "messages");
  }

  Stream<DailyMessageModel> getDailyCoupleMessage(String date) {
    final uid = _ref
        .watch(getUserDataProvider("IZZ1HICxZ8ggCiJihcJKow38LPK2"))
        .value!
        .couple;
    return _dailyRepository.getDailyMessage(uid, date, "messages");
  }

  Stream<List<DailyMessageModel>> getDailyMessageList() {
    const uid = "IZZ1HICxZ8ggCiJihcJKow38LPK2";
    return _dailyRepository.getDailyMessageList(uid);
  }

  Stream<List<DailyMessageModel>> getDailyCoupleMessageHistoryList() {
    final uid = _ref
        .watch(getUserDataProvider("IZZ1HICxZ8ggCiJihcJKow38LPK2"))
        .value!
        .couple;
    //그냥 uid 에서 커플꺼로 바꿈
    return _dailyRepository.getDailyMessageHistoryList(uid);
  }

  Stream<List<DailyMessageModel>> getDailyMessageHistoryList() {
    const uid = "IZZ1HICxZ8ggCiJihcJKow38LPK2";

    return _dailyRepository.getDailyMessageHistoryList(uid);
  }

  void createDailyMessage(messagef) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = "IZZ1HICxZ8ggCiJihcJKow38LPK2";
    DailyMessageModel messagehere = DailyMessageModel(
        message: messagef,
        messagedate: _ref.watch(selectedDate),
        messagedatetime: _ref.watch(selectedDateTime),
        time: DateTime.now(),
        sender: uid,
        reciver: prefs.getString("coupleuid") ?? "",
        photo: "",
        audio: "",
        video: "");

    await _dailyRepository.createDailyMessage(messagehere, uid);
  }

  void createDailyMessageImage(messagef, imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = "IZZ1HICxZ8ggCiJihcJKow38LPK2";
    DailyMessageModel messagehere = DailyMessageModel(
        message: messagef,
        messagedate: _ref.watch(selectedDate),
        messagedatetime: _ref.watch(selectedDateTime),
        time: DateTime.now(),
        sender: uid,
        reciver: prefs.getString("coupleuid") ?? "",
        photo: imageUrl,
        audio: "",
        video: "");

    await _dailyRepository.createDailyMessage(messagehere, uid);
  }

  void updateDailyMessage(message, id) async {
    String uid = "IZZ1HICxZ8ggCiJihcJKow38LPK2";
    await _dailyRepository.updateDailyMessage(
        message, _ref.watch(selectedDate), uid);
  }

  void updateDailyImage(image) async {
    String uid = "IZZ1HICxZ8ggCiJihcJKow38LPK2";
    await _dailyRepository.updateDailyImage(
        image, _ref.watch(selectedDate), uid);
  }

  void createResponseMessage(message, imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = "IZZ1HICxZ8ggCiJihcJKow38LPK2";

    DailyMessageModel messagehere = DailyMessageModel(
        message: message,
        messagedate:
            DateFormat.yMMMd().format(_ref.watch(dateTimeStateProvider)[0]),
        messagedatetime: _ref.watch(selectedDateTime),
        time: DateTime.now(),
        sender: uid,
        reciver: prefs.getString("coupleuid") ?? "",
        photo: imageUrl,
        audio: "",
        video: "");
    await _dailyRepository.createResponseMessage(
        messagehere, uid, prefs.getString("coupleuid") ?? "");
  }
}
