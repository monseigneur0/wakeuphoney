import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakeuphoney/app.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_edit_screen.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_ring_sample.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_ring_screen.dart';

class AlarmFunction extends StatefulWidget {
  const AlarmFunction({super.key});

  @override
  State<AlarmFunction> createState() => _AlarmFunctionState();
}

class _AlarmFunctionState extends State<AlarmFunction> {
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidExternalStoragePermission();
    }

    if (subscription != null) {
      subscription?.cancel();
    }

    // loadAlarms();
    // subscription ??= Alarm.ringStream.stream.listen(
    //   (alarmSettings) => navigateToRingScreen(alarmSettings),
    // );
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
          builder: (context) => AlarmRingSampleScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
    // await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
    //   ),
    // );
    // loadAlarms();
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
    return const App();
  }
}
