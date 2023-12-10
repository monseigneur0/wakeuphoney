import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/common/loader.dart';
import '../../core/constants/constants.dart';
import '../../core/constants/design_constants.dart';
import '../../core/providers/firebase_providers.dart';
import '../profile/profile_controller.dart';
import 'daily_controller.dart';

class HistoryMessageScreen extends ConsumerStatefulWidget {
  static String routeName = "historyMessage";
  static String routeURL = "/historyMessage";
  const HistoryMessageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HistoryMessageScreenState();
}

class _HistoryMessageScreenState extends ConsumerState<HistoryMessageScreen> {
  //letter_day_screen에서 사용
  final String iOSId4 = 'ca-app-pub-5897230132206634/2698132449';
  final String androidId4 = 'ca-app-pub-5897230132206634/2588066206';
  BannerAd? _bannerAd;

  List allMessages = [];

  @override
  void initState() {
    super.initState();

    BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOSId4 : androidId4,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // logger.d('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    ).load();
  }

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
                  DateTime.now().second -
                  1)))) //23:59:59
          .toList();
    });
    final user = ref.watch(getUserProfileStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "기록",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.myAppBarBackgroundPink,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         context.goNamed(DailyLetter5Screen.routeName);
        //       },
        //       icon: const Icon(Icons.golf_course))
        // ],
      ),
      backgroundColor: AppColors.myBackgroundPink,
      body: user.when(
        data: (data) => data.couples.isEmpty
            ? const Center(
                child: Text(
                  "프로필 페이지에서 상대를 초대해주세요.",
                  style: TextStyle(color: Colors.black),
                ),
              )
            : Column(
                children: [
                  Container(
                    height: 1,
                    decoration: BoxDecoration(color: Colors.grey[800]),
                  ),
                  listHistoryMessage.when(
                    data: (historyList) => userProfileStream.when(
                        data: (user) => SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  Constants.adbannerline,
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
                                                        placeholder:
                                                            (context, url) =>
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
                                                            color:
                                                                Colors.black),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            user.couplePhotoURL ??
                                                                "",
                                                        fit: BoxFit.fill,
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          height: 50,
                                                        ),
                                                        width: 50,
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        user.coupleDisplayName ??
                                                            "",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )
                                                    ],
                                                  ),
                                            // const Icon(Icons.more_vert),
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
                                                      color: Colors.black,
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
                                              imageUrl:
                                                  historyList[index].photo,
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  Container(
                                                height: 100,
                                              ),
                                              //width: MediaQuery.of(context).size.width,
                                              height: 350,
                                            )
                                          : Container(),
                                      historyList[index].messagedate.isNotEmpty
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              child: Text(
                                                historyList[index].messagedate,
                                                style: TextStyle(
                                                  color: Colors.grey[700],
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
                                        decoration: BoxDecoration(
                                            color: Colors.grey[800]),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_bannerAd != null)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
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
      // endDrawer: ProfileDrawer(ref: ref),
    );
  }
}
