import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:alarm/alarm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/common/common.dart';
import 'package:path_provider/path_provider.dart';

import '../alarm/alarm_day_settings.dart';

import '../main/main_screen.dart';
import '../profile/profile_controller.dart';
import 'wakeup_controller.dart';
import 'wakeup_status.dart';

class WakeUpMeScreen extends ConsumerStatefulWidget {
  final AlarmSettings? alarmSettings;

  const WakeUpMeScreen({super.key, this.alarmSettings});

  @override
  ConsumerState createState() => WakeUpMeScreenState();
}

class WakeUpMeScreenState extends ConsumerState<WakeUpMeScreen> {
  bool loading = false;

  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late bool showNotification;
  late String assetAudio;
  late String audioAssetPath = 'assets/marimba.mp3';

  late List<bool> days;

  late AlarmDaySettings alarmDaySettings = AlarmDaySettings(alarmSettings: widget.alarmSettings);

  late TimeOfDay selectedTime;
  late Time _time;
  var logger = Logger();

  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    selectedDateTime = DateTime.now().add(const Duration(minutes: 10)).copyWith(second: 0, millisecond: 0);
    selectedTime = TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute);
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

    // loadAlarms();
    // subscription ??= Alarm.ringStream.stream.listen(
    //   (alarmSettings) => navigateToRingScreen(alarmSettings),
    // );
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
    final wakeUpMe = ref.watch(getTomorrowWakeUpMeProvider);
    final userInfo = ref.watch(getUserProfileStreamProvider);
    bool isApproved = false;
    DateTime now = DateTime.now();
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            ref.watch(getTomorrowWakeUpMeProvider);
          },
          child: userInfo.when(
              data: (user) {
                return wakeUpMe.when(
                  data: (letters) {
                    if (letters.letter.isEmpty || letters.letter == "") {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: AppColors.rabbitwake,
                        child: Column(
                          children: [
                            100.heightBox,
                            Material(
                              child: Stack(
                                children: [
                                  Container(
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            user.uid == letters.senderUid
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: CachedNetworkImage(width: 45, imageUrl: user.photoURL))
                                                : ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: CachedNetworkImage(
                                                        width: 45, imageUrl: user.couplePhotoURL ?? user.photoURL)),
                                            10.widthBox,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width - 120,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      user.uid == letters.senderUid
                                                          ? user.displayName.text.size(14).bold.make()
                                                          : user.coupleDisplayName!.text.size(14).bold.make(),
                                                      Expanded(
                                                        child: Container(),
                                                      ),
                                                      DateFormat("HH:mm")
                                                          .format(DateTime(now.year, now.month, now.day))
                                                          .toString()
                                                          .text
                                                          .size(20)
                                                          .make()
                                                          .pSymmetric(h: 14),
                                                      PopupMenuButton(
                                                        itemBuilder: (context) {
                                                          if (letters.wakeTime.isBefore(DateTime.now())) {
                                                            return [
                                                              PopupMenuItem(
                                                                onTap: () {
                                                                  showToast(AppLocalizations.of(context)!.nodeletepast);
                                                                },
                                                                child: Text(AppLocalizations.of(context)!.delete),
                                                              ),
                                                            ];
                                                          }
                                                          return [
                                                            PopupMenuItem(
                                                              onTap: () {},
                                                              child: Text(AppLocalizations.of(context)!.edit),
                                                            ),
                                                            PopupMenuItem(
                                                              onTap: () {
                                                                ref
                                                                    .watch(wakeUpControllerProvider.notifier)
                                                                    .letterDelete(letters.wakeUpUid);
                                                                showToast(AppLocalizations.of(context)!.deleted);
                                                              },
                                                              child: Text(AppLocalizations.of(context)!.delete),
                                                            ),
                                                          ];
                                                        },
                                                      ).box.height(32).make(),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width - 140,
                                                  child: SelectableText(
                                                      scrollPhysics: const NeverScrollableScrollPhysics(),
                                                      letters.letter),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const Image(
                                          image: AssetImage('assets/images/rabbitwake.png'),
                                          height: Constants.pngSize,
                                          opacity: AlwaysStoppedAnimation<double>(0.3),
                                        ),
                                        WakeUpStatus(AppLocalizations.of(context)!.wakeupmenotyet),
                                        20.heightBox,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            letters.letterPhoto.isEmpty
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.grey,
                                                    ),
                                                    child: const Text("사진").p(10),
                                                  )
                                                : Container(
                                                    width: MediaQuery.of(context).size.width - 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.grey,
                                                    ),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: CachedNetworkImage(
                                                      imageUrl: letters.letterPhoto.toString(),
                                                      placeholder: (context, url) => Container(
                                                        height: 70,
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: MediaQuery.of(context).size.width - 90,
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    ),
                                                  ),
                                            letters.letterPhoto.isEmpty
                                                ? Container(
                                                    child: const Text("글"),
                                                  )
                                                : Container(
                                                    width: MediaQuery.of(context).size.width - 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.grey,
                                                    ),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: CachedNetworkImage(
                                                      imageUrl: letters.letterPhoto.toString(),
                                                      placeholder: (context, url) => Container(
                                                        height: 70,
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: MediaQuery.of(context).size.width - 90,
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    ),
                                                  ),
                                            letters.letterAudio.isEmpty
                                                ? Container(
                                                    child: const Text("음성"),
                                                  )
                                                : Container(
                                                    width: MediaQuery.of(context).size.width - 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.grey,
                                                    ),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: CachedNetworkImage(
                                                      imageUrl: letters.letterPhoto.toString(),
                                                      placeholder: (context, url) => Container(
                                                        height: 70,
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: MediaQuery.of(context).size.width - 90,
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ).p(10),
                                  ).pSymmetric(h: 20, v: 10),
                                  // Container(
                                  //   height: 295,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(20),
                                  //     color: Colors.black.withOpacity(0.2),
                                  //   ),
                                  // ).pSymmetric(h: 20, v: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (letters.isApproved == true || isApproved == true) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: AppColors.rabbitspeak,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              100.heightBox,
                              WakeUpStatus(AppLocalizations.of(context)!.wakeupmeapproved),
                              Text(
                                  "${DateFormat('HH:mm').format(letters.wakeTime)}${AppLocalizations.of(context)!.wakeupmeat}"),
                              const Image(
                                image: AssetImage('assets/images/rabbitspeak.png'),
                                height: 220,
                              ),
                            ])),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        if (letters.letterAudio.isNotEmpty || letters.letterAudio != "") {
                          saveToFile(letters.letterAudio);
                        }

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
                                        ref
                                            .watch(wakeUpControllerProvider.notifier)
                                            .wakeUpAprove(letters.reciverUid, letters.senderUid, letters.wakeUpUid);
                                        selectedDateTime = letters.wakeTime;
                                        selectedTime =
                                            TimeOfDay(hour: letters.wakeTime.hour, minute: letters.wakeTime.minute);
                                        setState(() {
                                          loading = true;
                                          isApproved = true;
                                        });
                                        Alarm.set(alarmSettings: buildAlarmSettings(selectedTime, letters.letterAudio))
                                            .then((res) {});
                                        setState(() => loading = false);
                                        context.goNamed(MainScreen.routeName);
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
                                          ref
                                              .watch(wakeUpControllerProvider.notifier)
                                              .wakeUpAprove(letters.reciverUid, letters.senderUid, letters.wakeUpUid);
                                          selectedDateTime = letters.wakeTime;
                                          selectedTime =
                                              TimeOfDay(hour: letters.wakeTime.hour, minute: letters.wakeTime.minute);
                                          setState(() {
                                            loading = true;
                                            isApproved = true;
                                          });
                                          Alarm.set(
                                                  alarmSettings: buildAlarmSettings(selectedTime, letters.letterAudio))
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
                        color: AppColors.rabbitalarm,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            100.heightBox,
                            WakeUpStatus(AppLocalizations.of(context)!.wakeupmenotapproved),
                            const Image(
                              image: AssetImage('assets/images/rabbitalarm.png'),
                              height: 220,
                            ),
                            if (kDebugMode)
                              Text(
                                "w1ow this is kDebugMode2 ${letters.toString()}",
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
                  },
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

class Wowjustimage extends StatelessWidget {
  const Wowjustimage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 110,
      color: AppColors.sleepingbear,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //상대가 아직 깨워주지 않았어요
          100.heightBox,
          WakeUpStatus(AppLocalizations.of(context)!.wakeupmenotyet),
          const Image(
            image: AssetImage('assets/images/rabbitwake.png'),
            height: 220,
            opacity: AlwaysStoppedAnimation<double>(0.3),
          )
        ],
      )),
    );
  }
}
