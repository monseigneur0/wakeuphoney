import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  final String iOSTestId = 'ca-app-pub-5897230132206634/3120978311';
  final String androidTestId = 'ca-app-pub-3940256099942544/6300978111';

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    // BannerAd(
    //   size: AdSize.banner,
    //   adUnitId: Platform.isIOS ? iOSTestId : androidTestId,
    //   listener: BannerAdListener(
    //     onAdLoaded: (ad) {
    //       setState(() {
    //         _bannerAd = ad as BannerAd;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, err) {
    //       print('Failed to load a banner ad: ${err.message}');
    //       ad.dispose();
    //     },
    //   ),
    //   request: const AdRequest(),
    // ).load();
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'alarm home wake up',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFD72499),
      ),
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
                    color: Colors.white,
                  ),
                ),
              ),
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // if (_bannerAd != null)
            //   Align(
            //     alignment: Alignment.bottomCenter,
            //     child: SizedBox(
            //       width: _bannerAd!.size.width.toDouble(),
            //       height: _bannerAd!.size.height.toDouble(),
            //       child: AdWidget(ad: _bannerAd!),
            //     ),
            //   ),
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
