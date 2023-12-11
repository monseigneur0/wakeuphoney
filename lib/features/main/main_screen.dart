import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/common/loader.dart';
import 'package:wakeuphoney/features/auth/login_screen.dart';
import 'package:wakeuphoney/features/dailymessages/letter_day_screen.dart';
import 'package:wakeuphoney/features/profile/profile_couple_screen.dart';
import 'package:wakeuphoney/features/profile/profile_screen.dart';

import '../../core/constants/design_constants.dart';
import '../alarm/alarm_screen.dart';
import '../auth/auth_controller.dart';
import '../dailymessages/letter_screen.dart';
import '../letter/letter_feed_screen.dart';
import '../match/match_screen.dart';
import '../profile/profile_controller.dart';

class MainScreen extends ConsumerStatefulWidget {
  static String routeName = "mainscreen";
  static String routeURL = "/main";

  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasCoupleId = ref.watch(getUserProfileStreamProvider);

    // return hasCoupleId.when(
    // data: (data) => data.couple != ""

    final isLoggedInStream = ref.watch(loginCheckProvider);
    List<Widget> widgetOptions = <Widget>[
      const AlarmHome(),
      // const DailyLetterScreen(),
      // const HistoryMessageScreen(),
      const LetterScreen(),
      // const LetterFeedScreen(),
      const LetterDayScreen(),
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
                            label: 'Alarm',
                          ),
                          // BottomNavigationBarItem(
                          //   icon: Icon(Icons.alarm),
                          //   label: 'Alarm2',
                          // ),
                          // BottomNavigationBarItem(
                          //   icon: Icon(Icons.favorite_border_outlined),
                          //   label: 'Letters',
                          // ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.local_post_office_outlined),
                            label: 'Letters',
                          ),
                          // BottomNavigationBarItem(
                          //   icon: Icon(Icons.feed_outlined),
                          //   label: 'Feed',
                          // ),
                          BottomNavigationBarItem(
                            backgroundColor: AppColors.myPink,
                            icon: Icon(Icons.add_comment_outlined),
                            label: 'Write',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline_rounded),
                            label: 'Profile',
                          ),
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
          error: (error, _) =>
              const Scaffold(body: Center(child: Text('An error occurred'))),
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
      error: (error, stackTrace) => const MatchScreen(),
      loading: (() => const Loader()),
    );
  }
}
