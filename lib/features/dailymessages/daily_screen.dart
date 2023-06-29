import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/dailymessages/daily_repo.dart';

import '../messages/messages_screen.dart';
import 'daily_message_tile.dart';
import 'daily_screen2.dart';

class DailyMessageScreen extends ConsumerStatefulWidget {
  static String routeName = "messages3";
  static String routeURL = "/messages3";
  const DailyMessageScreen({super.key});

  @override
  DailyMessageScreenState createState() => DailyMessageScreenState();
}

class DailyMessageScreenState extends ConsumerState<DailyMessageScreen> {
  Stream<QuerySnapshot>? thedaymessage;

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DailyRepository().getDailyMessages("93zTjlpDFqX0AO0TKvIm").then((val) {
      setState(() {
        thedaymessage = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> listDateString = ref.watch(dateStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('hello messgaegs i will win!!'),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(DailyMessageScreen2.routeName);
              },
              icon: const Icon(Icons.connecting_airports_outlined))
        ],
      ),
      body: Stack(
        children: [
          const SizedBox(
            height: 20,
          ),

          chatDateMessages(),
          // Expanded(
          //   child: ListView.separated(
          //     itemCount: listDateString.length,
          //     separatorBuilder: (BuildContext context, int index) =>
          //         const SizedBox(
          //       height: 20,
          //     ),
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         leading: const Icon(Icons.chevron_right),
          //         tileColor: Colors.amber[100],
          //         title: Text(listDateString[index].toString()),
          //         // subtitle: StreamBuilder(
          //         //   stream: thedaymessage,
          //         //   builder: (context, AsyncSnapshot snapshot) {
          //         //     return snapshot.hasData
          //         //         ? const Text(" snapshot.data.docs['message']")
          //         //         : Container();
          //         //   },
          //         // ),
          //         onTap: () {
          //           ref.read(selectedDate.notifier).state =
          //               listDateString[index];
          //           _create();
          //           _messgaeController.clear();
          //         },
          //         trailing: const Icon(Icons.chevron_left),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  final TextEditingController _messgaeController = TextEditingController();

  final CollectionReference _coupleCollection =
      FirebaseFirestore.instance.collection('couples');

  Future<void> _create() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _messgaeController,
                decoration: InputDecoration(
                    labelText: 'message at ${ref.read(selectedDate)}'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () async {
                      final String name = _messgaeController.text;
                      await _coupleCollection
                          .doc("93zTjlpDFqX0AO0TKvIm")
                          .collection("dailymessages")
                          .add({
                        "message": name,
                        "time": DateTime.now(),
                        "messagedate": ref.read(selectedDate),
                        "uid": "IZZ1HICxZ8ggCiJihcJKow38LPK2"
                      });

                      _messgaeController.text = '';
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: thedaymessage,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data.docs[index]['message']);
                },
              )
            : Container();
      },
    );
  }

  chatDateMessages() {
    return StreamBuilder(
      stream: thedaymessage,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      date: snapshot.data.docs[index]['messagedate'],
                      time: snapshot.data.docs[index]['time'],
                      sender: snapshot.data.docs[index]['uid'],
                      sentByMe: "IZZ1HICxZ8ggCiJihcJKow38LPK2" ==
                          snapshot.data.docs[index]['uid']);
                },
              )
            : Container();
      },
    );
  }
}
