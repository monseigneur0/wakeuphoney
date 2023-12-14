import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/constants/design_constants.dart';
import 'package:wakeuphoney/features/auth/auth_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakeuphoney/features/auth/login_email_screen.dart';

class LoginHome extends ConsumerStatefulWidget {
  static String routeName = "login";
  static String routeURL = "/login";
  const LoginHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginHomeState();
}

class _LoginHomeState extends ConsumerState<LoginHome> {
  bool _visible = true;
  int randomNum = 0;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         ref.watch(authRepositoryProvider).isLoggedIn
          //             ? context.pushNamed(PracticeHome.routeName)
          //             : context.pushNamed(LoginHome.routeName);
          //       },
          //       icon: const Icon(
          //         Icons.connecting_airports_outlined,
          //         color: AppColors.myPink,
          //       ))
          // ],
          backgroundColor: AppColors.myAppBarBackgroundPink,
          title: const Text('일어나곰'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 250,
                      height: 85,
                      padding: const EdgeInsets.all(15),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            messageList[randomNum],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 0),
                child: CustomPaint(painter: Triangle(Colors.grey.shade400)),
              ),
              const SizedBox(height: 30),
              IconButton(
                onPressed: () {
                  setState(() {
                    _visible = !_visible;
                    randomNum = Random().nextInt(10);
                  });
                },
                icon: Image.asset(
                  'assets/alarmbearno.png',
                  width: MediaQuery.of(context).size.height / 10,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        "SNS 로그인",
                        style: TextStyle(fontSize: 15),
                      ),
                      const Icon(
                        Icons.looks_one,
                        size: 40,
                      ),
                      Text(
                        "SNS 로그인",
                        style: TextStyle(fontSize: 10, color: Colors.grey[300]),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.more_horiz,
                    size: 40,
                  ),
                  Column(
                    children: [
                      Text(
                        "상대 연결",
                        style: TextStyle(fontSize: 10, color: Colors.grey[300]),
                      ),
                      const Icon(
                        Icons.looks_two_outlined,
                        size: 40,
                      ),
                      const Text(
                        "상대 연결",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.more_horiz,
                    size: 40,
                  ),
                  Column(
                    children: [
                      const Text(
                        "일어나곰",
                        style: TextStyle(fontSize: 15),
                      ),
                      const Icon(
                        Icons.looks_3_outlined,
                        size: 40,
                      ),
                      Text(
                        "일어나곰",
                        style: TextStyle(fontSize: 10, color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              // const Text(
              //   "SNS 로그인",
              //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              // ),
              Platform.isIOS
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 9),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref
                              .watch(authControllerProvider.notifier)
                              .signInWithApple(context);
                        },
                        icon: Image.asset(
                          'assets/apple.png',
                          width: 35,
                        ),
                        label: const Text(
                          'Apple로 로그인',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height / 80),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .watch(authControllerProvider.notifier)
                        .signInWithGoogle(context);
                  },
                  icon: Image.asset(
                    'assets/google.png',
                    width: 35,
                  ),
                  label: const Text(
                    'Google로 로그인',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 80),

              TextButton(
                onPressed: () {
                  // setState(() {
                  //   emailLogin = true;
                  // });
                  context.push(EmailLoginScreen.routeURL);
                },
                child: const Text(
                  '이메일로 로그인하기',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Create a custom triangle
class Triangle extends CustomPainter {
  final Color backgroundColor;
  Triangle(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;

    var path = Path();
    path.lineTo(-20, 0);
    path.lineTo(-20, 20);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
