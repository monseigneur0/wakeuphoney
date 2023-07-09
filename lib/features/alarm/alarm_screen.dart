import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/alarm_tile.dart';
import 'alarm_edit_screen.dart';
import 'alarm_ring_screen.dart';

final alarmSettingsProvider = StateProvider<AlarmSettings>((ref) =>
    AlarmSettings(
        id: 112,
        dateTime: DateTime.now(),
        assetAudioPath: 'assets/mozart.mp3'));

class AlarmHome extends ConsumerStatefulWidget {
  static String routeName = "alarm";
  static String routeURL = "/alarm";
  const AlarmHome({super.key});

  @override
  AlarmHomeState createState() => AlarmHomeState();
}

class AlarmHomeState extends ConsumerState<AlarmHome> {
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    setState(() {});
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }
  // Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
  //   await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
  //       ));
  //   loadAlarms();
  // }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: ExampleAlarmEditScreen(alarmSettings: settings),
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
    if (res != null && res == true) loadAlarms();
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
          title: const Text(
            'alarm home wake up',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.amber),
      body: SafeArea(
          child: alarms.isNotEmpty
              ? ListView.separated(
                  itemCount: alarms.length,
                  separatorBuilder: (context, index) => const Divider(),
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
                )
              : const Center(
                  child: Text(
                    'No alarms set',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => ringnow(),
              icon: const Icon(
                Icons.add_alarm,
                size: 33,
              ),
            ),
            IconButton(
              onPressed: () => Alarm.stop(42),
              icon: const Icon(
                Icons.cancel,
                size: 33,
              ),
            ),
            IconButton(
              onPressed: () => navigateToAlarmScreen(null),
              icon: const Icon(
                Icons.add,
                size: 33,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void ringnow() {
  final alarmSettingNow = AlarmSettings(
    id: 42,
    dateTime: DateTime.now(),
    assetAudioPath: 'assets/mozart.mp3',
  );
  Alarm.set(
    alarmSettings: alarmSettingNow,
  );
}
