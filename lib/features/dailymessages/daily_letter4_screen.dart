import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';
import 'package:wakeuphoney/features/dailymessages/daily_model.dart';

import '../../core/common/loader.dart';
import '../../core/providers/firebase_providers.dart';
import 'daily_letter3_screen.dart';

class DailyLetter4Screen extends ConsumerStatefulWidget {
  static String routeName = "dailyletter4";
  static String routeURL = "/dailyletter4";
  const DailyLetter4Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DailyLetter4ScreenState();
}

class _DailyLetter4ScreenState extends ConsumerState<DailyLetter4Screen> {
  List allMessages = [];

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(authProvider).currentUser!.uid;

    final List<DateTime> listDateTime =
        ref.watch(dateTimeNotTodayStateProvider);

    final listHistoryMessage =
        ref.watch(getDailyMessageHistoryListProvider).whenData((value) {
      // historyLength = value.length;
      return value
          .filter((t) => t.messagedatetime.isBefore(DateTime.now().add(Duration(
              seconds: 24 * 60 * 60 -
                  DateTime.now().hour * 3600 -
                  DateTime.now().minute * 60 -
                  DateTime.now().second))))
          .toList();
    });

    int historyLength = 0;

    List<int> list = [1, 2, 3, 4, 6, 5];
    list.sort(
      (a, b) => a.compareTo(b),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Letters4"),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(DailyLetter3Screen.routeName);
              },
              icon: const Icon(Icons.connecting_airports_outlined))
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[800]),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.72,
              child: ScrollablePositionedList.builder(
                initialScrollIndex: listHistoryMessage.when(
                  data: (value) => value.length,
                  error: (error, stackTrace) {
                    print("error$error ");
                    return 0;
                  },
                  loading: () => 0,
                ),
                itemCount: listHistoryMessage.when(
                  data: (value) => value.length,
                  error: (error, stackTrace) {
                    print("error$error ");
                    return 0;
                  },
                  loading: () => 0,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return listHistoryMessage.when(
                    data: (value) {
                      return value[index].sender == uid
                          ? Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: value[index].photo.isNotEmpty
                                      ? Image.network(value[index].photo)
                                      : Container(),
                                ),
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        value[index].message,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat.MMMd().format(
                                            value[index].messagedatetime),
                                        style:
                                            TextStyle(color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: value[index].photo.isNotEmpty
                                      ? Image.network(value[index].photo)
                                      : Container(),
                                ),
                                ListTile(
                                  title: Text(
                                    value[index].message,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat.MMMd()
                                        .format(value[index].messagedatetime),
                                    style: const TextStyle(
                                        color: Color(0xFFD72499)),
                                  ),
                                ),
                              ],
                            );
                    },
                    error: (error, stackTrace) {
                      print("error$error ");
                      return Container();
                    },
                    loading: () => const Loader(),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 1,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.listDateTime,
    required this.ref,
    required this.listHistoryMessage,
    required this.historyLength,
  });

  final List<DateTime> listDateTime;
  final WidgetRef ref;
  final AsyncValue<List<DailyMessageModel>> listHistoryMessage;
  final int historyLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: ListView.builder(
          itemCount: listHistoryMessage.whenData((value) => value.length).value,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return listHistoryMessage.when(
              data: (value) {
                return ListTile(
                  tileColor: Colors.black,
                  title: Text(
                    value[index].message,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.MMMd().format(value[index].messagedatetime),
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                );
              },
              error: (error, stackTrace) {
                print("error$error ");
                return null;
              },
              loading: () => const Loader(),
            );
          },
        ),
      ),
    );
  }
}
