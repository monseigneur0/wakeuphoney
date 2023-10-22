import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/common/loader.dart';
import 'package:wakeuphoney/features/auth/login_screen.dart';
import 'package:wakeuphoney/features/profile/profile_screen.dart';

import '../../core/constants/design_constants.dart';
import '../alarm/alarm_screen.dart';
import '../auth/auth_controller.dart';
import '../dailymessages/daily_letter3_screen.dart';
import '../dailymessages/history_screen.dart';
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
  int _selectedIndex = 1;

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
      const DailyLetter3Screen(),
      const HistoryMessageScreen(),
      hasCoupleId.when(
        data: ((data) {
          if (data.couple != "") {
            return const CoupleProfileScreen();
          }
          return const MatchScreen();
        }),
        error: (error, stackTrace) => const MatchScreen(),
        loading: (() => const Loader()),
      )
    ];
    return isLoggedInStream.when(
      data: (user) {
        if (user == null) {
          return const LoginHome();
        }
        return Scaffold(
          body: Center(
            child: widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/alarm-clock.png'),
                  size: 18,
                ),
                label: 'Alarm',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.alarm),
              //   label: 'Alarm2',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined),
                label: 'Letters',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_post_office_outlined),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.myPink,
            onTap: _onItemTapped,
            iconSize: 18,
            selectedFontSize: 10,
            unselectedFontSize: 7,
            unselectedItemColor: Colors.grey[600],
          ),
        );
      },
      error: (error, _) =>
          const Scaffold(body: Center(child: Text('An error occurred'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
