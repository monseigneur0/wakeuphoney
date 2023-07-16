import 'package:alarm/alarm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/common/loader.dart';
import '../../core/providers/providers.dart';
import '../dailymessages/daily_controller.dart';
import '../dailymessages/response_screen.dart';

class AlarmRingScreen extends ConsumerWidget {
  final AlarmSettings alarmSettings;

  static String routeName = "alarmring";
  static String routeURL = "/alarmring";
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
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Text(
            //   "You alarm (${alarmSettings.id}) is ringing...",
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
            ref.watch(getDailyCoupleMessageProvider(dateList100[0])).when(
                  data: (message) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: message.photo.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: message.photo,
                                    placeholder: (context, url) => Container(
                                      height: 70,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : Container(),
                          ),
                          Text(
                            message.message,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    // print("error");

                    return Column(
                      children: const [
                        SizedBox(
                          height: 50,
                        ),
                        Text("no letter..."),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    );
                    // ErrorText(
                    //     error: DateFormat.yMMMd().format(listDateTime[0]));
                  },
                  loading: () => const Loader(),
                ),
            // const Text("🔔", style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // RawMaterialButton(
                //   onPressed: () {
                //     final now = DateTime.now();
                //     Alarm.set(
                //       alarmSettings: alarmSettings.copyWith(
                //         dateTime: DateTime(
                //           now.year,
                //           now.month,
                //           now.day,
                //           now.hour,
                //           now.minute,
                //           0,
                //           0,
                //         ).add(const Duration(minutes: 1)),
                //       ),
                //     ).then((_) => Navigator.pop(context));
                //   },
                //   child: Text(
                //     "Snooze",
                //     style: Theme.of(context).textTheme.titleLarge,
                //   ),
                // ),
                RawMaterialButton(
                  onPressed: () {
                    Alarm.stop(alarmSettings.id)
                        .then((_) => Navigator.pop(context))
                        .then((_) => context.goNamed(ResponseScreen.routeName));
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
