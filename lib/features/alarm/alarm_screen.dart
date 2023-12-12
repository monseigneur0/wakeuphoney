import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/constants/design_constants.dart';
import '../../widgets/alarm_tile.dart';

import 'alarm2_shortcut.dart';
import 'alarm_edit_screen.dart';
import 'alarm_ring_screen.dart';

final alarmSettingsProvider = StateProvider<AlarmSettings>((ref) =>
    AlarmSettings(
        id: 112,
        dateTime: DateTime.now(),
        assetAudioPath: 'assets/mozart.mp3'));

class AlarmHome extends StatefulWidget {
  static String routeName = "alarm";
  static String routeURL = "/alarm";
  const AlarmHome({super.key});

  @override
  AlarmHomeState createState() => AlarmHomeState();
}

class AlarmHomeState extends State<AlarmHome> {
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  final String iOSTestId = 'ca-app-pub-5897230132206634/3120978311';
  final String androidTestId = 'ca-app-pub-5897230132206634/5879003590';

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOSTestId : androidTestId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // logger.d('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    ).load();
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
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: AlarmEditScreen(alarmSettings: settings),
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
        title: Text(
          AppLocalizations.of(context)!.alarms,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () => navigateToAlarmScreen(null),
            icon: const ImageIcon(
              AssetImage('assets/alarm-clock.png'),
              size: 29,
              color: AppColors.myPink,
            ),
          ),
          // IconButton(
          //   onPressed: () => context.pushNamed(AlarmNewScreen.routeName),
          //   icon: const ImageIcon(
          //     AssetImage('assets/alarm-clock.png'),
          //     size: 29,
          //     color: AppColors.myPink,
          //   ),
          // )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: alarms.isNotEmpty
                ? ListView.builder(
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
                          Alarm.stop(alarms[index].id)
                              .then((_) => loadAlarms());
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context)!.noalarmset,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
          ),
          if (_bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 100, right: 10),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       ExampleAlarmHomeShortcutButton(refreshAlarms: loadAlarms),
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
  );
  Alarm.set(
    alarmSettings: alarmSettingNow,
  );
}
