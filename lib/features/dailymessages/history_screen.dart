import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/common/loader.dart';
import '../../core/providers/firebase_providers.dart';
import '../profile/profile_controller.dart';
import 'daily_controller.dart';
import 'daily_letter5_screen.dart';

class HistoryMessageScreen extends ConsumerStatefulWidget {
  static String routeName = "historyMessage";
  static String routeURL = "/historyMessage";
  const HistoryMessageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HistoryMessageScreenState();
}

class _HistoryMessageScreenState extends ConsumerState<HistoryMessageScreen> {
  @override
  Widget build(BuildContext context) {
    User? auser = ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";

    final userProfileStream = ref.watch(getUserProfileStreamProvider);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.black,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         context.goNamed(DailyLetter5Screen.routeName);
        //       },
        //       icon: const Icon(Icons.golf_course))
        // ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[800]),
          ),
          listHistoryMessage.when(
            data: (historyList) => userProfileStream.when(
                data: (user) => SizedBox(
                      height: 600,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true, //scroll impossible
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: historyList.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    historyList[index].sender == uid
                                        ? Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: user.photoURL,
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  height: 50,
                                                ),
                                                width: 50,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                user.displayName,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    user.couplePhotoURL ?? "",
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  height: 50,
                                                ),
                                                width: 50,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                user.coupleDisplayName ?? "",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                    const Icon(Icons.more_vert),
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   icon: const Icon(Icons.more_vert),
                                    //   color: Colors.white,
                                    // )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 60,
                                  ),
                                  historyList[index].message.isNotEmpty
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                          child: Text(
                                            historyList[index].message,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              // Container(
                              //   width: double.infinity,
                              //   height: 50,
                              //   color: Colors.indigo.shade300,
                              // ),
                              historyList[index].photo.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: historyList[index].photo,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Container(
                                        height: 100,
                                      ),
                                      //width: MediaQuery.of(context).size.width,
                                      height: 350,
                                    )
                                  : Container(),
                              historyList[index].messagedate.isNotEmpty
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      child: Text(
                                        historyList[index].messagedate,
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 20,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Row(
                              //       children: [
                              //         IconButton(
                              //           onPressed: () {},
                              //           icon: const Icon(
                              //             Icons.favorite_outline,
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //         IconButton(
                              //           onPressed: () {},
                              //           icon: const Icon(
                              //             CupertinoIcons.chat_bubble,
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //         IconButton(
                              //           onPressed: () {},
                              //           icon: const Icon(
                              //             CupertinoIcons.paperplane,
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     IconButton(
                              //       onPressed: () {},
                              //       icon: const Icon(
                              //         CupertinoIcons.bookmark,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                height: 1,
                                decoration:
                                    BoxDecoration(color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                error: (error, stackTrace) {
                  return const Row(
                    children: [
                      Image(
                        image: AssetImage('assets/human.jpg'),
                        height: 50,
                      ),
                      Text("error, please close app and open app"),
                    ],
                  );
                },
                loading: () => const Loader()),
            error: (error, stackTrace) {
              return const Row(
                children: [
                  Image(
                    image: AssetImage('assets/human.jpg'),
                    height: 50,
                  ),
                  Text("error, please close app and open app")
                ],
              );
            },
            loading: () => const Loader(),
          ),
        ],
      ),
    );
  }
}
