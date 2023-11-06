// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wakeuphoney/core/constants/design_constants.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/auth/login_email_screen.dart';
import 'package:wakeuphoney/features/auth/login_screen.dart';

class LoginMainScreen extends ConsumerStatefulWidget {
  static String routeName = "loginmain";
  static String routeURL = "/loginmain";

  // int passIndex;

  const LoginMainScreen({
    super.key,
    // required this.passIndex,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginMainScreenState();
}

class _LoginMainScreenState extends ConsumerState<LoginMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    LoginHome(),
    EmailLoginScreen()
  ];

  void _onItemTapped(int index) {
    ref.watch(loginIndex);
    setState(() {
      _selectedIndex = index;
    });
    print(index);
    print(ref.watch(loginIndex));
  }

  @override
  Widget build(BuildContext context) {
    int loginIndexProvider = ref.watch(loginIndex.notifier).state;

    loginIndexProvider = _selectedIndex;
    print("selected index $_selectedIndex");
    return Scaffold(
      body: _widgetOptions.elementAt(loginIndexProvider),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'SNS Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Email Login',
          ),
        ],
        currentIndex: loginIndexProvider,
        selectedItemColor: AppColors.myPink,
        onTap: _onItemTapped,
        iconSize: 15,
      ),
    );
  }
}
