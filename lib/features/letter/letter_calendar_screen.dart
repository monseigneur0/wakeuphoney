import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LetterCalendarScreen extends ConsumerStatefulWidget {
  static String routeName = "lettercalendarscreen";
  static String routeURL = "/lettercalendarscreen";
  const LetterCalendarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterCalendarScreenState();
}

class _LetterCalendarScreenState extends ConsumerState<LetterCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Letter Calendar"),
      ),
      body: const Center(
        child: Text("Letter Calendar"),
      ),
    );
  }
}
