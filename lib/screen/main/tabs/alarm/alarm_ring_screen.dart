import 'package:alarm/alarm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/screen/auth/login_controller.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_controller.dart';

class AlarmRingScreen extends ConsumerWidget {
  static String routeName = "alarmring";
  static String routeURL = "/alarmring";
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({
    super.key,
    required this.alarmSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Logger logger = Logger();

    final getALetter = ref.watch(wakeListStreamProvider);
    final hasCoupleId = ref.watch(getUserStreamProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  DateFormat("yyyy년 MM월 dd일").format(DateTime.now()),
                  style: const TextStyle(fontSize: 40),
                ),
                // Text(
                //   dateList100.first,
                //   style: const TextStyle(fontSize: 10),
                // ),
                getALetter.when(
                  data: (letter) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                            child: letter.first.messagePhoto.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: letter.first.messagePhoto,
                                    placeholder: (context, url) => Container(
                                      height: 70,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                : Container(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Text(
                                    letter.first.message,
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
                                backgroundColor: MaterialStatePropertyAll(Colors.grey),
                              ),
                              onPressed: () {
                                Alarm.stop(alarmSettings.id).then((_) => Navigator.pop(context));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                                child: const Text(
                                  "종료하기",
                                  style: TextStyle(fontSize: 25, color: Colors.white),
                                ),
                              ),
                            ),
                            data.couple == ""
                                ? Container()
                                : ElevatedButton(
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.myPink)),
                                    onPressed: () {
                                      Alarm.stop(alarmSettings.id);
                                      // context.goNamed(ResponseScreen.routeName);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                                      child: const Text(
                                        "답장하기",
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        )
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
