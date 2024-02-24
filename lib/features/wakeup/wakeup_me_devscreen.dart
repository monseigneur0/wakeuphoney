import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:alarm/alarm.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/main/main_screen.dart';

import '../../core/constants/design_constants.dart';
import '../alarm/alarm_day_settings.dart';
import 'wakeup_controller.dart';
import 'wakeup_status.dart';

class WakeUpMeDevScreen extends ConsumerStatefulWidget {
  final AlarmSettings? alarmSettings;

  const WakeUpMeDevScreen({super.key, this.alarmSettings});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WakeUpMeDevScreenState();
}

class _WakeUpMeDevScreenState extends ConsumerState<WakeUpMeDevScreen> {
  bool loading = false;

  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late bool showNotification;
  late String assetAudio;
  late String audioAssetPath = 'assets/marimba.mp3';

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

  AlarmSettings buildAlarmSettings(TimeOfDay selectedTime1, String audioPath) {
    final now = DateTime.now();
    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    saveToFile(audioPath);
    logger.d(audioPath);
    logger.d(audioAssetPath);

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
      assetAudioPath: audioAssetPath,
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

  // 파일 경로를 생성하는 함수
  Future<File> _getFile(String fileName) async {
    // 앱의 디렉토리 경로를 가져옴
    final directory = await getApplicationDocumentsDirectory();
    // 파일 경로와 파일 이름을 합쳐서 전체 파일 경로를 만듬
    return File('${directory.path}/$fileName');
  }

  // 파일을 저장하는 함수
  Future<String> saveToFile(String audioUrl) async {
    // 파일 경로를 생성함
    final directory = await getApplicationDocumentsDirectory();

    final fileName = audioUrl.split('-').last;

    audioAssetPath = '${directory.path}/$fileName';

    final file = File(audioAssetPath);
    // 파일에 내용을 저장함
    logger.d(audioAssetPath);
    var response = await http.get(Uri.parse(audioUrl));

    await file.writeAsBytes(response.bodyBytes);
    return audioAssetPath;
  }

  //파일을 불러오는 함수
  Future<String> _loadFile(String fileName) async {
    try {
      //파일을 불러옴
      final file = await _getFile(fileName);
      //불러온 파일의 데이터를 읽어옴
      String fileContents = await file.readAsString();
      return fileContents;
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    final wakeMeUp = ref.watch(getTomorrowWakeUpMeProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(AppLocalizations.of(context)!.wakeupbear),
      // ),
      body: Center(
          child: wakeMeUp.when(
              data: (data) {
                logger.d(data);
                if (data.letter.isEmpty || data.letter == "") {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: AppColors.rabbitwake,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //상대가 아직 깨워주지 않았어요
                        WakeUpStatus(
                            AppLocalizations.of(context)!.wakeupmenotyet),
                        const Image(
                          image: AssetImage('assets/images/rabbitwake.jpeg'),
                          height: 220,
                          opacity: AlwaysStoppedAnimation<double>(0.3),
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
                              ),
                            ])),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    saveToFile(data.letterAudio);

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
                                                selectedTime, data.letterAudio))
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
                                                  selectedTime,
                                                  data.letterAudio))
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
                        if (kDebugMode)
                          Text("wow this is kDebugMode2 ${data.toString()}"),
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
