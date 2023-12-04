import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/core/utils.dart';

import '../../core/common/loader.dart';
import 'daily_controller.dart';
import 'letter_create_screen.dart';
import 'letter_date_screen.dart';
import 'letter_day_screen.dart';

class LetterDayPickScreen extends ConsumerStatefulWidget {
  static String routeName = 'letter_day_pick_screen';
  static String routeURL = '/letter_day_pick_screen';
  const LetterDayPickScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterDayPickScreenState();
}

class _LetterDayPickScreenState extends ConsumerState<LetterDayPickScreen> {
  List<String> wow = [];

  @override
  Widget build(BuildContext context) {
    final lettersList = ref.watch(getLettersListProvider);

    final List<DateTime> listDateTime =
        ref.watch(dateTimeNotTodayStateProvider);
    return lettersList.when(
      data: (data) {
        for (var adate in data) {
          wow.add(adate.messagedate);
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('편지를 보낼 날짜를 고르세요.'),
                actions: [
                  IconButton(
                      onPressed: () {
                        context.pushNamed(LetterDayScreen.routeName);
                      },
                      icon: const Icon(
                        Icons.looks_two_outlined,
                        color: Color(0xFFD72499),
                      ))
                ],
                floating: true,
                flexibleSpace: Container(),
                expandedHeight: 100,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return wow.any((element) =>
                            element ==
                            DateFormat.yMMMd().format(listDateTime[index]))
                        ? ListTile(
                            title: TextButton(
                              onPressed: () {
                                showSnackBar(context, '이미 편지를 썼어요');
                              },
                              child: Text(
                                "${DateFormat.d().format(listDateTime[index])} ${DateFormat.EEEE().format(listDateTime[index])} ",
                                style: const TextStyle(
                                    fontSize: 25, color: Colors.grey),
                              ),
                            ),
                            // subtitle: Text(     'Write letter at ${DateFormat.yMMMd().format(listDateTime[index])} $index'),
                          )
                        : ListTile(
                            title: TextButton(
                              onPressed: () {
                                ref.watch(selectedDate.notifier).state =
                                    DateFormat.yMMMd()
                                        .format(listDateTime[index]);
                                ref.watch(selectedDateTime.notifier).state =
                                    DateTime.now()
                                        .add(Duration(
                                            seconds: 24 * 60 * 60 -
                                                DateTime.now().hour * 3600 -
                                                DateTime.now().minute * 60 -
                                                DateTime.now().second))
                                        .add(Duration(days: index));
                                context.pushNamed(LetterCreateScreen.routeName);
                              },
                              child: Text(
                                "${DateFormat.d().format(listDateTime[index])} ${DateFormat.EEEE().format(listDateTime[index])} ",
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            // subtitle: Text(    'Write letter at ${DateFormat.yMMMd().format(listDateTime[index])} $index'),
                            subtitle: index % 7 == 0 ? const Text(' ') : null,
                          );
                  },
                  childCount: 100,
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        // logger.d("error$error ");
        return const Center(
            child: Text(
          "날짜를 불러오지 못했어요",
          style: TextStyle(color: Colors.white, fontSize: 40),
        ));
      },
      loading: () => const Loader(),
    );
  }
}
