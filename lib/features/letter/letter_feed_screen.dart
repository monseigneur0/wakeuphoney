import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/constants/design_constants.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';
import 'package:wakeuphoney/features/dailymessages/letter_day_screen.dart';

import '../../core/common/loader.dart';
import '../profile/profile_controller.dart';

class LetterFeedScreen extends ConsumerStatefulWidget {
  static String routeName = "letterfeedscreen";
  static String routeURL = "/letterfeedscreen";
  const LetterFeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterFeedScreenState();
}

class _LetterFeedScreenState extends ConsumerState<LetterFeedScreen> {
  final logger = Logger();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(getMyUserInfoProvider);

    final letterList = ref.watch(getLettersListProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: const Text("우리의 편지1"),
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
          userInfo.when(
              data: (user) {
                return letterList.when(
                    data: (letter) {
                      return SliverList(
                        key: const PageStorageKey<String>("page"),
                        delegate: SliverChildBuilderDelegate(
                          childCount: letter
                              .where((element) => element.isLetter == true)
                              .length,
                          (context, index) => Builder(
                            builder: (context) {
                              return Column(
                                children: [
                                  Text("$index"),
                                  Text(letter[index].sender),
                                  Text(letter[index].message),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      logger.e(error.toString());
                      return const Center(
                        child: Text("사용자를 찾을 수 없어요 \n 다시 접속해주세요."),
                      );
                    },
                    loading: () => const Loader());
              },
              error: (error, stackTrace) {
                logger.e(error.toString());
                return const Center(
                  child: Text("사용자를 찾을 수 없어요 \n 다시 접속해주세요."),
                );
              },
              loading: () => const Loader()),
        ],
      ),
    );
  }
}
