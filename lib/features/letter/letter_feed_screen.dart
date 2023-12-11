import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/constants/design_constants.dart';
import 'package:wakeuphoney/features/dailymessages/letter_day_screen.dart';

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("우리의 편지"),
            actions: [
              IconButton(
                onPressed: () {
                  context.pushNamed(LetterDayScreen.routeName);
                },
                icon: const Icon(
                  Icons.note_alt_outlined,
                  color: AppColors.myPink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
