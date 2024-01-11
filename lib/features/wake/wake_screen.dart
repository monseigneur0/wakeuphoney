import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'wake_edit_screen.dart';

class WakeScreen extends ConsumerStatefulWidget {
  const WakeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeScreenState();
}

class _WakeScreenState extends ConsumerState<WakeScreen> {
  late List<AlarmSettings> alarms;

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.7,
          child: WakeEditScreen(),
        );
      },
    );
    if (res != null && res == true) loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('깨워볼까요?'),
      ),
      body: Container(
        child: Center(
            child: GestureDetector(
          onTap: () => navigateToAlarmScreen(null),
        )),
      ),
    );
  }
}
