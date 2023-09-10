import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';
import 'package:wakeuphoney/features/dailymessages/daily_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';

import '../../core/common/loader.dart';
import '../../core/utils.dart';
import 'couple_letter_screen.dart';
import 'daily_create_screen.dart';

class DailyLetter5Screen extends ConsumerStatefulWidget {
  static String routeName = "dailyletter5";
  static String routeURL = "/dailyletter5";
  const DailyLetter5Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DailyLetter5ScreenState();
}

class _DailyLetter5ScreenState extends ConsumerState<DailyLetter5Screen> {
  final TextEditingController _messgaeController = TextEditingController();

  String imageUrl = "";

  File? bannerFile;
  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> listDateTime =
        ref.watch(dateTimeNotTodayStateProvider);

    // final listHistoryMessage = ref
    //     .watch(createAllMessageListProvider)
    //     .whenData((value) => [listDateTime, ...value]);

    // final listDateTime =
    //     ref.watch(getDailyMessageHistoryListProvider).whenData((value) {
    //   List<DateTime> hello = [];
    //   for (var element in value) {
    //     hello.add(element.messagedatetime);
    //   }
    //   return hello;
    // }).when(data: data, error: error, loading: loading);

    final historyMessage = ref.watch(getDailyMessageHistoryListProvider);

    final listMessage =
        ref.watch(createAllMessageListProvider).whenData((value) => [...value]);

    final user = ref.watch(getUserProfileStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("myletters"),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: user.when(
        data: (data) => data.couples.isEmpty,
        error: (error, stackTrace) {
          return true;
        },
        loading: () => true,
      )
          ? const Center(
              child: Text(
                "No Match, 메세지를 적어주세요",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  decoration: BoxDecoration(color: Colors.grey[700]),
                ),
                Container(
                  height: 5,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 220,
                    child: ListView.builder(
                      itemCount: 100,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return listMessage.when(
                          data: (value) {
                            var messageNow = value.singleWhere(
                              (element) =>
                                  element.messagedate ==
                                  DateFormat.yMMMd()
                                      .format(listDateTime[index]),
                              orElse: () => DailyMessageModel(
                                message: "메세지를 적어주세요",
                                messagedate: "messagedate",
                                messagedatetime: DateTime.now(),
                                time: DateTime.now(),
                                sender: "",
                                reciver: "",
                                photo: "",
                                audio: "",
                                video: "",
                              ),
                            );
                            return messageNow.messagedatetime
                                        .compareTo(DateTime.now()) ==
                                    -1
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: InteractiveViewer(
                                          child: messageNow.photo.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: messageNow.photo,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    height: 70,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                      ListTile(
                                        tileColor: Colors.black,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        title: Text(
                                          messageNow.message,
                                          // "wow",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        subtitle: Text(
                                          DateFormat.MMMd()
                                              .format(listDateTime[index]),
                                          style: TextStyle(
                                              color: Colors.grey[400]),
                                        ),
                                        onTap: () {
                                          ref
                                                  .read(selectedDate.notifier)
                                                  .state =
                                              DateFormat.yMMMd()
                                                  .format(listDateTime[index]);
                                          bool isImageEmpty =
                                              messageNow.photo.isEmpty;
                                          _messgaeController.text =
                                              messageNow.message;
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: InteractiveViewer(
                                          child: messageNow.photo.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: messageNow.photo,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    height: 70,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                      ListTile(
                                        tileColor: Colors.black,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        title: Text(
                                          messageNow.message,
                                          // "wow",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        subtitle: Text(
                                          DateFormat.MMMd()
                                              .format(listDateTime[index]),
                                          style: TextStyle(
                                              color: Colors.grey[400]),
                                        ),
                                        onTap: () {
                                          ref
                                                  .read(selectedDate.notifier)
                                                  .state =
                                              DateFormat.yMMMd()
                                                  .format(listDateTime[index]);
                                          bool isImageEmpty =
                                              messageNow.photo.isEmpty;
                                          _messgaeController.text =
                                              messageNow.message;
                                        },
                                      ),
                                    ],
                                  );
                          },
                          error: (error, stackTrace) {
                            // print("error$error ");
                            return null;
                          },
                          loading: () => const Loader(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
