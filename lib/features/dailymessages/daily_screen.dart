import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakeuphoney/features/dailymessages/daily_model.dart';

import '../../core/common/loader.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/providers/firebase_providers.dart';
import '../../core/providers/providers.dart';
import '../../core/utils.dart';
import 'daily_controller.dart';
import 'daily_screen2.dart';

class DailyMessageScreen extends ConsumerStatefulWidget {
  static String routeName = "messages3";
  static String routeURL = "/messages3";
  const DailyMessageScreen({super.key});

  @override
  DailyMessageScreenState createState() => DailyMessageScreenState();
}

class DailyMessageScreenState extends ConsumerState<DailyMessageScreen> {
  List item = [];

  Stream<QuerySnapshot>? thedaymessage;

  AutoScrollController _controller = AutoScrollController();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  bool firstWidgetBuild = true;

  @override
  void initState() {
    super.initState();
    _controller = AutoScrollController();
    item = List<String>.generate(
      100,
      (index) => DateFormat.yMMMd().format(
        DateTime.now().add(
          Duration(days: index),
        ),
      ),
    );
  }

  void _scrollToTop() {
    setState(() {
      _controller.animateTo(_controller.position.minScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.bounceOut);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);

    final uid = ref.watch(authProvider).currentUser!.uid;
    final messageList = ref.watch(getDailyMessageListProvider);

    int lengthoflist = 0;
    messageList.whenData(
      (value) => lengthoflist = value
          .where((element) =>
              element.sender == ref.watch(authProvider).currentUser!.uid)
          .length,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _controller.animateTo(_controller.position.minScrollExtent,
          //     duration: const Duration(milliseconds: 300),
          //     curve: Curves.bounceOut);
          // itemScrollController.scrollTo(
          //     index: ref.watch(numberStateProvider),
          //     duration: const Duration(milliseconds: 300),
          //     curve: Curves.easeInOutCubic);
          _create;
        },
        child: const Icon(
          Icons.swap_vert_outlined,
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('wake up letters1'),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(DailyMessage2Screen.routeName);
              },
              icon: const Icon(Icons.connecting_airports_outlined))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              scrollOffsetController: scrollOffsetController,
              itemPositionsListener: itemPositionsListener,
              scrollOffsetListener: scrollOffsetListener,
              itemCount: lengthoflist,
              itemBuilder: (context, index) {
                firstWidgetBuild
                    ? WidgetsBinding.instance.addPostFrameCallback(
                        (timeStamp) {
                          itemScrollController.scrollTo(
                              index: ref.watch(numberStateProvider),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOutCubic);
                          firstWidgetBuild = false;
                        },
                      )
                    : null;
                return Scrollbar(
                  key: ValueKey(index),
                  controller: _controller,
                  child: messageList.when(
                    error: (error, stackTrace) {
                      print("error$error ");
                      return const Text("error");
                    },
                    loading: () => const Loader(),
                    data: (message) {
                      if (message[index].sender ==
                          ref.watch(authProvider).currentUser!.uid) {
                        List<DailyMessageModel> newList = message
                            .where((element) =>
                                element.sender ==
                                ref.watch(authProvider).currentUser!.uid)
                            .toList();
                        newList[index].messagedate ==
                                DateFormat.yMMMd().format(DateTime.now())
                            ? ref.watch(numberStateProvider.notifier).state =
                                index +
                                    message
                                        .where((element) =>
                                            element.sender ==
                                            ref
                                                .watch(authProvider)
                                                .currentUser!
                                                .uid)
                                        .length
                            : null;
                        print(index);
                        message.sort((a, b) =>
                            a.messagedatetime.compareTo(b.messagedatetime));
                      }
                      return message[index].sender ==
                              ref.watch(authProvider).currentUser!.uid
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              child: ListTile(
                                tileColor: Colors.grey[800],
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  child: Text(
                                    message[index].message,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(DateFormat.MMMd()
                                      .format(message[index].messagedatetime)),
                                ),
                                onTap: () {
                                  ref.read(selectedDate.notifier).state =
                                      DateFormat.yMMMd()
                                          .format(listDateTime[index]);
                                  ref.read(selectedDateTime.notifier).state =
                                      listDateTime[index];
                                  _update(uid);
                                  _messgaeController.text =
                                      message[index].message;
                                },
                              ),
                            )
                          : Padding(
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
                                    message[index].message,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(DateFormat.MMMd()
                                      .format(message[index].messagedatetime)),
                                ),
                                onTap: () {
                                  ref.read(selectedDate.notifier).state =
                                      DateFormat.yMMMd()
                                          .format(listDateTime[index]);
                                  ref.read(selectedDateTime.notifier).state =
                                      listDateTime[index];
                                  _update(uid);
                                  _messgaeController.text =
                                      message[index].message;
                                },
                              ),
                            );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _messgaeController = TextEditingController();

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
                            .createDailyMessage(message);
                        CollectionReference users = FirebaseFirestore.instance
                            .collection(FirebaseConstants.usersCollection);
                        var documentSnapshotCoupleId =
                            await users.doc(uid).get();
                        var donf = documentSnapshotCoupleId.data()
                            as Map<String, dynamic>;
                        print(donf["couple"]);
                        print(documentSnapshotCoupleId.get("couple"));
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
                        ref
                            .watch(dailyControllerProvider.notifier)
                            .updateDailyMessage(message, uid);

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
