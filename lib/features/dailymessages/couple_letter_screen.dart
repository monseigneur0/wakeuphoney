import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../../core/providers/providers.dart';
import 'daily_controller.dart';

class CoupleLetterScreen extends ConsumerStatefulWidget {
  static String routeName = "coupleLetter";
  static String routeURL = "/coupleLetter";
  const CoupleLetterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CoupleLetterScreenState();
}

class _CoupleLetterScreenState extends ConsumerState<CoupleLetterScreen> {
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
          // print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    const uid = "IZZ1HICxZ8ggCiJihcJKow38LPK2";

    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);

    final listMessageHistory =
        ref.watch(getDailyCoupleMessageHistoryListProvider).whenData(
              (value) => value
                  .filter((t) => t.messagedatetime.isBefore(DateTime.now().add(
                      Duration(
                          seconds: 24 * 60 * 60 -
                              DateTime.now().hour * 3600 -
                              DateTime.now().minute * 60 -
                              DateTime.now().second))))
                  .toList(),
            );

    allMessages = [listMessageHistory, ...listDateTime];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myanswers),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[800]),
          ),
          listMessageHistory.when(
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
                                    : Container(
                                        height: 70,
                                      ),
                              ),
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    value[index].message.length > 30
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
                              Container(
                                height: 1,
                                decoration:
                                    BoxDecoration(color: Colors.grey[600]),
                              ),
                              Container(
                                height: 5,
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
                                    : Container(
                                        height: 70,
                                      ),
                              ),
                              ListTile(
                                title: value[index].message.length > 30
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
                              Container(
                                height: 1,
                                decoration:
                                    BoxDecoration(color: Colors.grey[600]),
                              ),
                              Container(
                                height: 5,
                              ),
                            ],
                          );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              // print("error$error ");
              return Container();
            },
            loading: () => const Loader(),
          ),
          // Container(
          //   height: 1,
          //   decoration: const BoxDecoration(color: Colors.white),
          // ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
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
    );
  }
}
