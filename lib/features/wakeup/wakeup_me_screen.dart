import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/main/main_screen.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.wakeupgom),
      ),
      body: Center(
          child: wakeMeUp.when(
              data: (data) {
                if (data.letter.isEmpty || data.letter == "") {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: AppColors.rabbitwake,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WakeUpStatus(
                            AppLocalizations.of(context)!.wakeupmenotyet),
                        const Image(
                          image: AssetImage('assets/images/rabbitwake.jpeg'),
                          height: 220,
                        )
                      ],
                    )),
                  );
                }
                if (data.isApproved == true) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: AppColors.rabbitspeak,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WakeUpStatus(AppLocalizations.of(context)!
                                  .wakeupmeapproved),
                              Text(
                                  "${DateFormat('hh:mm').format(data.wakeTime)}${AppLocalizations.of(context)!.wakeupmeat}"),
                              const Image(
                                image: AssetImage(
                                    'assets/images/rabbitspeak.jpeg'),
                                height: 220,
                              )
                            ])),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    Platform.isIOS
                        ? showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: Text(AppLocalizations.of(context)!.alarm),
                              content: Text(AppLocalizations.of(context)!
                                  .wakeupmenotapproved),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(AppLocalizations.of(context)!.no),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    ref
                                        .watch(
                                            wakeUpControllerProvider.notifier)
                                        .wakeUpAprove(data.reciverUid,
                                            data.senderUid, data.wakeUpUid);
                                    selectedDateTime = data.wakeTime;
                                    selectedTime = TimeOfDay(
                                        hour: data.wakeTime.hour,
                                        minute: data.wakeTime.minute);
                                    setState(() => loading = true);
                                    Alarm.set(
                                            alarmSettings: buildAlarmSettings(
                                                selectedTime))
                                        .then((res) {});
                                    setState(() => loading = false);
                                    context.goNamed(MainScreen.routeName);
                                  },
                                  isDestructiveAction: true,
                                  child:
                                      Text(AppLocalizations.of(context)!.yes),
                                ),
                              ],
                            ),
                          )
                        : showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    Text(AppLocalizations.of(context)!.alarm),
                                content: Text(AppLocalizations.of(context)!
                                    .wakeupmenotapproved),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ref
                                          .watch(
                                              wakeUpControllerProvider.notifier)
                                          .wakeUpAprove(data.reciverUid,
                                              data.senderUid, data.wakeUpUid);
                                      selectedDateTime = data.wakeTime;
                                      selectedTime = TimeOfDay(
                                          hour: data.wakeTime.hour,
                                          minute: data.wakeTime.minute);
                                      setState(() => loading = true);
                                      Alarm.set(
                                              alarmSettings: buildAlarmSettings(
                                                  selectedTime))
                                          .then((res) {});
                                      setState(() => loading = false);
                                      context.goNamed(MainScreen.routeName);
                                    },
                                    icon: const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              );
                            });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: AppColors.rabbitalarm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WakeUpStatus(
                            AppLocalizations.of(context)!.wakeupmenotapproved),
                        const Image(
                          image: AssetImage('assets/images/rabbitalarm.jpeg'),
                          height: 220,
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) {
                logger.e(err);

                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.erroruser,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              })),
    );
  }
}

class WakeUpStatus extends StatelessWidget {
  final String wakeUpStatusMessage;
  const WakeUpStatus(this.wakeUpStatusMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(4, 4))
          ]),
      child: Text(wakeUpStatusMessage).p(10),
    ).pSymmetric(h: 10, v: 10);
  }
}
