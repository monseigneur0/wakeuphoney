import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/fcm_manager.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/tabs/wake/wake_controller.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';

class AcceptBox extends ConsumerStatefulWidget {
  final UserModel user;
  final WakeModel wake;

  const AcceptBox(
    this.user,
    this.wake, {
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AcceptBoxState();
}

class _AcceptBoxState extends ConsumerState<AcceptBox> {
  late String audioAssetPath = 'assets/sounds/marimba.mp3';

  // 파일을 저장하는 함수
  Future<void> saveToFile(String audioUrl) async {
    // 파일 경로를 생성함
    final directory = await getApplicationDocumentsDirectory();

    final fileName = audioUrl.split('-').last;

    audioAssetPath = '${directory.path}/$fileName.m4a';

    final file = File(audioAssetPath);
    // 파일에 내용을 저장함

    var response = await http.get(Uri.parse(audioUrl));

    await file.writeAsBytes(response.bodyBytes);
  }

  AlarmSettings buildAlarmSettings(TimeOfDay selectedTime1, String audioPath) {
    final now = DateTime.now();
    final id = DateTime.now().millisecondsSinceEpoch % 100000;
    var logger = Logger();

    if (audioPath.isNotEmpty || audioPath != "") {
      saveToFile(audioPath);
    }

    DateTime dateTimewake = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime1.hour,
      selectedTime1.minute,
      0,
      0,
    );
    if (dateTimewake.isBefore(DateTime.now())) {
      dateTimewake = dateTimewake.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTimewake,
      loopAudio: ref.read(loopAudioProvider),
      vibrate: ref.read(vibrateProvider),
      volume: ref.read(volumeProvider),
      notificationTitle: 'wakeupgomalarm'.tr(),
      notificationBody: 'alarmringletter'.tr(),
      assetAudioPath: audioAssetPath,
      // days: days,
    );
    logger.d(alarmSettings);
    return alarmSettings;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateFormat('a hh:mm').format(widget.wake.wakeTime).toString().text.medium.color(AppColors.primary700).make(),
        Image.asset('assets/images/wakeupbear/wakeupbearsleep.png', width: Constants.cardPngWidth),
        'I will wake you up at'.tr().text.medium.make(),
        height10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalButton(
              text: 'no'.tr(),
              onPressed: () {
                ref.read(wakeControllerProvider.notifier).deleteWakeUp(widget.wake.wakeUid);
              },
              isPreferred: false,
            ),
            width10,
            NormalButton(
              text: 'yes'.tr(),
              onPressed: () {
                FcmManager.requestPermission();

                ref.read(wakeControllerProvider.notifier).acceptWakeUp(widget.wake.wakeUid);
                ref.read(selectedDateTime.notifier).state = widget.wake.wakeTime;
                ref.read(selectedTime.notifier).state = TimeOfDay(hour: widget.wake.wakeTime.hour, minute: widget.wake.wakeTime.minute);
                Alarm.set(alarmSettings: buildAlarmSettings(ref.read(selectedTime.notifier).state, widget.wake.messageAudio));
              },
            ),
          ],
        ),
      ],
    );
  }
}
