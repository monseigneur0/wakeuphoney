import 'package:alarm/alarm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/common/loader.dart';
import '../../core/providers/providers.dart';
import '../dailymessages/daily_controller.dart';
import '../dailymessages/response_screen.dart';
import '../profile/profile_controller.dart';

class AlarmNewScreen extends ConsumerStatefulWidget {
  static String routeName = "alarmnewring";
  static String routeURL = "/alarmnewring";

  const AlarmNewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmNewScreen();
}

class _AlarmNewScreen extends ConsumerState<AlarmNewScreen> {
  @override
  Widget build(BuildContext context) {
    final dateList100 = ref.watch(dateStateProvider);
    final getCoupleMessage =
        ref.watch(getDailyCoupleMessageProvider(dateList100[0]));
    final hasCoupleId = ref.watch(getUserProfileStreamProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  DateFormat("yyyy년 MM월 dd일 ").format(DateTime.now()),
                  style: const TextStyle(fontSize: 40),
                ),
                getCoupleMessage.when(
                  data: (message) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: message.photo.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: message.photo,
                                    placeholder: (context, url) => Container(
                                      height: 70,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : Container(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Text(
                                    message.message,
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    // logger.d("error");

                    return const Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "받은 편지가 없어요...",
                          style: TextStyle(fontSize: 30),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    );
                  },
                  loading: () => const Loader(),
                ),
                hasCoupleId.when(
                  data: (data) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: CachedNetworkImage(
                            width: 80,
                            imageUrl: data.couplePhotoURL ?? data.photoURL,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                              height: 40,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: const ButtonStyle(
                                iconSize: MaterialStatePropertyAll(30),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.grey),
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width / 15),
                                child: const Text(
                                  "종료하기",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                            ),
                            // hasCoupleId.when(
                            //   data: (data) {
                            //     return
                            data.couple == ""
                                ? Container()
                                : ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color(0xFFD72499))),
                                    onPressed: () {
                                      context.goNamed(ResponseScreen.routeName);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              15),
                                      child: const Text(
                                        "답장하기",
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                    ),
                                  ),
                            // },
                            // error: (error, stackTrace) => Container(),
                            // loading: () => const Loader(),
                            // ),
                          ],
                          // CachedNetworkImage(
                          //       imageUrl: user.couplePhotoURL!),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => Container(),
                  loading: () => const Loader(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}