import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/common/loader.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/auth/login_screen.dart';
import 'package:wakeuphoney/features/chatgpt/cs_screen.dart';
import 'package:wakeuphoney/features/dailymessages/letter_day_screen.dart';
import 'package:wakeuphoney/features/profile/profile_couple_screen.dart';
import 'package:wakeuphoney/features/profile/profile_screen.dart';
import 'package:wakeuphoney/practice_home_screen.dart';

import '../../core/constants/design_constants.dart';
import '../alarm/alarm_screen.dart';
import '../auth/auth_controller.dart';
import '../dailymessages/letter_screen.dart';
import '../letter/letter_feed2_screen.dart';
import '../letter/letter_feed3_screen.dart';
import '../letter/letter_feed4_screen.dart';
import '../letter/letter_feed_screen.dart';
import '../match/match_screen.dart';
import '../profile/auth_screen.dart';
import '../profile/profile_controller.dart';

class MainScreen extends ConsumerStatefulWidget {
  static String routeName = "mainscreen";
  static String routeURL = "/main";

  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 3;

  Logger logger = Logger();

  void _onItemTapped(int index) {
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': index,
        'firebase_screen_class': index,
      },
    );
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final analytics = ref.watch(analyticsProvider);
    final hasCoupleId = ref.watch(getUserProfileStreamProvider);
    hasCoupleId.whenData((value) {
      // ref.watch(profileControllerProvider.notifier).updateAllUser();
    });

    // return hasCoupleId.when(
    // data: (data) => data.couple != ""

    final isLoggedInStream = ref.watch(loginCheckProvider);
    List<Widget> widgetOptions = <Widget>[
      const AlarmHome(),
      // const DailyLetterScreen(),
      // const HistoryMessageScreen(),
      // const LetterScreen(),
      // const LetterFeed3Screen(),
      // const PracticeHome(),
      const LetterFeed4Screen(),
      const LetterDayScreen(),
      //왜 이중으로?
      hasCoupleId.when(
        data: ((data) {
          if (data.couple != "") {
            return const CoupleProfileScreen();
          }
          return const MatchScreen();
        }),
        error: (error, stackTrace) => const MatchScreen(),
        loading: (() => const Loader()),
      ),
      // const ProfileCoupleScreen(),
      // const AuthScreen(),
    ];
    return isLoggedInStream.when(
      data: (user) {
        if (user == null) {
          return const LoginHome();
        }
        return hasCoupleId.when(
          data: (data) {
            return data.couple == ""
                ? const MatchScreen()
                : Scaffold(
                    body: Center(
                      child: widgetOptions.elementAt(_selectedIndex),
                    ),
                    bottomNavigationBar: SizedBox(
                      height: 85,
                      child: BottomNavigationBar(
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: ImageIcon(
                              AssetImage('assets/alarm-clock.png'),
                            ),
                            label: '알람',
                          ),
                          // BottomNavigationBarItem(
                          //   icon: Icon(Icons.alarm),
                          //   label: 'Alarm2',
                          // ),
                          // BottomNavigationBarItem(
                          //   icon: Icon(Icons.favorite_border_outlined),
                          //   label: 'Letters',
                          // ),
                          // BottomNavigationBarItem(
                          //   icon: Icon(Icons.local_post_office_outlined),
                          //   label: '편지',
                          // ),
                          // BottomNavigationBarItem(
                          //   icon: Icon(Icons.feed_outlined),
                          //   label: 'Feed',
                          // ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.feed_outlined),
                            label: '피드',
                          ),
                          BottomNavigationBarItem(
                            backgroundColor: AppColors.myPink,
                            icon: Icon(Icons.add_comment_outlined),
                            label: '편지쓰기',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline_rounded),
                            label: '프로필',
                          ),
                          // BottomNavigationBarItem(
                          //   icon: Icon(Icons.person_outline_rounded),
                          //   label: '관리자',
                          // ),
                          // BottomNavigationBarItem(
                          //   icon: Icon(Icons.person_outline_rounded),
                          //   label: 'N Profile',
                          // ),
                        ],
                        currentIndex: _selectedIndex,
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
          error: (error, _) {
            logger.e(error);
            return const Scaffold(
                body: Center(child: Text('An error occurred')));
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
      error: (error, stackTrace) => const MatchScreen(),
      loading: (() => const Loader()),
    );
  }
}
