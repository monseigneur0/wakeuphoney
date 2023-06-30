import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'daily_repo.dart';
import 'message2_screen.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  static String routeName = "messages";
  static String routeURL = "/messages";

  const MessagesScreen({super.key});

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends ConsumerState<MessagesScreen> {
  final _blackColor = const Color(0xFF1F2123);
  final _greyColor = const Color(0xFF464A4F);

  Stream<QuerySnapshot>? thedaymessage;
  final CollectionReference coupleCollection =
      FirebaseFirestore.instance.collection("couples");

  final TextEditingController _nameController = TextEditingController();

  final CollectionReference _coupleCollection =
      FirebaseFirestore.instance.collection('couples');

  @override
  Widget build(BuildContext context) {
    final dateList100 = ref.watch(dateStateProvider);

    final List<String> listDateString = ref.watch(dateStateProvider);

    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);

    bool hasMessage = true;

    const title = 'Messgae_daily';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text(title)),
          actions: [
            IconButton(
                onPressed: () {
                  context.pushNamed(Message2Screen.routeName);
                },
                icon: const Icon(Icons.connecting_airports_outlined))
          ],
        ),
        backgroundColor: _blackColor,
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: dateList100.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Container(
                      height: 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: _greyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    print(ref.read(selectedDate));
                                    ref.read(selectedDate.notifier).state =
                                        DateFormat.yMMMd()
                                            .format(listDateTime[index]);
                                    ref.read(selectedDateTime.notifier).state =
                                        listDateTime[index];
                                    _nameController.text = '';
                                    _create();
                                  },
                                  child: Text(
                                    dateList100[index],
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              StreamBuilder(
                                stream: thedaymessage,
                                builder: (context, snapshot) {
                                  if (DateFormat.yMMMd()
                                          .format(listDateTime[index]) ==
                                      snapshot.data?.docs[index]
                                          ['messagedate']) {
                                    hasMessage = true;
                                    coupleCollection
                                        .doc("93zTjlpDFqX0AO0TKvIm")
                                        .collection("dailymessages")
                                        .where(
                                          "messagedate",
                                          isEqualTo: DateFormat.yMMMd()
                                              .format(listDateTime[index]),
                                        )
                                        .get()
                                        .then(
                                      (value) {
                                        for (var docSnapshot in value.docs) {
                                          Text('$docSnapshot');
                                          print(DateFormat.yMMMd()
                                              .format(listDateTime[index]));
                                        }
                                      },
                                    );

                                    return Text(
                                        snapshot.data?.docs[index]['message']);
                                  } else {
                                    // return const Text("no messages");
                                    coupleCollection
                                        .doc("93zTjlpDFqX0AO0TKvIm")
                                        .collection("dailymessages")
                                        .where(
                                          "messagedate",
                                          isEqualTo: DateFormat.yMMMd()
                                              .format(listDateTime[index]),
                                        )
                                        .get()
                                        .then(
                                      (value) {
                                        for (var docSnapshot in value.docs) {
                                          Text('$docSnapshot');
                                          final gogogod = docSnapshot;
                                          print(DateFormat.yMMMd()
                                              .format(listDateTime[index]));
                                          return gogogod;
                                        }
                                      },
                                    );
                                    return const Text("no messages");
                                  }
                                },
                              ),
                              ElevatedButton(
                                onPressed: () => _update(),
                                child: const Icon(Icons.edit),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {}),
                            ],
                          ),
                          // streamValue.when(data: (data) {
                          //   print(data);
                          //   return Wrap(children: [
                          //     Text(
                          //       data.toString(),
                          //       style: const TextStyle(fontSize: 10),
                          //     ),
                          //   ]);
                          // }, error: (Object error, StackTrace stacktrace) {
                          //   print(error.toString());
                          //   return Text(error.toString());
                          // }, loading: () {
                          //   return const CircularProgressIndicator();
                          // }),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 40),
              ),
            )
          ],
        ),
      ),
    );
  }

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
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        await _coupleCollection
                            .doc("93zTjlpDFqX0AO0TKvIm")
                            .collection("dailymessages")
                            .add({
                          "message": name,
                          "time": DateTime.now(),
                          "messagedate": ref.read(selectedDate),
                          "messgaedatetime": ref.read(selectedDateTime),
                          "uid": "IZZ1HICxZ8ggCiJihcJKow38LPK2"
                        });

                        _nameController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(ref.read(selectedDate)),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _update(
      [DocumentSnapshot? documentSnapshot, String? datestring]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
    }
    final datestringview = datestring;

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
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        await _coupleCollection
                            .doc("93zTjlpDFqX0AO0TKvIm")
                            .collection("dailymessages")
                            .doc(documentSnapshot!.id)
                            .update({
                          "message": name,
                          "time": DateTime.now,
                          "uid": "IZZ1HICxZ8ggCiJihcJKow38LPK2"
                        });
                        _nameController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(ref.read(selectedDate)),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String messageId) async {
    await _coupleCollection
        .doc("93zTjlpDFqX0AO0TKvIm")
        .collection("dailymessages")
        .doc(messageId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }
}
