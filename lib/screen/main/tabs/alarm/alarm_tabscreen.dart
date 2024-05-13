import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:alarm/alarm.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/core/widgets/alarm_tile.dart';
import 'package:wakeuphoney/features/oldalarm/alarm_edit_screen.dart';
import 'package:wakeuphoney/features/oldalarm/alarm_ring_screen.dart';
import 'package:wakeuphoney/features/oldauth/user_model.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_controller.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_model.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_tabscreen.dart';

/// 이 페이지의 역할
///
///
class AlarmTabScreen extends ConsumerStatefulWidget {
  static const routeName = '/alarm';
  static const routeUrl = '/alarm';
  const AlarmTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmTabScreenState();
}

class _AlarmTabScreenState extends ConsumerState<AlarmTabScreen> {
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  late DateTime selectedDateTime;
  late TimeOfDay selectedTime;
  late String audioAssetPath = 'assets/sounds/marimba.mp3';
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late bool showNotification;
  late String assetAudio;

  Logger logger = Logger();

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
    assetAudio = 'assets/sounds/marimba.mp3';

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
    logger.d(alarms.toList().toString());
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
      notificationTitle: 'wakeupgomalarm'.tr(),
      notificationBody: 'alarmringletter'.tr(),
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
    final user = ref.watch(userModelProvider);
    final friend = ref.watch(friendUserModelProvider);
    if (user == null) {
      return const CircularProgressIndicator();
    }
    final myAlarm = ref.watch(wakeListStreamProvider);
    return myAlarm.when(
      data: (alarm) {
        if (alarm.isEmpty) {
          return EmptyAlarm(user: user);
        }
        return Column(
          children: [
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
            AlarmList(ref, alarm: alarm, user: user),
          ],
        );
      },
      error: streamError, // Define the 'error' variable
      //나중에 글로벌 에러 핸들링으로 변경
      loading: () => const CircularProgressIndicator(), // Define the 'loading' variable
      // 나ㅇ에 글로벌 로딩 페이지으로 변경
    );
  }

  Widget streamError(error, stackTrace) => Text('Error: $error');
}

class AlarmMyTile extends StatelessWidget {
  const AlarmMyTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('AlarmMyTile'),
      onTap: () {
        context.go('/main/alarm');
      },
    );
  }
}

class AlarmList extends StatelessWidget {
  final List<WakeModel> alarm;
  final UserModel user;
  final WidgetRef ref;
  const AlarmList(this.ref, {required this.alarm, required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.deviceHeight - 200,
      child: ListView.builder(
        itemCount: alarm.length,
        itemBuilder: (context, index) {
          final wake = alarm[index];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.whiteBackground,
              border: Border.all(color: AppColors.point700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                wake.isApproved ? AcceptedBox(user, wake) : AcceptBox(user, wake),
                height10,
                FeedBox(user, wake),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
        DateFormat('a hh:mm').format(widget.wake.wakeTime).toString().text.bold.color(AppColors.primary700).make(),
        Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
        '이때 깨워줄게요!'.text.bold.make(),
        height10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalButton(
              text: '거절하기',
              onPressed: () {
                ref.read(wakeControllerProvider.notifier).deleteWakeUp(widget.wake.wakeUid);
              },
              isPreferred: false,
            ),
            width10,
            NormalButton(
              text: '승낙하기',
              onPressed: () {
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

class AcceptedBox extends ConsumerWidget {
  final UserModel user;
  final WakeModel wake;
  const AcceptedBox(
    this.user,
    this.wake, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DateFormat('a hh:mm').format(wake.wakeTime).toString().text.bold.color(AppColors.primary700).make(),
        Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
        '이때 깨워줄게요!'.text.bold.make(),
        height10,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     NormalButton(
        //       text: '거절하기',
        //       onPressed: () {
        //         ref.read(wakeControllerProvider.notifier).deleteWakeUp(wake.wakeUid);
        //       },
        //       isPreferred: false,
        //     ),
        //     width10,
        //     NormalButton(
        //       text: '승낙하기',
        //       onPressed: () {
        //         ref.read(wakeControllerProvider.notifier).acceptWakeUp(wake.wakeUid);
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class FeedBox extends StatelessWidget {
  final UserModel user;
  final WakeModel wake;
  const FeedBox(
    this.user,
    this.wake, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteBackground.withOpacity(0.1),
        border: Border.all(color: AppColors.point700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          NameBar(user),
          TimeBar(wake),
          height10,
          TextMessageBox(wake.message),
          height10,
          ImageBlurBox(wake.messagePhoto),
        ],
      ),
    );
  }
}

class EmptyAlarm extends StatelessWidget {
  const EmptyAlarm({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: () {
        if (user.couples!.isEmpty) {
          context.go('/main/match');
        } else {
          context.go('/main/wake');
          context.showSnackbar('깨우러 가기');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/aiphotos/awakebear.png",
            width: Constants.emptyPagePngWidth,
          ),
          height20,
          user.couples != null
              ? user.couples!.isEmpty
                  ? '상대와 연결해주세요'.text.size(18).bold.make()
                  : '상대가 아직 깨워주지 않았어요!'.text.size(18).bold.make()
              : '로그인 실패했습니다. 다시 시도해주세요.'.text.color(Colors.red).size(18).bold.make(),
          height40,
        ],
      ),
    );
  }
}
