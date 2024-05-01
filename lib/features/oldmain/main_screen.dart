import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/common/fcm_manager.dart';
import 'package:wakeuphoney/common/loader.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/core/providers/providers.dart';

import 'package:wakeuphoney/features/oldauth/login_screen.dart';
import 'package:wakeuphoney/features/oldprofile/profile_screen.dart';
import 'package:wakeuphoney/features/oldwakeup/wakeup_feed_screen.dart';
import 'package:wakeuphoney/features/oldmanager/practice_home_screen.dart';

import '../../common/constants/app_colors.dart';
import '../oldalarm/alarm_ring_screen.dart';
import '../oldauth/auth_controller.dart';
import '../oldmatch/match_screen.dart';
import '../oldprofile/profile_controller.dart';
import '../oldwakeup/wakeup_me_alarm.dart';
import '../oldwakeup/wakeup_you_screen.dart';
import 'main_controller.dart';

class MainScreen extends ConsumerStatefulWidget {
  static String routeName = "mainscreen";
  static String routeURL = "/mainscreen";

  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int selectedIndex = 0;
  Logger logger = Logger();

  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  void _onItemTapped(int index) {
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': index,
        'firebase_screen_class': index,
      },
    );
    ref.watch(analyticsProvider).setCurrentScreen(
          screenName: index.toString(),
          screenClassOverride: index.toString(),
        );
    HapticFeedback.lightImpact();
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadAlarms();
    // subscription ??= Alarm.ringStream.stream.listen(
    //   (alarmSettings) => navigateToRingScreen(alarmSettings),
    // );
    FcmManager.requestPermission();
    FcmManager.initialize();
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

  @override
  Widget build(BuildContext context) {
    final analytics = ref.watch(analyticsProvider);
    final hasCoupleId = ref.watch(getUserProfileStreamProvider);
    final getUserModelMe = ref.watch(getMeUserModelProvider);
    final coupleUidFuture = ref.watch(getFutureMyUserDataProvider).value;

    // hasCoupleId.whenData((value) {
    //   ref.watch(profileControllerProvider.notifier).updateAllUser();
    // });
    // logger.d("update complete");

    final isLoggedInStream = ref.watch(loginCheckProvider);
    List<Widget> widgetOptions = <Widget>[
      const WakeUpMeAlarmScreen(),
      // const WakeUpVoiceScreen(),
      // const WakeUpMeScreen(),
      const WakeUpYouScreen(),
      // if (kDebugMode) const WakeUpYouAlarmScreen(),
      // if (kDebugMode) const WakeMeScreen(),
      const WakeUpFeedScreen(),
      // const ListAudio(),
      // const PlayerScreen(),
      // const FeedbackListScreen(),
      hasCoupleId.when(
        data: ((userModel) {
          ref.watch(authControllerProvider.notifier).saveUserData(userModel);

          if (userModel.couple != "" || userModel.couple == null) {
            return const CoupleProfileScreen();
          }
          return const MatchScreen();
        }),
        error: (error, stackTrace) => const MatchScreen(),
        loading: (() => const Loader()),
      ),
      const PracticeHome(),
    ];
    return isLoggedInStream.when(
      data: (user) {
        if (user == null) {
          return const LoginHome();
        }
        return hasCoupleId.when(
          data: (data) {
            if (data.couple == "" || data.couple == null) {
              ref.read(userModelofMeStateProvider.notifier).state = data;
              logger.d(ref.watch(userModelofMeStateProvider));
            }

            // print(data.couple : ${data.couple}");
            return data.couple == "" || data.couple == null
                ? const MatchScreen()
                : Scaffold(
                    body: Center(
                      child: widgetOptions.elementAt(selectedIndex),
                    ),
                    bottomNavigationBar: SizedBox(
                      height: 85,
                      child: BottomNavigationBar(
                        items: <BottomNavigationBarItem>[
                          // BottomNavigationBarItem(
                          //   icon: const ImageIcon(
                          //     AssetImage('assets/images/alarm-clock.png'),
                          //   ),
                          //   label: 'alarm'.tr(),
                          // ),
                          BottomNavigationBarItem(
                            icon: const ImageIcon(
                              AssetImage('assets/images/alarm-clock.png'),
                            ),
                            label: 'alarm'.tr(),
                          ),
                          // const BottomNavigationBarItem(
                          //   icon: ImageIcon(
                          //     AssetImage('assets/images/alarm-clock.png'),
                          //   ),
                          //   label: "voice",
                          // ),
                          BottomNavigationBarItem(
                            backgroundColor: AppColors.myPink,
                            icon: const Icon(Icons.local_post_office_outlined),
                            label: 'write'.tr(),
                          ),
                          // if (kDebugMode)
                          //   const BottomNavigationBarItem(
                          //     icon: Icon(Icons.home_outlined),
                          //     label: "me",
                          //   ),
                          // if (kDebugMode)
                          //   const BottomNavigationBarItem(
                          //     icon: Icon(Icons.home_outlined),
                          //     label: "you",
                          //   ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.home_outlined),
                            label: 'feed'.tr(),
                          ),
                          BottomNavigationBarItem(
                            icon: const Icon(Icons.person_outline_rounded),
                            label: 'profile'.tr(),
                          ),
                          if (kDebugMode)
                            const BottomNavigationBarItem(
                              icon: Icon(Icons.not_interested),
                              label: "Manager",
                            ),

                          if (user.uid == "WvELgU4cO6gOeyzfu92j3k9vuBH2" && !kDebugMode)
                            const BottomNavigationBarItem(
                              icon: Icon(Icons.not_interested),
                              label: "Manager",
                            ),
                        ],
                        currentIndex: selectedIndex,
                        selectedItemColor: AppColors.myPink,
                        onTap: _onItemTapped,
                        iconSize: 20,
                        selectedFontSize: 12,
                        unselectedFontSize: 11,
                        unselectedItemColor: Colors.grey[800],
                        type: BottomNavigationBarType.fixed,
                      ),
                    ),
                  );
          },
          error: (error, stackTrace) {
            logger.e(error);
            logger.e(stackTrace);

            return Scaffold(
                body: GestureDetector(
                    onTap: () {
                      ref.watch(authControllerProvider.notifier).logout(context);
                    },
                    child: const Center(child: Text('An error occurred'))));
          },
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
      error: (error, stackTrace) => const MatchScreen(),
      loading: (() => const Loader()),
    );
  }
}
