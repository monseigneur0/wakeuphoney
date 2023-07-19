import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/providers/providers.dart';
import 'features/alarm/alarm2_screen.dart';
import 'features/dailymessages/daily_letter2_screen.dart';
import 'features/dailymessages/daily_letter3_screen.dart';
import 'features/dailymessages/daily_letter4_screen.dart';
import 'features/dailymessages/daily_letter_screen.dart';
import 'features/dailymessages/daily_screen.dart';
import 'features/dailymessages/daily_screen2.dart';
import 'features/dailymessages/couple_letter_screen.dart';
import 'features/dailymessages/response_screen.dart';
import 'features/profile/couple_profile_screen.dart';
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
  final String iOSTestId = 'ca-app-pub-5897230132206634/3120978311';
  final String androidTestId = 'ca-app-pub-3940256099942544/6300978111';

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

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
              const Text("email"),
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
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () => context.pushNamed(AlarmHome2.routeName),
                child: const Text('AlarmHome2'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () => context.pushNamed(MatchScreen.routeName),
                child: const Text('MatchScreen'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                onPressed: () {
                  context.go(LoginHome.routeURL);
                },
                child: const Text('Login Home'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(DailyMessageScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple)),
                child: const Text('DailyMessageScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(DailyMessage2Screen.routeName);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blue[800])),
                child: const Text('DailyMessageScreen2222'),
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
                        MaterialStatePropertyAll(Colors.blue[600])),
                child: const Text('DailyLetterScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(DailyLetter2Screen.routeName);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red[600])),
                child: const Text('DailyLetterScreen2222'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(DailyLetter3Screen.routeName);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.purple[600])),
                child: const Text('DailyLetter33Screen333'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(DailyLetter4Screen.routeName);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.grey[600])),
                child: const Text('DailyLetterScreen444'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(CoupleLetterScreen.routeName);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.green[600])),
                child: const Text('CoupleHistoryScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(MatchScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                child: const Text('ProfileScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(CoupleProfileScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                child: const Text('CoupleProfileScreen'),
              ),
              const Text('numberProvider'),
              Text(number.toString()),
              const Text('numberStateProvider'),
              Text(numberState.toString()),
              const Text('valueStateProvider'),
              ElevatedButton(
                  onPressed: () {
                    ref.read(numberStateProvider.notifier).state++;
                  },
                  child: const Text('Increment')),
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
