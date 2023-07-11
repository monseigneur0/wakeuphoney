import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/providers/providers.dart';
import 'features/couples/couples_list_screen.dart';
import 'features/dailymessages/daily_screen.dart';
import 'features/dailymessages/daily_screen2.dart';
import 'features/dailymessages/myhistory_screen.dart';
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
  // final String iOSTestId = 'ca-app-pub-3940256099942544/2934735716';
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
              Text(currentUserModel.currentUser!.email ?? "email"),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                onPressed: () => context.pushNamed(AlarmHome.routeName),
                child: const Text('AlarmHome'),
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
                  context.pushNamed(MyHistoryScreen.routeName);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blue[600])),
                child: const Text('MyHistoryScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(CouplesListScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepOrange)),
                child: const Text('CouplesListScreen'),
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
