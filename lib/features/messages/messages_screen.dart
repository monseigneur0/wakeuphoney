import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'message_edit.dart';

final dateStateProvider =
    StateProvider<List<String>>((ref) => List<String>.generate(
        100,
        (index) => DateFormat.MMMd().format(
              DateTime.now().add(Duration(days: index)),
            )));
final selectedDate = StateProvider<String>(
  (ref) => DateFormat.MMMd().format(DateTime.now()),
);

class MessagesScreen extends ConsumerStatefulWidget {
  static String routeName = "messages";
  static String routeURL = "/messages";

  const MessagesScreen({super.key});

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends ConsumerState<MessagesScreen> {
  TextEditingController messageContorller = TextEditingController();

  final _blackColor = const Color(0xFF1F2123);
  final _greyColor = const Color(0xFF464A4F);

  @override
  Widget build(BuildContext context) {
    final dateList100 = ref.watch(dateStateProvider);
    const title = 'Messgae_daily';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        backgroundColor: _blackColor,
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dateList100.length,
                prototypeItem: ListTile(
                  title: Text(
                    dateList100.first,
                    style: const TextStyle(
                      fontSize: 100,
                    ),
                  ),
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      height: 30,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: _greyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(selectedDate.notifier).state =
                                    dateList100[index];
                                print(ref.read(selectedDate));
                                context.pushNamed(MessageEdit.routeName);
                              },
                              child: Text(
                                dateList100[index],
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateMessage extends StatelessWidget {
  const DateMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
