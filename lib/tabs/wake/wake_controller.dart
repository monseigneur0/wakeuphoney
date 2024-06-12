import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/passwords.dart';
import 'package:wakeuphoney/tabs/wake/wake_repository.dart';

import 'wake_model.dart';

final wakeControllerProvider = AsyncNotifierProvider<WakeController, void>(() => WakeController());

final fetchWakeListProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(wakeControllerProvider.notifier).fetchWakeList();
});

final wakeListStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(wakeControllerProvider.notifier).fetchWakeListStream();
});

final alarmListStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(wakeControllerProvider.notifier).fetchAlarmListStream();
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

  Future<String?> createFCM(String fcmToken) async {
    try {
      String accessToken = Passwords.accesstoken1;
      http.Response response = await http.post(
          Uri.parse(
            "https://fcm.googleapis.com/v1/projects/wakeuphoneys2/messages:send",
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: json.encode({
            "message": {
              "token": fcmToken,
              // "topic": "user_uid",

              "notification": {
                "title": "FCM Test Title",
                "body": "FCM Test Body",
              },
              "data": {
                "click_action": "FCM Test Click Action",
              },
              "android": {
                "notification": {
                  "click_action": "Android Click Action",
                }
              },
              "apns": {
                "payload": {
                  "aps": {"category": "Message Category", "content-available": 1}
                }
              }
            }
          }));
      if (response.statusCode == 200) {
        logger.d(response.body);
        return null;
      } else {
        return "Faliure";
      }
    } on HttpException catch (error) {
      return error.message;
    }
  }

  Future<String?> createFriendFCM(String title, String body) async {
    try {
      String accessToken = Passwords.accesstoken2;
      http.Response response = await http.post(
          Uri.parse(
            "https://fcm.googleapis.com/v1/projects/wakeuphoneys2/messages:send",
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: json.encode({
            "message": {
              "token": ref.read(friendUserModelProvider)?.fcmToken ?? "",
              // "topic": "user_uid",

              "notification": {
                "title": title,
                "body": body,
              },
              "data": {
                "click_action": "FCM Test Click Action",
              },
              "android": {
                "notification": {
                  "click_action": "Android Click Action",
                }
              },
              "apns": {
                "payload": {
                  "aps": {
                    "category": "Message Category",
                    "content-available": 1,
                  }
                }
              }
            }
          }));
      if (response.statusCode == 200) {
        logger.d(response.body);
        return null;
      } else {
        return "Faliure";
      }
    } on HttpException catch (error) {
      return error.message;
    }
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
        notificationBody: "알람을 확인해주세요.",
        enableNotificationOnKill: true,
        androidFullScreenIntent: true,
        isDeleted: false,
        isApproved: false,
        isRejected: false,
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
      showToast('Alarm set successfully.'.tr());
    } else {
      showToast('Alarm setting failed. Please try again.'.tr());
    }
    final successcreateWakeUpFriend = _repository.createWakeUp(user.couples!.first, wakeModel);
    if (successcreateWakeUpFriend) {
      showToast('Alarm set successfully.'.tr());
    } else {
      showToast('Alarm setting failed. Please try again.'.tr());
    }
  }

  Future<List<WakeModel>> fetchWakeList() {
    return _repository.fetchWakeList(uid);
  }

  Stream<List<WakeModel>> fetchAlarmListStream() {
    return _repository.fetchAlarmListStream(uid);
  }

  Stream<List<WakeModel>> fetchWakeListStream() {
    return _repository.fetchWakeListStream(uid);
  }

  void deleteWakeUp(String wakeUid) {
    _repository.deleteWakeUp(uid, wakeUid);
    _repository.deleteWakeUp(user.couples!.first, wakeUid);
    showToast('Alarm deleted.'.tr());
  }

  void acceptWakeUp(String wakeUid) {
    _repository.acceptWakeUp(uid, wakeUid);
    _repository.acceptWakeUp(user.couples!.first, wakeUid);
    showToast('Alarm accepted.'.tr());
  }

  void reply(String wakeUid, String reply, String imageUrl, String voiceUrl, String videoUrl) {
    _repository.reply(uid, wakeUid, reply, imageUrl, voiceUrl, videoUrl);
    showToast('Reply sent.'.tr());
  }
}
