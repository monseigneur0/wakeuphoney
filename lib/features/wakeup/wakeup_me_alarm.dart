import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:alarm/alarm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/common/common.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/alarm_tile.dart';
import '../alarm/alarm2_shortcut.dart';
import '../alarm/alarm_edit_screen.dart';
import '../alarm/alarm_ring_screen.dart';
import '../main/main_screen.dart';
import '../profile/profile_controller.dart';
import 'wakeup_controller.dart';
import 'wakeup_status.dart';
import 'wakeup_you_screen.dart';

class WakeUpMeAlarmScreen extends ConsumerStatefulWidget {
  const WakeUpMeAlarmScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeUpMeAlarmScreenState();
}

class _WakeUpMeAlarmScreenState extends ConsumerState<WakeUpMeAlarmScreen> {
  Logger logger = Logger();

  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  bool loading = false;
  bool isApproved = false;
  late DateTime selectedDateTime;
  late TimeOfDay selectedTime;
  late String audioAssetPath = 'assets/marimba.mp3';
  late bool loopAudio;
  late bool vibrate;
  late double? volume;

  late bool showNotification;
  late String assetAudio;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidExternalStoragePermission();
    }

    selectedDateTime = DateTime.now().add(const Duration(minutes: 10)).copyWith(second: 0, millisecond: 0);
    selectedTime = TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute);
    loopAudio = true;
    vibrate = true;
    volume = null;
    showNotification = true;
    assetAudio = 'assets/marimba.mp3';

    loadAlarms();
    if (subscription != null) {
      subscription?.cancel();
    }
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
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

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: AlarmEditScreen(alarmSettings: settings),
        );
      },
    );
    if (res != null && res == true) loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(getUserProfileStreamProvider);
    final wakeUpMeAlarm = ref.watch(wakeUpMeAlarmProvider);

    bool noAlarm = false;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: (kDebugMode) ? const Text('Wake Up Me Alarm') : Text(AppLocalizations.of(context)!.wakeupgom),
        actions: const [],
      ),
      body: userInfo.when(
        data: (user) {
          return wakeUpMeAlarm.when(
              data: (alarm) {
                if (user.couple == null || user.couple!.isEmpty || user.couple! == "") {
                  return Container(
                    child: const Center(
                      child: Text("You don't have a friend yet."),
                    ),
                  );
                }
                if (alarm.isEmpty) {
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
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
                                  imageUrl: user.couplePhotoURL ?? Constants.userDefault,
                                ),
                              ).p(10),
                              user.coupleDisplayName!.text.make(),
                              Expanded(
                                child: Container(),
                              ),
                              ImageIcon(
                                const AssetImage('assets/alarm-clock.png'),
                                size: 29,
                                color: Colors.grey[400],
                              ),
                              "00:00".text.bold.gray400.size(18).make().pSymmetric(h: 14),
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
                if (!alarm.any((element) {
                  /// 하나라도 있으면 트루
                  /// 조건식을 리턴해야해.
                  return (element.reciverUid == user.uid && element.wakeTime.isAfter(DateTime.now()));
                })) {
                  logger.d("no alarm");
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
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
                                  imageUrl: user.couplePhotoURL ?? Constants.userDefault,
                                ),
                              ).p(10),
                              user.coupleDisplayName!.text.make(),
                              Expanded(
                                child: Container(),
                              ),
                              ImageIcon(
                                const AssetImage('assets/alarm-clock.png'),
                                size: 29,
                                color: Colors.grey[400],
                              ),
                              "00:00".text.bold.gray400.size(18).make().pSymmetric(h: 14),
                            ],
                          ),
                          const Image(
                            image: AssetImage('assets/images/rabbitwake.png'),
                            height: Constants.pngSize,
                            opacity: AlwaysStoppedAnimation<double>(0.3),
                          ),
                          WakeUpStatus(AppLocalizations.of(context)!.wakeupmenotyet),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NoAlarmelblock("사진"),
                              NoAlarmelblock("글"),
                              NoAlarmelblock("음성"),
                            ],
                          ),
                          10.heightBox
                        ],
                      )).p(10);
                } else {
                  logger.d("alarm!!!!");
                  return Column(
                    children: [
                      if (kDebugMode)
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: alarms.length,
                            // separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              return AlarmTile(
                                key: Key(alarms[index].id.toString()),
                                title: TimeOfDay(
                                  hour: alarms[index].dateTime.hour,
                                  minute: alarms[index].dateTime.minute,
                                ).format(context),
                                onPressed: () => navigateToAlarmScreen(alarms[index]),
                                onDismissed: () {
                                  Alarm.stop(alarms[index].id).then((_) => loadAlarms());
                                },
                              );
                            },
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: alarm.length,
                          itemBuilder: (context, index) {
                            // logger.d(
                            //     " $index ${alarm.length} ${alarm[index].reciverUid} ${user.uid} ${alarm[index].wakeTime} ${alarm[index].letter}");
                            if (alarm[index].reciverUid == user.uid && alarm[index].wakeTime.isAfter(DateTime.now())) {
                              logger.d("here");
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
                                                      hour: alarm[index].wakeTime.hour,
                                                      minute: alarm[index].wakeTime.minute);
                                                  setState(() {
                                                    loading = true;
                                                    isApproved = true;
                                                  });
                                                  Alarm.set(
                                                          alarmSettings: buildAlarmSettings(
                                                              selectedTime, alarm[index].letterAudio))
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
                                                            alarmSettings: buildAlarmSettings(
                                                                selectedTime, alarm[index].letterAudio))
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
                                                imageUrl: user.couplePhotoURL ?? Constants.userDefault,
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
                                          opacity: AlwaysStoppedAnimation<double>(0.6),
                                        ),
                                        WakeUpStatus(AppLocalizations.of(context)!.wakeupmenotapproved),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            alarm[index].letterPhoto.isEmpty
                                                ? const NoIconWakeUp(Icons.photo_size_select_actual_outlined)
                                                : const IconWakeUp(Icons.photo_size_select_actual_outlined),
                                            alarm[index].letter.isEmpty
                                                ? const NoIconWakeUp(Icons.email_outlined)
                                                : const IconWakeUp(Icons.email_outlined),
                                            alarm[index].letterAudio.isEmpty
                                                ? const NoIconWakeUp(Icons.voice_chat)
                                                : const IconWakeUp(Icons.voice_chat),
                                          ],
                                        ),
                                        10.heightBox
                                      ],
                                    )).p(10),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ],
                  );
                }
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
        },
      ),
      floatingActionButton: kDebugMode
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ExampleAlarmHomeShortcutButton(refreshAlarms: loadAlarms),
                  FloatingActionButton(
                    onPressed: () => navigateToAlarmScreen(null),
                    backgroundColor: AppColors.myPink,
                    child: const ImageIcon(
                      AssetImage('assets/alarm-clock.png'),
                      size: 29,
                    ),
                  ),
                ],
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
