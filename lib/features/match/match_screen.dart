import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../alarm/alarm_screen.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_repository.dart';
import '../auth/login_screen.dart';
import '../profile/feedback_screen.dart';
import 'match_controller.dart';

class MatchScreen extends ConsumerStatefulWidget {
  static String routeName = "Matchscreen";
  static String routeURL = "/match";
  const MatchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  static const tenMinutes = 3600;
  int totalSeconds = tenMinutes;
  bool isRunning = false;
  bool onceClickedMatch3 = false;

  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds < 1) {
      if (mounted) {
        setState(() {
          // totalSeconds = tenMinutes;
          onPausePressed();
        });
      }
    } else {
      if (mounted) {
        setState(() {});
      }
      totalSeconds = totalSeconds - 1;
      ref.watch(leftSecondsMatch.notifier).state = totalSeconds;
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
    if (ref.watch(leftSecondsMatch) <= seconds) {
      seconds = ref.watch(leftSecondsMatch);
    }

    var duration = Duration(seconds: seconds);
    // print("duration $duration");
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  void initState() {
    super.initState();
    onStartPressed();
  }

  @override
  void dispose() {
    totalSeconds = 0;
    _honeyCodeController.dispose();
    super.dispose();
  }

  final TextEditingController _honeyCodeController = TextEditingController();

  bool _visiblebear = true;
  int randomNum = 0;

  final _formKey = GlobalKey<FormState>();

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
    final leftTime = ref.watch(leftSecondsMatch);
    final onceClickedMatch2 = ref.watch(onceClickedMatch);

    final hasCoupleId = ref.watch(getUserProfileStreamProvider);
    final userProfileStream = ref.watch(getUserProfileStreamProvider);
    final userCoupleProfileStream = ref.watch(getCoupleProfileStreamProvider);
    late String wow;

    return hasCoupleId.when(
      data: (data) => data.couples.isNotEmpty
          ? Scaffold(
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
                            color: Colors.grey[800],
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
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _visiblebear ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 0),
                        child: CustomPaint(
                            painter: Triangle(Colors.grey.shade800)),
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
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[900],
                elevation: 0,
                title: Text(
                  AppLocalizations.of(context)!.connectto,
                ),
              ),
              backgroundColor: Colors.black,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "서로의 초대코드를 입력하면 연결돼요..",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "내 초대코드 (남은시간) ${format(totalSeconds)} ",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // TextFormField(
                    //   enabled: false,
                    //   initialValue: ref.watch(getMatchCodeViewProvider).when(
                    //         data: (data) {
                    //           if (data.uid.isNotEmpty) {
                    //             wow = data.vertifynumber.toString();
                    //           } else {
                    //             ref
                    //                 .watch(matchConrollerProvider.notifier)
                    //                 .matchProcess();
                    //           }
                    //           return null;
                    //         },
                    //         error: (error, stackTrace) {
                    //           ref
                    //               .watch(matchConrollerProvider.notifier)
                    //               .matchProcess();
                    //           return;
                    //         },
                    //         loading: () => "Loading",
                    //       ),
                    //   style: const TextStyle(fontSize: 40, color: Colors.white),
                    //   maxLength: 6,
                    //   // textInputAction: wow,반드시 설ㅓ할 것 enter누르면 편하니
                    //   inputFormatters: <TextInputFormatter>[
                    //     FilteringTextInputFormatter.digitsOnly,
                    //   ],

                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.grey[900],
                    //     labelStyle: const TextStyle(color: Colors.white),
                    //     hintStyle:
                    //         const TextStyle(fontSize: 30, color: Colors.white),
                    //     focusColor: Colors.red,
                    //     border: InputBorder.none,
                    //   ),
                    // ),
                    // TextFormField(
                    //   enabled: false,
                    //   initialValue: ref.watch(getMatchCodeProvider).when(
                    //         data: (data) {
                    //           return data.vertifynumber.toString();
                    //         },
                    //         error: (error, stackTrace) {
                    //           ref
                    //               .watch(matchConrollerProvider.notifier)
                    //               .matchProcess();
                    //           return;
                    //         },
                    //         loading: () => "Loading",
                    //       ),
                    //   style: const TextStyle(fontSize: 40, color: Colors.white),
                    //   maxLength: 6,
                    //   // textInputAction: wow,반드시 설ㅓ할 것 enter누르면 편하니
                    //   inputFormatters: <TextInputFormatter>[
                    //     FilteringTextInputFormatter.digitsOnly,
                    //   ],

                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.grey[900],
                    //     labelStyle: const TextStyle(color: Colors.white),
                    //     hintStyle:
                    //         const TextStyle(fontSize: 30, color: Colors.white),
                    //     focusColor: Colors.red,
                    //     border: InputBorder.none,
                    //   ),
                    // ),
                    // ref.watch(getMatchCodeProvider).when(
                    //       data: (data) => TextFormField(
                    //         enabled: false,
                    //         initialValue: data.vertifynumber.toString(),

                    //         style: const TextStyle(
                    //             fontSize: 40, color: Colors.white),
                    //         maxLength: 6,
                    //         // textInputAction: wow,반드시 설ㅓ할 것 enter누르면 편하니
                    //         inputFormatters: <TextInputFormatter>[
                    //           FilteringTextInputFormatter.digitsOnly,
                    //         ],

                    //         decoration: InputDecoration(
                    //           filled: true,
                    //           fillColor: Colors.grey[900],
                    //           labelStyle: const TextStyle(color: Colors.white),
                    //           hintStyle: const TextStyle(
                    //               fontSize: 30, color: Colors.white),
                    //           focusColor: Colors.red,
                    //           border: InputBorder.none,
                    //         ),
                    //       ),
                    //       error: (error, stackTrace) {
                    //         ref
                    //             .watch(matchConrollerProvider.notifier)
                    //             .matchProcess();
                    //         return const Center(
                    //             child: Text(
                    //           'error',
                    //           style: TextStyle(color: Colors.white),
                    //         ));
                    //       },
                    //       loading: () => const Loader(),
                    //     ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.grey[800]),
                          ),
                          onPressed: () {
                            setState(() {
                              isRunning ? null : onStartPressed();
                              print("onceClicked $onceClickedMatch2");
                              ref
                                  .watch(matchConrollerProvider.notifier)
                                  .matchProcess();
                              totalSeconds = tenMinutes;
                              ref.watch(onceClickedMatch.notifier).state = true;
                            });
                          },
                          child: const Icon(Icons.refresh),
                          // child: Text(AppLocalizations.of(context)!.generateauthcode),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "상대의 초대코드를 전달받았나요?",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.black,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          // textInputAction: wow,반드시 설ㅓ할 것
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty || value == "") {
                              return null;
                            } else {
                              if (value.length < 6 || value.length > 6
                                  // || value == wow
                                  ) {
                                return null;
                              }
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _honeyCodeController,
                          cursorColor: Colors.white,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[900],
                            labelText: '초대코드 입력',
                            labelStyle: const TextStyle(color: Colors.grey),

                            hintText: '000000',
                            hintStyle: const TextStyle(
                                fontSize: 30, color: Colors.grey),
                            focusColor: Colors.red,
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.black, width: 2.0),
                            // ),
                            // enabledBorder: const OutlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.green, width: 2.0),
                            // ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFD72499))),
                          onPressed: () {
                            if (_honeyCodeController.text.isNotEmpty) {
                              final int honeyCode =
                                  int.parse(_honeyCodeController.text);
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .watch(checkMatchProcessProvider(honeyCode))
                                    .when(
                                        data: (data) {
                                          if (data.uid.isNotEmpty) {
                                            ref
                                                .watch(matchConrollerProvider
                                                    .notifier)
                                                .matchCoupleIdProcessDone(
                                                    data.uid);
                                            print(data.uid);
                                            // PEaTihL8yRdGEknlFfQ9F7XdoUt2 apple
                                            _honeyCodeController.clear();
                                            showSnackBar(context, "inviteed");
                                          }
                                        },
                                        error: (error, stacktrace) =>
                                            showSnackBar(
                                                context, "no invited honey"),
                                        loading: () => const Loader());
                              }
                            }
                          },
                          child:
                              Text(AppLocalizations.of(context)!.connectwith),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              endDrawer: ProfileDrawer(ref: ref),
            ),
      error: (error, stackTrace) {
        print("error hasCoupleId  $error ");
        return const Center(child: Text('error'));
      },
      loading: () => const Loader(),
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
                return "Try again";
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
          // ListTile(
          //   onTap: () {
          //     context.pushNamed(MatchUpScreen.routeName);
          //   },
          //   contentPadding:
          //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //   leading: const Icon(
          //     Icons.alarm,
          //     color: Colors.white,
          //   ),
          //   title: const Text(
          //     "Match Up",
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
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
          //   onTap: () {
          //     context.pushNamed(ResponseScreen.routeName);
          //   },
          //   contentPadding:
          //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //   leading: const Icon(
          //     Icons.feedback_outlined,
          //     color: Colors.white,
          //   ),
          //   title: const Text(
          //     "ResponseScreen",
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     context.pushNamed(PracticeHome.routeName);
          //   },
          //   contentPadding:
          //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //   leading: const Icon(
          //     Icons.feedback_outlined,
          //     color: Colors.white,
          //   ),
          //   title: const Text(
          //     "PracticeHome",
          //     style: TextStyle(color: Colors.white),
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
                        content: Text(AppLocalizations.of(context)!.logout),
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
          const SizedBox(
            height: 50,
          ),
          Platform.isIOS
              ? ListTile(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text(AppLocalizations.of(context)!.delete),
                        content: Text(AppLocalizations.of(context)!.deletesure),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(AppLocalizations.of(context)!.no),
                          ),
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.goNamed(LoginHome.routeName);
                              ref.watch(authRepositoryProvider).deleteUser();
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
                    AppLocalizations.of(context)!.delete,
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
                            title: Text(AppLocalizations.of(context)!.delete),
                            content:
                                Text(AppLocalizations.of(context)!.deletesure),
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
                                  ref
                                      .watch(authRepositoryProvider)
                                      .deleteUser();
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
                    AppLocalizations.of(context)!.delete,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
        ],
      ),
    );
  }
}
