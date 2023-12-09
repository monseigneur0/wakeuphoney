import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakeuphoney/features/profile/profile_edit_screen.dart';

import '../../core/common/loader.dart';
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
          style: const TextStyle(color: Colors.black),
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
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[800]),
          ),
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
                    color: Colors.grey[500],
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _visiblebear ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 0),
                child: CustomPaint(painter: Triangle(Colors.grey.shade500)),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 100,
                      child: userProfileStream.when(
                        data: (data) => CachedNetworkImage(
                          imageUrl: data.photoURL,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 70,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 1,
                  decoration: BoxDecoration(color: Colors.grey[700]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 100,
                      child: userCoupleProfileStream.when(
                        data: (data) => CachedNetworkImage(
                          imageUrl: data.photoURL,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 70,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                ElevatedButton(
                  onPressed: () =>
                      context.pushNamed(ProfileEditScreen.routeName),
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.myPink)),
                  child: const Text('edit'),
                ),
              ],
            ),
          ),
        ],
      ),
      endDrawer: ProfileDrawer(ref: ref),
    );
  }
}
