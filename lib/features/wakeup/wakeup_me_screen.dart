import 'package:alarm/alarm.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/constants/design_constants.dart';
import '../alarm/alarm_day_settings.dart';
import 'wakeup_controller.dart';

class WakeUpMeScreen extends ConsumerStatefulWidget {
  final AlarmSettings? alarmSettings;

  const WakeUpMeScreen({super.key, this.alarmSettings});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeUpMeScreenState();
}

class _WakeUpMeScreenState extends ConsumerState<WakeUpMeScreen> {
  bool loading = false;

  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late bool showNotification;
  late String assetAudio;

  late List<bool> days;

  late AlarmDaySettings alarmDaySettings =
      AlarmDaySettings(alarmSettings: widget.alarmSettings);

  late TimeOfDay selectedTime;
  late Time _time;
  var logger = Logger();

  @override
  void initState() {
    super.initState();

    selectedDateTime = DateTime.now()
        .add(const Duration(minutes: 10))
        .copyWith(second: 0, millisecond: 0);
    selectedTime =
        TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute);
    loopAudio = true;
    vibrate = true;
    volume = null;
    showNotification = true;
    assetAudio = 'assets/marimba.mp3';
    days = <bool>[
      true,
      false,
      true,
      false,
      true,
      false,
      true,
    ];
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == 2) {
      return 'After tomorrow';
    } else {
      return 'In $difference days';
    }
  }

  Future<void> pickTime() async {
    _time = Time(hour: selectedTime.hour, minute: selectedTime.minute);
    final res = await Navigator.of(context).push(showPicker(
      showSecondSelector: false,
      context: context,
      value: _time,
      onChange: onTimeChanged,
      minuteInterval: TimePickerInterval.ONE,
      iosStylePicker: true,
      minHour: 0,
      maxHour: 23,
      is24HrFormat: true,
      width: 360,
      // dialogInsetPadding:
      //     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
      hourLabel: ':',
      minuteLabel: ' ',
      // Optional onChange to receive value as DateTime
      onChangeDateTime: (DateTime dateTime) {
        // logger.d(dateTime);
        logger.d("[debug datetime]:  $dateTime");
      },
    ));
    logger.d(_time);

    //     showTimePicker(
    //   initialTime: selectedTime,
    //   context: context,
    // );
    if (res != null) {
      setState(() {
        selectedTime = _time.toTimeOfDay();
      });
    }
  }

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  AlarmSettings buildAlarmSettings(TimeOfDay selectedTime1) {
    final now = DateTime.now();
    final id = DateTime.now().millisecondsSinceEpoch % 100000;

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
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume,
      notificationTitle: AppLocalizations.of(context)!.wakeupgomalarm,
      notificationBody: AppLocalizations.of(context)!.alarmringletter,
      assetAudioPath: assetAudio,
      // days: days,
    );
    logger.d(alarmSettings);
    return alarmSettings;
  }

  String intDayToEnglish(int day) {
    if (day % 7 == DateTime.monday % 7) return 'Monday';
    if (day % 7 == DateTime.tuesday % 7) return 'Tueday';
    if (day % 7 == DateTime.wednesday % 7) return 'Wednesday';
    if (day % 7 == DateTime.thursday % 7) return 'Thursday';
    if (day % 7 == DateTime.friday % 7) return 'Friday';
    if (day % 7 == DateTime.saturday % 7) return 'Saturday';
    if (day % 7 == DateTime.sunday % 7) return 'Sunday';
    throw '🐞 This should never have happened: $day';
  }

  printIntAsDay(int day) {
    logger.d(
        'Received integer: $day. Corresponds to day: ${intDayToEnglish(day)}');
  }

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    final wakeMeUp = ref.watch(getTomorrowWakeUpMeProvider);

    return Container(
        child: wakeMeUp.when(
            data: (data) {
              if (data.letter.isEmpty || data.letter == "") {
                return Container(
                  color: Colors.blue,
                  child: const Center(
                      child: Column(
                    children: [
                      Text("상대가 아직 깨워주지 않았어요"),
                      Image(
                        image: AssetImage('assets/images/rabbitwake.jpeg'),
                        height: 250,
                      )
                    ],
                  )),
                );
              }
              if (data.isApproved == true) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                      color: AppColors.green,
                      child: Column(children: [
                        Text(data.wakeUpUid),
                        Text(data.createdTime.toString()),
                        Text(data.letter),
                        Text(data.senderUid),
                        Text(data.reciverUid),
                        Text(data.wakeTime.toString()),
                        const Text("승낙하셨습니다."),
                        const Image(
                          image: AssetImage('assets/images/rabbitspeak.jpeg'),
                          height: 250,
                        )
                      ])),
                );
              }
              return GestureDetector(
                onTap: () {
                  ref.watch(wakeUpControllerProvider.notifier).wakeUpAprove(
                      data.reciverUid, data.senderUid, data.wakeUpUid);
                  ref.watch(getTomorrowWakeUpMeProvider);
                  selectedDateTime = data.wakeTime;
                  selectedTime = TimeOfDay(
                      hour: data.wakeTime.hour, minute: data.wakeTime.minute);
                  setState(() => loading = true);
                  Alarm.set(alarmSettings: buildAlarmSettings(selectedTime))
                      .then((res) {});
                  setState(() => loading = false);
                },
                child: Container(
                  color: AppColors.myPink,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(data.wakeUpUid),
                      Text(data.wakeTime.toString()),
                      const Text("승낙하시면 알람이 울립니다."),
                      const Text("승낙하시면 알람이 등록됩니다."),
                      const Image(
                        image: AssetImage('assets/images/rabbitalarm.jpeg'),
                        height: 250,
                      )
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) {
              logger.e(err);

              return const Center(
                child: Text(
                  "Error\n please restart your app",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }));
  }
}
