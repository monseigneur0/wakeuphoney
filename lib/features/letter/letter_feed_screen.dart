import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LetterFeedScreen extends ConsumerStatefulWidget {
  static String routeName = "letterfeedscreen";
  static String routeURL = "/letterfeedscreen";
  const LetterFeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterFeedScreenState();
}

class _LetterFeedScreenState extends ConsumerState<LetterFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
