import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'insta_body.dart';

class DailyLetter5Screen extends ConsumerStatefulWidget {
  static String routeName = "dailyletter5";
  static String routeURL = "/dailyletter5";
  const DailyLetter5Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DailyLetter5ScreenState();
}

class _DailyLetter5ScreenState extends ConsumerState<DailyLetter5Screen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          secondary: Colors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const InstaCloneHome(),
    );
  }
}

class InstaCloneHome extends ConsumerStatefulWidget {
  const InstaCloneHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InstaCloneHomeState();
}

class _InstaCloneHomeState extends ConsumerState<InstaCloneHome> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sweat Gom',
          style: GoogleFonts.lobsterTwo(
            color: Colors.black,
            fontSize: 32,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            iconSize: 32,
            onPressed: () {
              print("tab favorite");
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.paperplane),
            iconSize: 32,
            onPressed: () {
              print("tab paperplane");
            },
          ),
        ],
      ),
      body: Instabody(index: index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (newIndex) {
          setState(
            () => index = newIndex,
          );
          print(newIndex);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),
    );
  }
}
