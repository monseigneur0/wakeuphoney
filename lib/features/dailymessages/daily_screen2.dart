import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/constants/firebase_constants.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';

import '../../core/common/loader.dart';
import '../../core/providers/providers.dart';
import '../../core/utils.dart';
import '../dailymessages/daily_controller.dart';

class DailyMessage2Screen extends ConsumerStatefulWidget {
  static String routeName = "messages5";
  static String routeURL = "/messages5";
  const DailyMessage2Screen({super.key});

  @override
  DailyMessage2ScreenState createState() => DailyMessage2ScreenState();
}

class DailyMessage2ScreenState extends ConsumerState<DailyMessage2Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateList100 = ref.watch(dateStateProvider);

    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);
    bool hasMessage = false;
    final uid = ref.watch(authProvider).currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('wake up letters'),
        actions: const [],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          // works well!!!
          // FutureBuilder(
          //     future: _coupleCollection
          //         .doc("93zTjlpDFqX0AO0TKvIm")
          //         .collection("dailymessages")
          //         .doc("Ah5amy72ZlzIwCLYhiiH")
          //         .get()
          //         .then((value) => value.data().toString()),
          //     builder: (context, snapshot) {
          //       // 해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
          //       if (snapshot.hasData == false) {
          //         return const CircularProgressIndicator(); // CircularProgressIndicator : 로딩 에니메이션
          //       }

          //       // error가 발생하게 될 경우 반환하게 되는 부분
          //       else if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}'); // 에러명을 텍스트에 뿌려줌
          //       }

          //       // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 부분
          //       else {
          //         return Text(snapshot.data.toString());
          //       }
          //     }),
          Expanded(
            child: ListView.builder(
              itemCount: listDateTime.length,
              itemBuilder: (context, index) {
                return ref
                    .watch(getDailyMessageProvider(dateList100[index]))
                    .when(
                      data: (message) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: ListTile(
                            tileColor: Colors.grey[600],
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Text(
                                message.message,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(DateFormat.MMMd()
                                  .format(listDateTime[index])),
                            ),
                            onTap: () {
                              ref.read(selectedDate.notifier).state =
                                  DateFormat.yMMMd()
                                      .format(listDateTime[index]);
                              ref.read(selectedDateTime.notifier).state =
                                  listDateTime[index];
                              _update(uid);
                              _messgaeController.text = message.message;
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        print("error$error ");

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: ListTile(
                            tileColor: Colors.grey[800],
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(DateFormat.MMMd()
                                  .format(listDateTime[index])),
                            ),
                            onTap: () {
                              ref.read(selectedDate.notifier).state =
                                  DateFormat.yMMMd()
                                      .format(listDateTime[index]);
                              ref.read(selectedDateTime.notifier).state =
                                  listDateTime[index];
                              _create(uid);
                              _messgaeController.clear();
                            },
                          ),
                        );
                      },
                      loading: () => const Loader(),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _messgaeController = TextEditingController();

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection(FirebaseConstants.usersCollection);

  final _formKey = GlobalKey<FormState>();

  Future<void> _create(String uid) async {
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
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "") {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  autofocus: true,
                  controller: _messgaeController,
                  decoration: InputDecoration(
                      labelText: 'message at ${ref.read(selectedDate)}'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showSnackBar(context, "messgae is saved");
                        Navigator.of(context).pop();
                        final String message = _messgaeController.text;
                        ref.watch(selectedDateTime.notifier).state =
                            DateTime.now();
                        //메세지 작성
                        ref
                            .watch(dailyControllerProvider.notifier)
                            .createDailyMessage(message, uid);
                        CollectionReference users = FirebaseFirestore.instance
                            .collection(FirebaseConstants.usersCollection);
                        var documentSnapshotCoupleId =
                            await users.doc(uid).get();
                        var donf = documentSnapshotCoupleId.data()
                            as Map<String, dynamic>;
                        print(donf["couple"]);
                        print(documentSnapshotCoupleId.get("couple"));
                        // await _userCollection
                        //     .doc(uid)
                        //     .collection("4NQ4WxUEvCet83iVoOLYKNbx8QG2")
                        //     .add({
                        //   "message": message,
                        //   "time": DateTime.now(),
                        //   "messagedate": ref.read(selectedDate),
                        //   "messagedatetime": ref.watch(selectedDateTime),
                        //   "uid": uid,
                        // });
                        // await _coupleCollection
                        //     .doc("93zTjlpDFqX0AO0TKvIm")
                        //     .collection("dailymessages")
                        //     .add({
                        //   "message": message,
                        //   "time": DateTime.now(),
                        //   "messagedate": ref.read(selectedDate),
                        //   "messagedatetime": ref.watch(selectedDateTime),
                        //   "uid": "IZZ1HICxZ8ggCiJihcJKow38LPK2",
                        // });
                      }

                      _messgaeController.clear();
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

  Future<void> _update(String uid) async {
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
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "") {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  autofocus: true,
                  autovalidateMode: AutovalidateMode.always,
                  controller: _messgaeController,
                  decoration: InputDecoration(
                      labelText: 'message at ${ref.read(selectedDate)}'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: const Text('Edit'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("message is edited")));
                        final String message = _messgaeController.text;
                        // await _coupleCollection
                        //     .doc("93zTjlpDFqX0AO0TKvIm")
                        //     .collection("dailymessages")
                        //     .add({
                        //   "message": message,
                        //   "time": DateTime.now(),
                        //   "messagedate": ref.read(selectedDate),
                        //   "messagedatetime": ref.read(selectedDateTime),
                        //   "uid": uid
                        // });

                        _messgaeController.clear();
                        Navigator.of(context).pop();
                      }
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
