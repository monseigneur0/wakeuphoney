import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakeuphoney/features/auth/auth_controller.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../alarm/alarm_screen.dart';
import '../auth/auth_repository.dart';
import '../auth/login_screen.dart';
import 'feedback_screen.dart';

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

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final userprofile = ref.watch(getMyUserDataProvider);
    return Drawer(
      backgroundColor: Colors.grey[800],
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/alarmbearno.png',
            ),
            iconSize: 50,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            userprofile.when(
              data: (data) => data.displayName,
              error: (error, stackTrace) {
                // print("error$error ");
                return "no couple";
              },
              loading: () => "Loading",
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              context.pushNamed(AlarmHome.routeName);
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.alarm,
              color: Colors.white,
            ),
            title: Text(
              AppLocalizations.of(context)!.alarms,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            onTap: () {
              context.pushNamed(FeedbackScreen.routeName);
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.feedback_outlined,
              color: Colors.white,
            ),
            title: Text(
              AppLocalizations.of(context)!.feedback,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          // ListTile(
          //   onTap: () {},
          //   selected: true,
          //   selectedColor: Theme.of(context).primaryColor,
          //   contentPadding:
          //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //   leading: const Icon(Icons.group),
          //   title: Text(
          //     userprofile.email.toString(),
          //     style: const TextStyle(color: Colors.white),
          //   ),
          // ),
          // ListTile(
          //   onTap: () {},
          //   selected: true,
          //   selectedColor: Theme.of(context).primaryColor,
          //   contentPadding:
          //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //   leading: const Icon(Icons.group),
          //   title: Text(
          //     userprofile.uid.toString(),
          //     style: const TextStyle(color: Colors.black),
          //   ),
          // ),
          Platform.isIOS
              ? ListTile(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text(AppLocalizations.of(context)!.sure),
                        content: const Text("Plx don't go"),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(AppLocalizations.of(context)!.no),
                          ),
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.goNamed(LoginHome.routeName);
                              ref.watch(authRepositoryProvider).logout();
                            },
                            isDestructiveAction: true,
                            child: Text(AppLocalizations.of(context)!.yes),
                          ),
                        ],
                      ),
                    );
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              : ListTile(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.logout),
                            content: Text(AppLocalizations.of(context)!.sure),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.goNamed(LoginHome.routeName);
                                  ref.watch(authRepositoryProvider).logout();
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
        ],
      ),
    );
  }
}
