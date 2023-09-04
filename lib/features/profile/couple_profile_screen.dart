import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../match/drawer.dart';
import '../match/match_screen.dart';

class CoupleProfileScreen extends ConsumerStatefulWidget {
  static String routeName = "coupleprofilescreen";
  static String routeURL = "/profile";
  const CoupleProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CoupleProfileScreenState();
}

class _CoupleProfileScreenState extends ConsumerState<CoupleProfileScreen> {
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    String lalalala = "";
    ref
        .watch(getUserProfileStreamProvider)
        .whenData((value) => lalalala = value.couple.toString());
    await prefs.setString("coupleuid", lalalala);
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileStream = ref.watch(getUserProfileStreamProvider);
    final userCoupleProfileStream = ref.watch(getCoupleProfileStreamProvider);
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.profile),
        // const Text(
        //   "Profile",
        //   style: TextStyle(
        //       color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        // ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[800]),
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
                          // print("error$error ");
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
                          color: Colors.white,
                        ),
                      ),
                      error: (error, stackTrace) {
                        // print("error$error ");
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
                          // print("error$error ");
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
                          color: Colors.white,
                        ),
                      ),
                      error: (error, stackTrace) {
                        // print("error$error ");
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
              ],
            ),
          ),
        ],
      ),
      endDrawer: ProfileDrawer(ref: ref),
    );
  }
}
