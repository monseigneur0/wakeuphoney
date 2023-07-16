import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';
import 'package:wakeuphoney/features/dailymessages/daily_model.dart';

import '../../core/common/loader.dart';

class DailyLetterScreen extends ConsumerStatefulWidget {
  static String routeName = "dailyletter";
  static String routeURL = "/dailyletter";
  const DailyLetterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DailyLetterScreenState();
}

class _DailyLetterScreenState extends ConsumerState<DailyLetterScreen> {
  List allMessages = [];

  @override
  Widget build(BuildContext context) {
    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);

    final listMessage =
        ref.watch(getDailyMessageListProvider).whenData((value) => value);

    int historyLength = 0;

    late List<DailyMessageModel> listMessageReal;

    List<int> list = [1, 2, 3, 4, 6, 5];
    list.sort(
      (a, b) => a.compareTo(b),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Future Daily letters"),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: 100,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              tileColor: Colors.grey[800],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(
                  "ss",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              subtitle: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  DateFormat.MMMd().format(listDateTime[index]),
                ),
              ),
              onTap: () {
                ref.read(selectedDate.notifier).state =
                    DateFormat.yMMMd().format(listDateTime[index]);
              },
            ),
          );
          return listMessage.when(
            data: (value) {
              return ListTile(
                title: Text(
                  value
                      .singleWhere(
                        (element) =>
                            element.messagedate ==
                            DateFormat.yMMMd().format(listDateTime[index]),
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
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  DateFormat.MMMd().format(listDateTime[index]),
                  style: const TextStyle(color: Colors.white),
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
    );
  }
}
