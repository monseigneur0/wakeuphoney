import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/common/error_text.dart';
import '../../core/common/loader.dart';
import '../dailymessages/daily_controller.dart';
import '../messages/messages_screen.dart';

class AlarmRingScreen extends ConsumerWidget {
  final AlarmSettings alarmSettings;
  const AlarmRingScreen({
    super.key,
    required this.alarmSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateList100 = ref.watch(dateStateProvider);
    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "You alarm (${alarmSettings.id}) is ringing...",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ref.watch(getDailyMessageProvider(dateList100[0])).when(
                  data: (message) {
                    return Text(
                        "${DateFormat.yMMMd().format(listDateTime[0])}     ${message.message}");
                  },
                  error: (error, stackTrace) {
                    print("error");

                    return ErrorText(
                        error:
                            "${DateFormat.yMMMd().format(listDateTime[0])}                              ");
                  },
                  loading: () => const Loader(),
                ),
            const Text("🔔", style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: alarmSettings.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                          0,
                          0,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  child: Text(
                    "Snooze",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    Alarm.stop(alarmSettings.id)
                        .then((_) => Navigator.pop(context));
                  },
                  child: Text(
                    "Stop",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
