import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../../core/providers/firebase_providers.dart';

class DailyLetter4Screen extends ConsumerStatefulWidget {
  static String routeName = "dailyletter4";
  static String routeURL = "/dailyletter4";
  const DailyLetter4Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DailyLetter4ScreenState();
}

class _DailyLetter4ScreenState extends ConsumerState<DailyLetter4Screen> {
  final String iOSId3 = 'ca-app-pub-5897230132206634/6527311215';
  final String androidId3 = 'ca-app-pub-5897230132206634/8880397412';
  BannerAd? _bannerAd;

  List allMessages = [];

  @override
  void initState() {
    super.initState();

    BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOSId3 : androidId3,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // print('Failed to load a banner ad: ${err.message}');
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
        title: Text(AppLocalizations.of(context)!.answers),
        backgroundColor: Colors.black87,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         context.pushNamed(DailyLetter3Screen.routeName);
        //       },
        //       icon: const Icon(Icons.connecting_airports_outlined))
        // ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[800]),
          ),
          listHistoryMessage.when(
            data: (value) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 220,
                child: ScrollablePositionedList.builder(
                  initialScrollIndex: value.length,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return value[index].sender == uid
                        ? Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: value[index].photo.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: value[index].photo,
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 70,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )
                                    : Container(),
                              ),
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    value[index].message.length > 20
                                        ? SizedBox(
                                            width: 200,
                                            child: Text(
                                              value[index].message,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            child: Text(
                                              value[index].message,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat.MMMd()
                                          .format(value[index].messagedatetime),
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: value[index].photo.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: value[index].photo,
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 70,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )
                                    : Container(),
                              ),
                              ListTile(
                                title: value[index].message.length > 20
                                    ? SizedBox(
                                        width: 200,
                                        child: Text(
                                          value[index].message,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        child: Text(
                                          value[index].message,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                subtitle: Text(
                                  DateFormat.MMMd()
                                      .format(value[index].messagedatetime),
                                  style:
                                      const TextStyle(color: Color(0xFFD72499)),
                                ),
                              ),
                            ],
                          );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              // print("error$error ");
              return Container(
                child: const Center(
                    child: Text(
                  "주고 받은 메세지가 없어요",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                )),
              );
            },
            loading: () => const Loader(),
          ),
          // Container(
          //   height: 1,
          //   decoration: const BoxDecoration(color: Colors.white),
          // ),
          // const SizedBox(
          //   height: 60,
          // ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Row(
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
      ),
    );
  }
}
