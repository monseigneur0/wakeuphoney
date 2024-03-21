import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:alarm/alarm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/common/common.dart';
import '../../core/providers/providers.dart';
import '../main/main_screen.dart';
import '../profile/profile_controller.dart';
import 'wakeup_controller.dart';
import 'wakeup_status.dart';

class WakeUpMeAlarmScreen extends ConsumerStatefulWidget {
  const WakeUpMeAlarmScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeUpMeAlarmScreenState();
}

class _WakeUpMeAlarmScreenState extends ConsumerState<WakeUpMeAlarmScreen> {
  Logger logger = Logger();

  bool loading = false;
  bool isApproved = false;
  late DateTime selectedDateTime;
  late TimeOfDay selectedTime;
  late String audioAssetPath = 'assets/marimba.mp3';
  late bool loopAudio;
  late bool vibrate;
  late double? volume;

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
    final userInfo = ref.watch(getUserProfileStreamProvider);
    final wakeUpMeAlarm = ref.watch(wakeUpMeAlarmProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Wake Up Me Alarm'),
      ),
      body: userInfo.when(
          data: (user) {
            return wakeUpMeAlarm.when(
                data: (alarm) {
                  if (user.couple == null || user.couple!.isEmpty || user.couple! == "") {
                    return Container(
                      child: const Center(
                        child: Text("You don't have a couple yet."),
                      ),
                    );
                  }
                  if (alarm.isEmpty) {
                    return Container(
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
                        ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    width: 45,
                                    imageUrl: user.couplePhotoURL ??
                                        "https://firebasestorage.googleapis.com/v0/b/wakeuphoneys2.appspot.com/o/images%2F2024-01-08%2019:23:12.693630?alt=media&token=643f9416-0203-4e75-869a-ea0240e14ca4",
                                  ),
                                ).p(10),
                                user.coupleDisplayName!.text.make(),
                                Expanded(
                                  child: Container(),
                                ),
                                const ImageIcon(
                                  AssetImage('assets/alarm-clock.png'),
                                  size: 29,
                                  // color: AppColors.myPink,
                                ),
                                DateFormat("HH:mm")
                                    .format(DateTime.now().toLocal())
                                    .toString()
                                    .text
                                    .bold
                                    .size(18)
                                    .make()
                                    .pSymmetric(h: 14),
                              ],
                            ),
                            const Image(
                              image: AssetImage('assets/images/rabbitwake.png'),
                              height: Constants.pngSize,
                              opacity: AlwaysStoppedAnimation<double>(0.3),
                            ),
                            WakeUpStatus(AppLocalizations.of(context)!.wakeupmenotyet),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: const Text("사진").p(10),
                                ),
                                Container(
                                  child: const Text("글"),
                                ),
                                Container(
                                  child: const Text("음성"),
                                ),
                              ],
                            ),
                            10.heightBox
                          ],
                        )).p(10);
                  }
                  return GestureDetector(
                    onTap: () {},
                    child: ListView.builder(
                      itemCount: alarm.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Platform.isIOS
                                ? showCupertinoDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text(AppLocalizations.of(context)!.alarm),
                                      content: Text(AppLocalizations.of(context)!.wakeupmenotapproved),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text(AppLocalizations.of(context)!.no),
                                        ),
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            ref.watch(wakeUpControllerProvider.notifier).wakeUpAprove(
                                                alarm[index].reciverUid,
                                                alarm[index].senderUid,
                                                alarm[index].wakeUpUid);
                                            selectedDateTime = alarm[index].wakeTime;
                                            selectedTime = TimeOfDay(
                                                hour: alarm[index].wakeTime.hour, minute: alarm[index].wakeTime.minute);
                                            setState(() {
                                              loading = true;
                                              isApproved = true;
                                            });
                                            Alarm.set(
                                                    alarmSettings:
                                                        buildAlarmSettings(selectedTime, alarm[index].letterAudio))
                                                .then((res) {});
                                            setState(() => loading = false);
                                          },
                                          isDestructiveAction: true,
                                          child: Text(AppLocalizations.of(context)!.yes),
                                        ),
                                      ],
                                    ),
                                  )
                                : showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(AppLocalizations.of(context)!.alarm),
                                        content: Text(AppLocalizations.of(context)!.wakeupmenotapproved),
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
                                              ref.watch(wakeUpControllerProvider.notifier).wakeUpAprove(
                                                  alarm[index].reciverUid,
                                                  alarm[index].senderUid,
                                                  alarm[index].wakeUpUid);
                                              selectedDateTime = alarm[index].wakeTime;
                                              selectedTime = TimeOfDay(
                                                  hour: alarm[index].wakeTime.hour,
                                                  minute: alarm[index].wakeTime.minute);
                                              setState(() {
                                                loading = true;
                                                isApproved = true;
                                              });
                                              Alarm.set(
                                                      alarmSettings:
                                                          buildAlarmSettings(selectedTime, alarm[index].letterAudio))
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
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(8, 8))
                                  ]),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          width: 45,
                                          imageUrl: user.couplePhotoURL ??
                                              "https://firebasestorage.googleapis.com/v0/b/wakeuphoneys2.appspot.com/o/images%2F2024-01-08%2019:23:12.693630?alt=media&token=643f9416-0203-4e75-869a-ea0240e14ca4",
                                        ),
                                      ).p(10),
                                      user.coupleDisplayName!.text.make(),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      const ImageIcon(
                                        AssetImage('assets/alarm-clock.png'),
                                        size: 29,
                                        // color: AppColors.myPink,
                                      ),
                                      DateFormat("HH:mm")
                                          .format(alarm[index].wakeTime)
                                          .toString()
                                          .text
                                          .bold
                                          .size(18)
                                          .make()
                                          .pSymmetric(h: 14),
                                    ],
                                  ),
                                  const Image(
                                    image: AssetImage('assets/images/rabbitwake.png'),
                                    height: Constants.pngSize,
                                    opacity: AlwaysStoppedAnimation<double>(0.3),
                                  ),
                                  WakeUpStatus(AppLocalizations.of(context)!.wakeupmenotapproved),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      alarm[index].letterPhoto.isEmpty
                                          ? const NoAlarmelblock("사진")
                                          : const Alarmelblock("사진"),
                                      alarm[index].letter.isEmpty ? const NoAlarmelblock("글") : const Alarmelblock("글"),
                                      alarm[index].letterAudio.isEmpty
                                          ? const NoAlarmelblock("음성")
                                          : const Alarmelblock("음성"),
                                    ],
                                  ),
                                  10.heightBox
                                ],
                              )).p(10),
                        );
                      },
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
                });
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
    );
  }
}

class Alarmelblock extends StatelessWidget {
  final String text;
  const Alarmelblock(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.myPink.withOpacity(0.7),
      ),
      child: Text(text).p(10),
    );
  }
}

class NoAlarmelblock extends StatelessWidget {
  final String text;
  const NoAlarmelblock(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: Text(text).p(10),
    );
  }
}
