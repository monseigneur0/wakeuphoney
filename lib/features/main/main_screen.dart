import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/constants/design_constants.dart';
import '../alarm/alarm_screen.dart';
import '../dailymessages/daily_letter3_screen.dart';
import '../dailymessages/history_screen.dart';
import '../match/match_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  static String routeName = "mainscreen";
  static String routeURL = "/main";

  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    AlarmHome(),
    DailyLetter3Screen(),
    HistoryMessageScreen(),
    MatchScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
  }
}
