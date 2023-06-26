import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'messages_screen.dart';
import 'messgaes_repo.dart';

class Message2Screen extends ConsumerStatefulWidget {
  static String routeName = "messages2";
  static String routeURL = "/messages2";
  const Message2Screen({super.key});

  @override
  Message2ScreenState createState() => Message2ScreenState();
}

class Message2ScreenState extends ConsumerState<Message2Screen> {
  Stream<QuerySnapshot>? thedaymessage;

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    MessagesRepo().getChats("93zTjlpDFqX0AO0TKvIm").then((val) {
      setState(() {
        thedaymessage = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> listDateString = ref.watch(dateStateProvider);
    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);
    bool hasMessage = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('hello messgaegs i will win!!'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
              future: _coupleCollection
                  .doc("93zTjlpDFqX0AO0TKvIm")
                  .collection("dailymessages")
                  .doc("Ah5amy72ZlzIwCLYhiiH")
                  .get()
                  .then((value) => value.data().toString()),
              builder: (context, snapshot) {
                // 해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
                if (snapshot.hasData == false) {
                  return const CircularProgressIndicator(); // CircularProgressIndicator : 로딩 에니메이션
                }

                // error가 발생하게 될 경우 반환하게 되는 부분
                else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // 에러명을 텍스트에 뿌려줌
                }

                // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 부분
                else {
                  return Text(snapshot.data.toString());
                }
              }),
          Expanded(
            child: ListView.separated(
              itemCount: listDateString.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 20,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.chevron_right),
                  tileColor: Colors.amber[100],
                  title: Text(DateFormat.yMMMd().format(listDateTime[index])),
                  // subtitle: StreamBuilder(
                  //   stream: ref.watch(getMessageOfDayProvider(listDateString[index].toString()).),
                  //   builder: (context, snapshot) {
                  //     return Text("dd");
                  //   },
                  // ),
                  // subtitle: ref
                  //     .watch(getMessageOfDayProvider(
                  //         listDateString[index].toString()))
                  //     .when(
                  //       data: (messageModels) =>
                  //           Text(messageModels.first.message),
                  //       error: (error, stackTrace) {
                  //         print(error.toString());
                  //         return ErrorText(error: error.toString());
                  //       },
                  //       loading: () => const Loader(),
                  //     ),
                  // subtitle: StreamBuilder(
                  //   stream: thedaymessage,
                  //   builder: (context, snapshot) {
                  //     return DateFormat.yMMMd().format(listDateTime[index]) ==
                  //             snapshot.data?.docs[index]['messagedate']
                  //         ? Text(snapshot.data?.docs[index]['message'])
                  //         : const Text("no messages");
                  //   },
                  // ),
                  subtitle: StreamBuilder(
                    stream: thedaymessage,
                    builder: (context, snapshot) {
                      Timestamp t = snapshot.data?.docs[index]
                              ['messgaedatetime'] ??
                          Timestamp.now();
                      DateTime newdate = t.toDate();

                      print("newdate");
                      print(newdate);
                      if (DateFormat.yMMMd().format(listDateTime[index]) ==
                          snapshot.data?.docs[index]['messagedate']) {
                        print(snapshot.data?.docs[index]['messgaedatetime']);
                        // if (listDateTime[index].year ==  snapshot.data?.docs[index]['messgaedatetime'] &&) {
                        print(DateTime.now());
                        print(DateTime.utc(
                            listDateTime[index].year,
                            listDateTime[index].month,
                            listDateTime[index].day));
                        print(DateTime(
                            listDateTime[index].year,
                            listDateTime[index].month,
                            listDateTime[index].day));
                        hasMessage = true;
                        return Text(snapshot.data?.docs[index]['message'] +
                            snapshot.data?.docs[index]['messagedate']);
                      } else {
                        return Text(
                            "no messages${DateFormat.yMMMd().format(listDateTime[index])}");
                      }
                    },
                  ),
                  onTap: () {
                    ref.read(selectedDate.notifier).state =
                        DateFormat.yMMMd().format(listDateTime[index]);
                    ref.read(selectedDateTime.notifier).state =
                        listDateTime[index];
                    hasMessage ? _update() : _create();
                    _messgaeController.clear();
                  },
                  trailing: const Icon(Icons.chevron_left),
                );
              },
            ),
          ),
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
                        "messgaedatetime": ref.read(selectedDateTime),
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

  Future<void> _update() async {
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
                        "messgaedatetime": ref.read(selectedDateTime),
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
}
