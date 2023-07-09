import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';

import '../../core/common/loader.dart';
import '../../practice_home_screen.dart';
import '../alarm/alarm_screen.dart';
import '../auth/auth_repository.dart';

class CoupleProfileScreen extends ConsumerWidget {
  static String routeName = "coupleprofilescreen";
  static String routeURL = "/coupleprofilescreen";
  const CoupleProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userprofile = ref.watch(authRepositoryProvider).currentUser!;
    final userProfileStream = ref.watch(getUserProfileStreamProvider);

    final coupleUid = ref.watch(getUserProfileStreamProvider);
    final coupleProfile = ref.watch(
        getUserProfileStreamByIdProvider(coupleUid.value!.couples.first));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "My Honey",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Honey Name", style: TextStyle(fontSize: 17)),
                coupleProfile.when(
                  data: (data) => Text(data.displayName),
                  error: (error, stackTrace) {
                    print("error$error ");
                    return const Text("no couple");
                  },
                  loading: () => const Loader(),
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 17)),
                coupleProfile.when(
                  data: (data) => Text(data.email),
                  error: (error, stackTrace) {
                    print("error$error ");
                    return const Text("no couple");
                  },
                  loading: () => const Loader(),
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("couple Id", style: TextStyle(fontSize: 17)),
                Text(
                    userProfileStream.when(
                      data: (data) => data.couple,
                      error: (error, stackTrace) {
                        print("error    $error ");
                        return "error ";
                      },
                      loading: () => "const Loader()",
                    ),
                    style: const TextStyle(fontSize: 10)),
                // Text(userProvideruid.hasValue ? "hasValue" : "no val"),
              ],
            ),
            Text(ref.watch(coupleIdStateProvider).toString()),
            Text(ref.watch(coupleIdFutureProvider).when(
                  data: (data) => data["couple"],
                  error: (error, stackTrace) {
                    return "error$error ";
                  },
                  loading: () => "const Loader()",
                ))
          ],
        ),
      ),
      endDrawer: ProfileDrawer(userprofile: userprofile, ref: ref),
    );
  }
}

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.userprofile,
    required this.ref,
  });

  final User userprofile;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            userprofile.displayName ?? "no name",
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
              context.pushNamed(PracticeHome.routeName);
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Homes",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {},
            selected: true,
            selectedColor: Theme.of(context).primaryColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: Text(
              userprofile.email.toString(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {},
            selected: true,
            selectedColor: Theme.of(context).primaryColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: Text(
              userprofile.uid.toString(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
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
                            ref
                                .watch(authRepositoryProvider)
                                .logout()
                                .then((value) =>
                                    context.goNamed(AlarmHome.routeName))
                                .then((value) => Navigator.of(context).pop());
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
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text("Plx dont go"),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("No"),
                    ),
                    CupertinoDialogAction(
                      onPressed: () {
                        ref
                            .watch(authRepositoryProvider)
                            .logout()
                            .then(
                                (value) => context.goNamed(AlarmHome.routeName))
                            .then((value) => Navigator.of(context).pop());
                      },
                      isDestructiveAction: true,
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black)),
            child: const Text('logout check'),
          ),
        ],
      ),
    );
  }
}
