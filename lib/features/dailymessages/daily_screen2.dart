import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';

import '../../core/common/error_text.dart';
import '../../core/common/loader.dart';
import 'daily_repo.dart';

class DailyMessageScreen2 extends ConsumerStatefulWidget {
  static String routeName = "messages4";
  static String routeURL = "/messages4";
  const DailyMessageScreen2({super.key});

  @override
  DailyMessageScreen2State createState() => DailyMessageScreen2State();
}

class DailyMessageScreen2State extends ConsumerState<DailyMessageScreen2> {
  final TextEditingController _messgaeController = TextEditingController();

  final CollectionReference _coupleCollection =
      FirebaseFirestore.instance.collection('couples');

  Stream<QuerySnapshot>? thedaymessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateList100 = ref.watch(dateStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(' i will win!!2'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text('getDailyMessageProvider'),
          ref.watch(getDailyMessageProvider(dateList100[4])).when(
                data: (message) => Text(message.message),
                error: (error, stackTrace) {
                  print("error");
                  return ErrorText(
                    error: error.toString(),
                  );
                },
                loading: () => const Loader(),
              ),
          const Text('StreamBuilderwhere'),
          StreamBuilder(
            stream: _coupleCollection
                .doc("93zTjlpDFqX0AO0TKvIm")
                .collection("dailymessages")
                .where("messagedate", isEqualTo: dateList100[2])
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                print(dateList100[1]);
                return const CircularProgressIndicator();
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        print(data);
                        return ListTile(
                          title: Text(data['message'] ?? "nomessage"),
                        );
                      })
                      .toList()
                      .cast(),
                ),
              );
            },
          ),
          const Text(
              'ExpandedListView.buildergetDailyMessagesListStreamProvider'),
          Expanded(
            child: ListView.builder(
              itemCount: dateList100.length,
              itemBuilder: (context, index) {
                return ref
                    .watch(
                        getDailyMessagesListStreamProvider(dateList100[index]))
                    .when(
                      data: (data) {
                        return Row(
                          children: [
                            Text(dateList100[index]),
                            const SizedBox(
                              width: 30,
                            ),
                            ref
                                .watch(
                                    getDailyMessageProvider(dateList100[index]))
                                .when(
                                  data: (message) => Text(message.message),
                                  error: (error, stackTrace) {
                                    print("error");
                                    return const ErrorText(
                                      error: "",
                                    );
                                  },
                                  loading: () => const Loader(),
                                ),
                          ],
                        );
                      },
                      error: (error, stackTrace) {
                        return ErrorText(error: error.toString());
                      },
                      loading: () => const Loader(),
                    );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dateList100.length,
              itemBuilder: (context, index) {
                return ref
                    .watch(
                        getDailyMessagesListStreamProvider(dateList100[index]))
                    .when(
                      data: (data) {
                        return const Text("data.first.message");
                      },
                      error: (error, stackTrace) {
                        return ErrorText(error: error.toString());
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
}
