import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/features/oldmain/main_screen.dart';
import 'package:wakeuphoney/features/oldprofile/profile_controller.dart';
import 'package:wakeuphoney/features/oldwakeup/wakeup_write_screen.dart';

import '../../core/providers/providers.dart';
import '../oldauth/auth_controller.dart';
import '../oldwakeup/response_screen.dart';
import '../oldprofile/profile_screen.dart';
import '../oldmatch/match_screen.dart';
import '../oldauth/auth_repository.dart';
import 'package:go_router/go_router.dart';

import '../oldalarm/alarm_screen.dart';
import '../oldauth/login_screen.dart';
import '../oldvoice/just_audio_examle.dart';
import '../oldvoice/voice_test_screen.dart';
import '../oldvoice/voice_text_screen.dart';
import '../oldvoice/wakeup_voice_screen.dart';
import '../oldwakeup/wakeup_me_alarm.dart';

class PracticeHome extends ConsumerStatefulWidget {
  static String routeName = "practice";
  static String routeURL = "/practice";

  const PracticeHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PracticeHomeState();
}

class _PracticeHomeState extends ConsumerState<PracticeHome> {
  @override
  Widget build(BuildContext context) {
    final number = ref.watch(numberProvider);
    final numberState = ref.watch(numberStateProvider);
    final currentUserModel = ref.watch(authRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Explorer1'),
        backgroundColor: Colors.black87,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(currentUserModel.currentUser?.displayName ?? "no user"),
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(currentUserModel.currentUser?.email ?? "email"),
              Text("${DateFormat('E', 'ko_KR').format(DateTime.now())}요일임당"),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                onPressed: () => context.pushNamed(AlarmHome.routeName),
                child: const Text('AlarmHome'),
              ),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WakeUpWriteScreen(),
                    )),
                child: const Text('WakeUpMeAlarmScreen'),
              ),

              IconButton(
                onPressed: () {
                  ref.watch(authRepositoryProvider).logout();
                  context.goNamed(LoginHome.routeName);
                },
                icon: const Icon(
                  Icons.done,
                  color: Colors.green,
                ),
              ),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () => context.pushNamed(MatchScreen.routeName),
                child: const Text('MatchScreen'),
              ),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WakeUpVoiceScreen(),
                    )),
                child: const Text('WakeUpVoiceScreen'),
              ),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JustAudioExample(),
                    )),
                child: const Text('JustAudioExample1'),
              ),

              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () => context.pushNamed(MyApptest.routeName),
                child: const Text('MyApptest'),
              ),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purple)),
                onPressed: () => context.pushNamed(MyApp.routeName),
                child: const Text('MyApp', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                onPressed: () {
                  ref.watch(profileControllerProvider.notifier).updateAllUser();
                },
                child: const Text('UpdateAllUser', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)),
                onPressed: () => context.pushNamed(MainScreen.routeName),
                child: const Text('MainScreen'),
              ),
              ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () {
                  context.go(LoginHome.routeURL);
                },
                child: const Text('Login Home'),
              ),

              ElevatedButton(
                onPressed: () {
                  context.pushNamed(ResponseScreen.routeName);
                },
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow[800])),
                child: const Text('ResponseScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(MatchScreen.routeName);
                },
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)),
                child: const Text('ProfileScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(CoupleProfileScreen.routeName);
                },
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purple)),
                child: const Text('CoupleProfileScreen'),
              ),
              const Text('numberProvider'),
              Text(number.toString()),
              const Text('numberStateProvider'),
              Text(numberState.toString()),

              ElevatedButton(
                  onPressed: () {
                    ref.read(numberStateProvider.notifier).state++;
                  },
                  child: const Text('numStateIncrement')),
              // if (_bannerAd != null)
              //   Align(
              //     alignment: Alignment.topCenter,
              //     child: SizedBox(
              //       width: _bannerAd!.size.width.toDouble(),
              //       height: _bannerAd!.size.height.toDouble(),
              //       child: AdWidget(ad: _bannerAd!),
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}
