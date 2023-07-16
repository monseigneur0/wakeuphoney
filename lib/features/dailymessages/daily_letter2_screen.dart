import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';
import 'package:wakeuphoney/features/dailymessages/daily_model.dart';

import '../../core/common/loader.dart';

class DailyLetter2Screen extends ConsumerStatefulWidget {
  static String routeName = "dailyletter2";
  static String routeURL = "/dailyletter2";
  const DailyLetter2Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DailyLetter2ScreenState();
}

class _DailyLetter2ScreenState extends ConsumerState<DailyLetter2Screen> {
  List allMessages = [];

  @override
  Widget build(BuildContext context) {
    final List<DateTime> listDateTime =
        ref.watch(dateTimeNotTodayStateProvider);

    final listMessage =
        ref.watch(getDailyMessageListProvider).whenData((value) => value);
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

    late List<DailyMessageModel> listMessageReal;

    List<int> list = [1, 2, 3, 4, 6, 5];
    list.sort(
      (a, b) => a.compareTo(b),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Letters"),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: ListView(children: [
        _HistoryList(
            listDateTime: listDateTime,
            ref: ref,
            listHistoryMessage: listHistoryMessage,
            historyLength: historyLength),
        Container(
          height: 1,
          decoration: const BoxDecoration(color: Colors.white),
        ),
        const Text(
          "Default Message",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        Container(
          height: 1,
          decoration: const BoxDecoration(color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Tomorrow",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
        _FutureList(
          listDateTime: listDateTime,
          ref: ref,
          listMessage: listMessage,
        ),
      ]),
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
        height: 400,
        width: 400,
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
                // print("error$error ");
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

class _FutureList extends StatelessWidget {
  const _FutureList({
    required this.listDateTime,
    required this.ref,
    required this.listMessage,
  });

  final List<DateTime> listDateTime;
  final WidgetRef ref;
  final AsyncValue<List<DailyMessageModel>> listMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: SizedBox(
        height: 500,
        child: ListView.builder(
          itemCount: 100,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return listMessage.when(
              data: (value) {
                return value
                            .singleWhere(
                              (element) =>
                                  element.messagedate ==
                                  DateFormat.yMMMd()
                                      .format(listDateTime[index]),
                              orElse: () => DailyMessageModel(
                                message: "no message",
                                messagedate: "messagedate",
                                messagedatetime: DateTime.now(),
                                time: DateTime.now(),
                                sender: "",
                                reciver: "",
                                photo: "",
                                audio: "",
                                video: "",
                              ),
                            )
                            .message !=
                        "no message"
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          tileColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          title: Text(
                            value
                                .singleWhere(
                                  (element) =>
                                      element.messagedate ==
                                      DateFormat.yMMMd()
                                          .format(listDateTime[index]),
                                  orElse: () => DailyMessageModel(
                                    message: "no message",
                                    messagedate: "messagedate",
                                    messagedatetime: DateTime.now(),
                                    time: DateTime.now(),
                                    sender: "",
                                    reciver: "",
                                    photo: "",
                                    audio: "",
                                    video: "",
                                  ),
                                )
                                .message,
                            // "wow",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat.MMMd().format(listDateTime[index]),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          title: Text(
                            value
                                .singleWhere(
                                  (element) =>
                                      element.messagedate ==
                                      DateFormat.yMMMd()
                                          .format(listDateTime[index]),
                                  orElse: () => DailyMessageModel(
                                    message: "no message",
                                    messagedate: "messagedate",
                                    messagedatetime: DateTime.now(),
                                    time: DateTime.now(),
                                    sender: "",
                                    reciver: "",
                                    photo: "",
                                    audio: "",
                                    video: "",
                                  ),
                                )
                                .message,
                            // "wow",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          subtitle: Text(
                            DateFormat.MMMd().format(listDateTime[index]),
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      );
              },
              error: (error, stackTrace) {
                // print("error$error ");
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
