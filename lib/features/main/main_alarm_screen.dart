import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/constants/design_constants.dart';
import '../../widgets/alarm_tile.dart';
import '../alarm/alarm_edit_screen.dart';
import '../alarm/alarm_new_ring_screen.dart';
import '../alarm/alarm_ring_screen.dart';
import '../wakeup/wakeup_me_screen.dart';
import '../wakeup/wakeup_you_screen.dart';

class MainAlarmHome extends StatefulWidget {
  static String routeName = "mainalarm";
  static String routeURL = "/mainalarm";
  const MainAlarmHome({super.key});

  @override
  MainAlarmHomeState createState() => MainAlarmHomeState();
}

class MainAlarmHomeState extends State<MainAlarmHome> {
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidExternalStoragePermission();
    }
    loadAlarms();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.alarms,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () => navigateToAlarmScreen(null),
            onLongPress: () => context.pushNamed(AlarmNewScreen.routeName),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: ImageIcon(
                AssetImage('assets/alarm-clock.png'),
                size: 29,
                color: AppColors.myPink,
              ),
            ),
          ),
          // IconButton(
          //   onPressed: () => context.pushNamed(AlarmNewScreen.routeName),
          //   icon: const ImageIcon(
          //     AssetImage('assets/alarm-clock.png'),
          //     size: 29,
          //     color: AppColors.myPink,
          //   ),
          // ),
        ],
      ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       flex: 1,
      //       child: alarms.isNotEmpty
      //           ? ListView.builder(
      //               itemCount: alarms.length,
      //               // separatorBuilder: (context, index) => const Divider(),
      //               itemBuilder: (context, index) {
      //                 return AlarmTile(
      //                   key: Key(alarms[index].id.toString()),
      //                   title: TimeOfDay(
      //                     hour: alarms[index].dateTime.hour,
      //                     minute: alarms[index].dateTime.minute,
      //                   ).format(context),
      //                   onPressed: () => navigateToAlarmScreen(alarms[index]),
      //                   onDismissed: () {
      //                     Alarm.stop(alarms[index].id)
      //                         .then((_) => loadAlarms());
      //                   },
      //                 );
      //               },
      //             )
      //           : Column(
      //               children: [
      //                 SizedBox(height: MediaQuery.of(context).size.height / 5),
      //                 Center(
      //                   child: Text(
      //                     AppLocalizations.of(context)!.noalarmset,
      //                     style: const TextStyle(
      //                       fontSize: 30,
      //                       color: Colors.black,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //     ),
      //   ],
      // ),
      body: Column(children: [
        const Flexible(
          flex: 3,
          child: WakeUpMeScreen(),
        ),
        // const Flexible(
        //   flex: 3,
        //   child: WakeUpYouScreen(),
        // ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.yellow,
            child: Center(child: "여긴 광고에요".text.make()),
          ),
        ),
      ]),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 100, right: 10),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       ExampleMainAlarmHomeShortcutButton(refreshAlarms: loadAlarms),
      //       // FloatingActionButton(
      //       //   onPressed: () => navigateToAlarmScreen(null),
      //       //   backgroundColor: AppColors.myPink,
      //       //   child: const ImageIcon(
      //       //     AssetImage('assets/alarm-clock.png'),
      //       //     size: 29,
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

void ringnow() {
  final alarmSettingNow = AlarmSettings(
    id: 42,
    dateTime: DateTime.now(),
    assetAudioPath: 'assets/mozart.mp3',
    volume: 0.5,
    notificationTitle: 'Alarm example',
    notificationBody: 'Shortcut button alarm with delay of n hours',
  );
  Alarm.set(
    alarmSettings: alarmSettingNow,
  );
}
