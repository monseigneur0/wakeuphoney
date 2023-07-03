import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';

import '../../core/common/loader.dart';
import '../../practice_home_screen.dart';
import '../alarm/alarm_screen.dart';
import '../auth/auth_repository.dart';
import 'couple_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static String routeName = "profilescreen";
  static String routeURL = "/profilescreen";
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _visible = false;

  static const tenMinutes = 10;
  int totalSeconds = tenMinutes;
  bool isRunning = false;

  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds < 1) {
      setState(() {
        // totalSeconds = tenMinutes;
        onPausePressed();
        _visible = false;
      });
    } else {
      setState(() {});
      totalSeconds = totalSeconds - 1;
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _visible = false;
  }

  final TextEditingController _honeyCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userprofile = ref.watch(authRepositoryProvider).currentUser!;
    final userProfileStream = ref.watch(getUserProfileStreamProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "My Honey",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(CoupleProfileScreen.routeName);
              },
              icon: const Icon(Icons.connecting_airports_outlined))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 10,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 17)),
                Text(userprofile.displayName ?? "no name",
                    style: const TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 17)),
                Text(userprofile.email ?? "no email",
                    style: const TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("uid Id", style: TextStyle(fontSize: 17)),
                Text(userprofile.uid, style: const TextStyle(fontSize: 10)),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Couple uid", style: TextStyle(fontSize: 17)),
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
            _visible
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 10),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "") {
                            return 'Please enter honey code';
                          } else {
                            if (value.length < 6 || value.length > 6) {
                              return 'not 6 numbers';
                            }
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.always,
                        controller: _honeyCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Write 6 numbers',
                          hintText: '123456',
                        ),
                      ),
                    ),
                  ),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red)),
              onPressed: () {
                final int honeyCode = int.parse(_honeyCodeController.text);
                if (_formKey.currentState!.validate()) {
                  if (ref
                      .watch(checkMatchProcessProvider(honeyCode))
                      .hasValue) {
                    showSnackBar(context, "matched");
                    ref.watch(checkMatchProcessProvider(honeyCode)).when(
                          data: (data) => ref
                              .watch(coupleIdProvider.notifier)
                              .state = data.uid,
                          error: (error, stackTrace) {
                            print("error$error ");
                          },
                          loading: () => const Loader(),
                        );
                    ref.watch(getMatchProcessProvider);
                    _honeyCodeController.clear();
                    ref
                        .watch(profileControllerProvider.notifier)
                        .matchCoupleIdProcessDone(honeyCode);
                  } else {
                    showSnackBar(context, "no matching honey");
                  }
                }
              },
              child: const Text("Match"),
            ),
            _visible
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      // Call setState. This tells Flutter to rebuild the
                      // UI with the changes.
                      setState(() {
                        _visible = !_visible;
                        isRunning ? null : onStartPressed();
                        ref
                            .watch(profileControllerProvider.notifier)
                            .matchProcess();
                        totalSeconds = tenMinutes;
                      });
                    },
                    child: const Text("generate honey code")),
            AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              // The green box must be a child of the AnimatedOpacity widget.
              child: Column(
                children: [
                  Text(
                    ref.watch(getMatchProcessProvider).when(
                          data: (data) => (data.vertifynumber.toString()),
                          error: (error, stackTrace) {
                            print("error getMatchProcessProvider   $error ");
                            return "error ";
                          },
                          loading: () => "const Loader()",
                        ),
                    style: const TextStyle(fontSize: 30),
                  ),
                  Text(
                    ref.watch(getMatchProcessProvider).when(
                          data: (data) => (data.time.toString()),
                          error: (error, stackTrace) {
                            print("error getMatchProcessProvider   $error ");
                            return "error ";
                          },
                          loading: () => "const Loader()",
                        ),
                  ),
                  Text(
                    format(totalSeconds),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                onPressed: () {
                  isRunning ? null : onStartPressed();
                  // Call setState. This tells Flutter to rebuild the
                  // UI with the changes.
                  setState(() {
                    _visible = !_visible;
                  });
                },
                child: const Text("view honey code")),
            Text(isRunning.toString()),
            Text(_visible.toString()),
          ],
        ),
      ),
      drawer: ProfileDrawer(userprofile: userprofile, ref: ref),
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
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
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
          )
        ],
      ),
    );
  }
}
