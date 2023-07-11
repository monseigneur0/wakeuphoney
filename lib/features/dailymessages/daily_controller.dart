import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';

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

final getDailyMessageListProvider = StreamProvider((ref) {
  final dailyController = ref.watch(dailyControllerProvider.notifier);
  return dailyController.getDailyMessageList();
});

class DailyController extends StateNotifier<bool> {
  final DailyRepository _dailyRepository;

  final Ref _ref;

  DailyController({required DailyRepository dailyRepository, required Ref ref})
      : _dailyRepository = dailyRepository,
        _ref = ref,
        super(false); //loading

  Stream<DailyMessageModel> getDailyMessage(String date) {
    final uid = _ref.watch(authProvider).currentUser!.uid;
    return _dailyRepository.getDailyMessage(uid, date, "messages");
  }

  Stream<List<DailyMessageModel>> getDailyMessageList() {
    final uid = _ref.watch(authProvider).currentUser!.uid;
    return _dailyRepository.getDailyMessageList(uid);
  }

  void createDailyMessage(messagef) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = _ref.watch(authProvider).currentUser!.uid;
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

  void updateDailyMessage(message, uid) async {
    await _dailyRepository.updateDailyMessage(
        message, _ref.watch(selectedDate), uid);
  }

  void createResponseMessage(message, uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DailyMessageModel messagehere = DailyMessageModel(
        message: message,
        messagedate:
            DateFormat.yMMMd().format(_ref.watch(dateTimeStateProvider)[0]),
        messagedatetime: _ref.watch(selectedDateTime),
        time: DateTime.now(),
        sender: uid,
        reciver: prefs.getString("coupleuid") ?? "",
        photo: "",
        audio: "",
        video: "");
    await _dailyRepository.createResponseMessage(
        messagehere, uid, prefs.getString("coupleuid") ?? "");
  }
}
