import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/features/main/main_screen.dart';

import 'core/providers/providers.dart';
import 'features/dailymessages/daily_letter_screen.dart';
import 'features/dailymessages/couple_letter_screen.dart';
import 'features/dailymessages/letter_date_screen.dart';
import 'features/dailymessages/letter_day_pick_screen.dart';
import 'features/dailymessages/response_screen.dart';
import 'features/match/match3_screen.dart';
import 'features/match/match4_screen.dart';
import 'features/match/match_up.dart';
import 'features/profile/profile_screen.dart';
import 'features/match/match_screen.dart';
import 'features/auth/auth_repository.dart';
import 'package:go_router/go_router.dart';

import 'features/alarm/alarm_screen.dart';
import 'features/auth/login_screen.dart';

class PracticeHome extends ConsumerStatefulWidget {
  static String routeName = "practice";
  static String routeURL = "/";

  const PracticeHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PracticeHomeState();
}

class _PracticeHomeState extends ConsumerState<PracticeHome> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
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
              Text("${DateFormat('E', 'ko_KR').format(dateTime)}요일임당"),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                onPressed: () => context.pushNamed(AlarmHome.routeName),
                child: const Text('AlarmHome'),
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
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () => context.pushNamed(MatchScreen.routeName),
                child: const Text('MatchScreen'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () => context.pushNamed(Match3Screen.routeName),
                child: const Text('Match3Screen'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                onPressed: () => context.pushNamed(Match4Screen.routeName),
                child: const Text('PomodoroScreen'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
                onPressed: () => context.pushNamed(MainScreen.routeName),
                child: const Text('MainScreen'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () {
                  context.go(LoginHome.routeURL);
                },
                child: const Text('Login Home'),
              ),

              ElevatedButton(
                onPressed: () {
                  context.pushNamed(ResponseScreen.routeName);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.yellow[800])),
                child: const Text('ResponseScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(DailyLetterScreen.routeName);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.purple[600])),
                child: const Text('DailyLetterScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(CoupleLetterScreen.routeName);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blue[600])),
                child: const Text('CoupleHistoryScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(Home.routeName);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.green[600])),
                child: const Text('Home date picker'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(MatchScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
                child: const Text('ProfileScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(CoupleProfileScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.purple)),
                child: const Text('CoupleProfileScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(LetterDateScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                child: const Text('LetterDateScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(LetterDayPickScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child: const Text('LetterDayPickScreen'),
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
