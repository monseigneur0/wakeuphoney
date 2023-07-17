import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';

import '../../core/common/loader.dart';
import '../../core/providers/providers.dart';
import '../../core/utils.dart';
import '../dailymessages/daily_controller.dart';
import 'daily_screen.dart';

class DailyMessage2Screen extends ConsumerStatefulWidget {
  static String routeName = "messages5";
  static String routeURL = "/messages5";
  const DailyMessage2Screen({super.key});

  @override
  DailyMessage2ScreenState createState() => DailyMessage2ScreenState();
}

class DailyMessage2ScreenState extends ConsumerState<DailyMessage2Screen> {
  final String iOSTestId = 'ca-app-pub-5897230132206634/3120978311';
  final String androidTestId = 'ca-app-pub-3940256099942544/6300978111';

  BannerAd? _bannerAd;

  List item = [];

  final TextEditingController _messgaeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // BannerAd(
    //   size: AdSize.banner,
    //   adUnitId: Platform.isIOS ? iOSTestId : androidTestId,
    //   listener: BannerAdListener(
    //     onAdLoaded: (ad) {
    //       setState(() {
    //         _bannerAd = ad as BannerAd;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, err) {
    //       print('Failed to load a banner ad: ${err.message}');
    //       ad.dispose();
    //     },
    //   ),
    //   request: const AdRequest(),
    // ).load();
  }

  @override
  Widget build(BuildContext context) {
    final dateList100 = ref.watch(dateStateProvider);

    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);
    bool hasMessage = false;
    final uid = "39xWyVZmEqRxPmmSsOVSE2UvQnE2";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('wake up letters!2'),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(DailyMessageScreen.routeName);
              },
              icon: const Icon(Icons.connecting_airports_outlined))
        ],
        backgroundColor: const Color(0xFFD72499),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
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
                            tileColor: Colors.grey[800],
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
                              child: Text(
                                DateFormat.MMMd().format(listDateTime[index]),
                              ),
                            ),
                            onTap: () {
                              ref.read(selectedDate.notifier).state =
                                  DateFormat.yMMMd()
                                      .format(listDateTime[index]);
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 35),
                              child: Text(DateFormat.MMMd()
                                  .format(listDateTime[index])),
                            ),
                            onTap: () {
                              ref.read(selectedDate.notifier).state =
                                  DateFormat.yMMMd()
                                      .format(listDateTime[index]);
                              ref.read(selectedDateTime.notifier).state =
                                  DateTime.now().add(
                                Duration(days: index),
                              );
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // if (_bannerAd != null)
            //   Align(
            //     alignment: Alignment.bottomCenter,
            //     child: SizedBox(
            //       width: _bannerAd!.size.width.toDouble(),
            //       height: _bannerAd!.size.height.toDouble(),
            //       child: AdWidget(ad: _bannerAd!),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

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
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
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
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFFD72499)),
                    ),
                    child: const Text('Save'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showSnackBar(context, "messgae is saved");
                        Navigator.of(context).pop();
                        final String message = _messgaeController.text;

                        //메세지 작성
                        ref
                            .watch(dailyControllerProvider.notifier)
                            .createDailyMessage(message);
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
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
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
                    labelText: 'message at ${ref.read(selectedDate)}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFFD72499)),
                    ),
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
