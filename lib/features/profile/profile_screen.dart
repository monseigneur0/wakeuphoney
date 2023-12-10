import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/image/image_screen.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakeuphoney/features/profile/profile_edit_screen.dart';

import '../../core/common/loader.dart';
import '../../core/providers/providers.dart';
import '../../widgets/drawer.dart';
import 'dart:math';

import 'package:logger/logger.dart';

import '../../core/constants/design_constants.dart';
import '../auth/login_screen.dart';

class CoupleProfileScreen extends ConsumerStatefulWidget {
  static String routeName = "coupleprofilescreen";
  static String routeURL = "/profile";
  const CoupleProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CoupleProfileScreenState();
}

class _CoupleProfileScreenState extends ConsumerState<CoupleProfileScreen> {
  var logger = Logger();

  final TextEditingController _honeyCodeController = TextEditingController();

  bool _visiblebear = true;
  int randomNum = 0;

  final String iOSId4 = 'ca-app-pub-5897230132206634/6527311215';
  final String androidId4 = 'ca-app-pub-5897230132206634/8880397412';
  BannerAd? _bannerAd;

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
  void dispose() {
    _honeyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> messageList = [
      AppLocalizations.of(context)!.hello,
      AppLocalizations.of(context)!.goodmorning,
      AppLocalizations.of(context)!.honeywakeup,
      AppLocalizations.of(context)!.writealetter,
      AppLocalizations.of(context)!.sendaphoto,
      AppLocalizations.of(context)!.checktheletter,
      AppLocalizations.of(context)!.watchthephoto,
      AppLocalizations.of(context)!.replyletter,
      AppLocalizations.of(context)!.canyoureply,
      AppLocalizations.of(context)!.writemorning,
      AppLocalizations.of(context)!.howareyou,
      AppLocalizations.of(context)!.imissyou,
    ];

    final userProfileStream = ref.watch(getUserProfileStreamProvider);
    final userCoupleProfileStream = ref.watch(getCoupleProfileStreamProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myAppBarBackgroundPink,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        // const Text(
        //   "Profile",
        //   style: TextStyle(
        //       color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        // ),
      ),
      backgroundColor: AppColors.myBackgroundPink,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedOpacity(
                      opacity: _visiblebear ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 0),
                      child: Container(
                        width: 250,
                        height: 75,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(19),
                            topRight: Radius.circular(19),
                            bottomLeft: Radius.circular(19),
                            bottomRight: Radius.circular(19),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              messageList[randomNum],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _visiblebear ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 0),
                      child:
                          CustomPaint(painter: Triangle(Colors.grey.shade400)),
                    ),
                    const SizedBox(height: 30),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _visiblebear = !_visiblebear;
                          randomNum = Random().nextInt(10);
                        });
                      },
                      icon: Image.asset(
                        'assets/alarmbearno.png',
                      ),
                      iconSize: 50,
                    ),
                  ],
                ),
                Container(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 120,
                            child: userProfileStream.when(
                              data: (data) => ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: CachedNetworkImage(
                                  width: 120,
                                  imageUrl: data.photoURL,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => Container(
                                    height: 40,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              error: (error, stackTrace) {
                                // logger.d("error$error ");
                                return const Image(
                                  image: AssetImage('assets/human.jpg'),
                                  height: 30,
                                );
                              },
                              loading: () => const Loader(),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          userProfileStream.when(
                            data: (data) => Text(
                              data.displayName,
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                            error: (error, stackTrace) {
                              // logger.d("error$error ");
                              return const Text(
                                "no couple",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              );
                            },
                            loading: () => const Loader(),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.favorite,
                        color: AppColors.myPink,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 120,
                            child: userCoupleProfileStream.when(
                              data: (data) => ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: CachedNetworkImage(
                                  width: 120,
                                  imageUrl: data.photoURL,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => Container(
                                    height: 40,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              error: (error, stackTrace) {
                                // logger.d("error$error ");
                                return const Image(
                                  image: AssetImage('assets/human.jpg'),
                                  height: 30,
                                );
                              },
                              loading: () => const Loader(),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          userCoupleProfileStream.when(
                            data: (data) => Text(
                              data.displayName,
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                            error: (error, stackTrace) {
                              // logger.d("error$error ");
                              return const Text(
                                "no couple",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              );
                            },
                            loading: () => const Loader(),
                          ),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () =>
                      //       context.pushNamed(ProfileEditScreen.routeName),
                      //   style: const ButtonStyle(
                      //       backgroundColor:
                      //           MaterialStatePropertyAll(AppColors.myPink)),
                      //   child: const Text('edit'),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     context.pushNamed(ImageScreen.routeName);
                      //   },
                      //   style: const ButtonStyle(
                      //       backgroundColor:
                      //           MaterialStatePropertyAll(AppColors.myPink)),
                      //   child: const Text('ImageScreen'),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
      endDrawer: const ProfileEditScreen(),
    );
  }
}
