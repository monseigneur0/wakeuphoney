import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/widget/alarm_tile.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_edit_screen.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_ring_sample.dart';

class AlarmManager extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmManager({
    super.key,
    required this.alarmSettings,
  });

  @override
  State<AlarmManager> createState() => _AlarmManagerState();
}

class _AlarmManagerState extends State<AlarmManager> {
  late List<AlarmSettings> alarms;
  // static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    // if (subscription != null) {
    //   subscription?.cancel();
    // }
    // subscription ??= Alarm.ringStream.stream.listen(
    //   (alarmSettings) => navigateToRingScreen(alarmSettings),
    // );
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlarmRingSampleScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    // final res = await showModalBottomSheet<bool?>(
    //   context: context,
    //   isScrollControlled: true,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    //   builder: (context) {
    //     return FractionallySizedBox(
    //       heightFactor: 0.7,
    //       child: AlarmEditScreen(alarmSettings: settings),
    //     );
    //   },
    // );
    // if (res != null && res == true) loadAlarms();
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return !kDebugMode
        ? Container()
        : SizedBox(
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
          );
  }
}
