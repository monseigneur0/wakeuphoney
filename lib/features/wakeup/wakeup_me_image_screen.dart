import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:wakeuphoney/features/wakeup/wakeup_controller.dart';

import '../../core/constants/design_constants.dart';
import '../main/main_screen.dart';
import 'wakeup_status.dart';

class WakeUpMeImageScreen extends ConsumerStatefulWidget {
  const WakeUpMeImageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WakeUpMeImageScreenState();
}

class _WakeUpMeImageScreenState extends ConsumerState<WakeUpMeImageScreen> {
  late String audioAssetPath = 'assets/marimba.mp3';
  bool loading = false;

  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late bool showNotification;
  late String assetAudio;

  late List<bool> days;

  late DateTime selectedDateTime;
  late TimeOfDay selectedTime;

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

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    int minusBottom = 110;
    final wakeUpMe = ref.watch(getTomorrowWakeUpMeProvider);
    bool isApproved = false;
    return RefreshIndicator(
        onRefresh: () async {
          ref.watch(getTomorrowWakeUpMeProvider);
        },
        child: SingleChildScrollView(
          child: wakeUpMe.when(
              data: (data) {
                if (data.letter.isEmpty || data.letter == "") {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height - minusBottom,
                    color: AppColors.rabbitwake,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //상대가 아직 깨워주지 않았어요
                        100.heightBox,
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
                if (data.isApproved == true || isApproved == true) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height:
                        //     MediaQuery.of(context).size.height - minusBottom,
                        color: AppColors.rabbitspeak,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              100.heightBox,
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
                    if (data.letterAudio.isNotEmpty || data.letterAudio != "") {
                      saveToFile(data.letterAudio);
                    }

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
                                    setState(() {
                                      loading = true;
                                      isApproved = true;
                                    });
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
                                      setState(() {
                                        loading = true;
                                        isApproved = true;
                                      });
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
                    // height: MediaQuery.of(context).size.height - minusBottom,
                    color: AppColors.rabbitalarm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        100.heightBox,
                        WakeUpStatus(
                            AppLocalizations.of(context)!.wakeupmenotapproved),
                        const Image(
                          image: AssetImage('assets/images/rabbitalarm.jpeg'),
                          height: 220,
                        ),
                        if (kDebugMode)
                          Text(
                            "w1ow this is kDebugMode2 ${data.toString()}",
                            style: const TextStyle(fontSize: 20),
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
              }),
        ));
  }
}
