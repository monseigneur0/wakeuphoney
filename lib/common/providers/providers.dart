import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:intl/intl.dart';

import 'package:wakeuphoney/auth/user_model.dart';

final imageUrlProvider = StateProvider<String>((ref) => '');
final voiceUrlProvider = StateProvider<String>((ref) => '');
final videoUrlProvider = StateProvider<String>((ref) => '');

final numberProvider = Provider<int>((ref) {
  return 1;
});
final numberStateProvider = StateProvider<int>((ref) {
  return 1;
});

final dateStateProvider = StateProvider<List<String>>(
  (ref) => List<String>.generate(
    100,
    (index) => DateFormat.yMMMd().format(
      DateTime.now().add(
        Duration(days: index),
      ),
    ),
  ),
);

final dateTimeStateProvider = StateProvider<List<DateTime>>((ref) => List<DateTime>.generate(
      100,
      (index) => DateTime.now().add(Duration(days: index)),
    ));
final dateTimeNotTodayStateProvider = StateProvider<List<DateTime>>((ref) => List<DateTime>.generate(
      100,
      (index) => DateTime.now()
          .add(Duration(seconds: 24 * 60 * 60 - DateTime.now().hour * 3600 - DateTime.now().minute * 60 - DateTime.now().second))
          .add(Duration(days: index)),
    ));

final selectedDate = StateProvider(
  (ref) => DateFormat.yMMMd().format(
    DateTime.now(),
  ),
);

final userModelofMeStateProvider = StateProvider<UserModel?>((ref) => null);

final userModelProvider = StateProvider<UserModel?>((ref) => null);
final friendUserModelProvider = StateProvider<UserModel?>((ref) => null);

//alarm providers
final selectedDateTime = StateProvider<DateTime>((ref) => DateTime.now());
final selectedTime = StateProvider<TimeOfDay>((ref) => TimeOfDay.now());

final alarmSettingsProvider = StateProvider<AlarmSettings>((ref) => AlarmSettings(
      id: 0,
      dateTime: DateTime.now(),
      assetAudioPath: 'assets/sounds/alarm.mp3',
      loopAudio: true,
      notificationTitle: 'Alarm',
      notificationBody: 'Wake up!',
    ));

final loopAudioProvider = StateProvider<bool>((ref) => false);
final vibrateProvider = StateProvider<bool>((ref) => false);
final volumeProvider = StateProvider<double?>((ref) => 0.8);
final pushTokenProvider = StateProvider<String>((ref) => '');
final wakeIdProvider = StateProvider<String>((ref) => '');
