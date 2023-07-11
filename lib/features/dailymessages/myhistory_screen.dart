import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';

class MyHistoryScreen extends ConsumerStatefulWidget {
  static String routeName = "myhistory";
  static String routeURL = "/myhistory";
  const MyHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyHistoryScreenState();
}

class _MyHistoryScreenState extends ConsumerState<MyHistoryScreen> {
  List allMessages = [];

  @override
  Widget build(BuildContext context) {
    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);
    final listMessage = ref.watch(getDailyMessageListProvider);

    int listMessageLength =
        listMessage.value != null ? listMessage.value!.length : 0;
    allMessages = [listMessage, ...listDateTime];
    return Scaffold(
      appBar: AppBar(
        title: const Text("My History"),
        backgroundColor: const Color(0xFFD72499),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Text(allMessages[index].toString());
      }),
    );
  }
}
