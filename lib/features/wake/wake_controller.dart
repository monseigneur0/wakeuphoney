import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/wake/wake_model.dart';

import '../auth/auth_controller.dart';
import 'wake_repository.dart';

final wakeControllerProvider =
    StateNotifierProvider<WakeController, bool>((ref) => WakeController(
          wakeRepository: ref.watch(wakeRepositoryProvider),
          ref: ref,
        ));

final getWakesListProvider = StreamProvider(
    ((ref) => ref.watch(wakeControllerProvider.notifier).getWakes()));

class WakeController extends StateNotifier<bool> {
  final WakeRepository _wakeRepository;
  final Ref _ref;

  WakeController({required WakeRepository wakeRepository, required Ref ref})
      : _wakeRepository = wakeRepository,
        _ref = ref,
        super(false);
  Logger logger = Logger();
  createWake(WakeModel wakeModel) {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final coupleUidValue = _ref.watch(getUserDataProvider(uid)).value;
    String coupleUid;
    coupleUidValue != null
        ? coupleUid = coupleUidValue.couple!
        : coupleUid = "PyY5skHRgPJP0CMgI2Qp";
    WakeModel newWakeModel = WakeModel(
      uid: wakeModel.uid,
      alarmId: wakeModel.alarmId,
      dateTime: wakeModel.dateTime,
      assetAudioPath: wakeModel.assetAudioPath,
      loopAudio: wakeModel.loopAudio,
      vibrate: wakeModel.vibrate,
      volume: wakeModel.volume,
      fadeDuration: wakeModel.fadeDuration,
      notificationTitle: wakeModel.notificationTitle,
      notificationBody: wakeModel.notificationBody,
      enableNotificationOnKill: wakeModel.enableNotificationOnKill,
      androidFullScreenIntent: wakeModel.androidFullScreenIntent,
      isApproved: wakeModel.isApproved,
      requestTime: wakeModel.requestTime,
      approveTime: wakeModel.approveTime,
      isDeleted: wakeModel.isDeleted,
      sender: uid,
      reciver: coupleUid,
      days: wakeModel.days,
    );

    _wakeRepository.createWake(uid, coupleUid, newWakeModel);
  }

  Stream<List<WakeModel>> getWakes() {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    print(uid);
    return _wakeRepository.getWakes(uid);
  }
}