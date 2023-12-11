import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LetterWriteScreen extends ConsumerStatefulWidget {
  static String routeName = "letterwritescreen";
  static String routeURL = "/letterwritescreen";
  const LetterWriteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterWriteScreenState();
}

class _LetterWriteScreenState extends ConsumerState<LetterWriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
