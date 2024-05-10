import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/oldauth/user_model.dart';
import 'package:wakeuphoney/screen/auth/login_controller.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_repository.dart';

import 'wake_model.dart';

final wakeControllerProvider = AsyncNotifierProvider<WakeController, void>(() => WakeController());

final fetchWakeListProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(wakeControllerProvider.notifier).fetchWakeList();
});

final wakeListStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(wakeControllerProvider.notifier).fetchWakeListStream();
});

class WakeController extends AsyncNotifier<void> {
  late final WakeRepository _repository;

  Logger logger = Logger();

  String get uid => ref.read(uidProvider);
  UserModel get user => ref.read(userModelProvider) ?? UserModel.empty();

  @override
  FutureOr<void> build() {
    _repository = ref.read(wakeRepositoryProvider);
  }

  void createWakeUp(String message, TimeOfDay selectedTime, volume, vibrate, assetAudio) {
    final now = DateTime.now();

    DateTime wakeTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute, 0, 0);
    if (wakeTime.isBefore(DateTime.now())) {
      wakeTime = wakeTime.add(const Duration(days: 1));
    }

    WakeModel wakeModel = WakeModel(
        wakeUid: const Uuid().v4(),
        createdTime: now,
        modifiedTimes: now,
        alarmId: now.millisecondsSinceEpoch % 100000,
        wakeTime: wakeTime,
        assetAudioPath: assetAudio,
        loopAudio: true,
        vibrate: vibrate,
        volume: volume,
        fadeDuration: 0.1,
        notificationTitle: "알람이 울려요",
        notificationBody: "확인해보세요",
        enableNotificationOnKill: true,
        androidFullScreenIntent: true,
        isDeleted: false,
        isApproved: false,
        senderUid: uid,
        message: message,
        messagePhoto: ref.read(imageUrlProvider),
        messageAudio: ref.read(voiceUrlProvider),
        messageVideo: ref.read(videoUrlProvider),
        reciverUid: user.couples!.first,
        answer: "",
        answerPhoto: "",
        answerAudio: "",
        answerVideo: "");

    final successcreateWakeUp = _repository.createWakeUp(uid, wakeModel);
    if (successcreateWakeUp) {
      showToast('알람이 성공적으로 설정되었습니다.');
    } else {
      showToast('알람 설정에 실패했습니다. 다시 시도해주세요.');
    }
    final successcreateWakeUpFriend = _repository.createWakeUp(user.couples!.first, wakeModel);
    if (successcreateWakeUpFriend) {
      showToast('알람이 성공적으로 설정되었습니다.');
    } else {
      showToast('알람 설정에 실패했습니다. 다시 시도해주세요.');
    }
  }

  Future<List<WakeModel>> fetchWakeList() {
    return _repository.fetchWakeList(uid);
  }

  Stream<List<WakeModel>> fetchWakeListStream() {
    return _repository.fetchWakeListStream(uid);
  }

  void deleteWakeUp(String wakeUid) {
    _repository.deleteWakeUp(uid, wakeUid);
    _repository.deleteWakeUp(user.couples!.first, wakeUid);
    showToast('알람이 삭제되었습니다.');
  }
}
