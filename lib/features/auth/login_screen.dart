import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/auth/auth_controller.dart';

import 'package:wakeuphoney/common/common.dart';
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
      'hello'.tr(),
      'goodmorning'.tr(),
      'honeywakeup'.tr(),
      'writealetter'.tr(),
      'sendaphoto'.tr(),
      'checktheletter'.tr(),
      'watchthephoto'.tr(),
      'replyletter'.tr(),
      'canyoureply'.tr(),
      'writemorning'.tr(),
      'howareyou'.tr(),
      'imissyou'.tr(),
    ];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        // appBar: AppBar(
        //   // actions: [
        //   //   IconButton(
        //   //       onPressed: () {
        //   //         ref.watch(authRepositoryProvider).isLoggedIn
        //   //             ? context.pushNamed(PracticeHome.routeName)
        //   //             : context.pushNamed(LoginHome.routeName);
        //   //       },
        //   //       icon: const Icon(
        //   //         Icons.connecting_airports_outlined,
        //   //         color: AppColors.myPink,
        //   //       ))
        //   // ],
        //   backgroundColor: AppColors.myAppBarBackgroundPink,
        //   title: Text(
        //     'wakeupgom'.tr(),
        //   ),
        // ),
        body: SafeArea(
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
                            style: const TextStyle(color: Colors.black, fontSize: 15),
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
              SizedBox(
                height: height / 30,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _visible = !_visible;
                    randomNum = Random().nextInt(10);
                  });
                },
                icon: Image.asset(
                  'assets/alarmbearno.png',
                  width: height / 10,
                ),
              ),
              SizedBox(height: height / 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'snslogin'.tr(),
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Icon(
                        Icons.looks_one,
                        size: 40,
                      ),
                      Text(
                        'snslogin'.tr(),
                        style: TextStyle(fontSize: 10, color: Colors.grey[200]),
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
                        'matchprocess'.tr(),
                        style: TextStyle(fontSize: 10, color: Colors.grey[200]),
                      ),
                      const Icon(
                        Icons.looks_two_outlined,
                        size: 40,
                      ),
                      Text(
                        'matchprocess'.tr(),
                        style: const TextStyle(fontSize: 15),
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
                        'wakeupgom'.tr(),
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Icon(
                        Icons.looks_3_outlined,
                        size: 40,
                      ),
                      Text(
                        'wakeupgom'.tr(),
                        style: TextStyle(fontSize: 10, color: Colors.grey[200]),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height / 40),
              // const Text(
              //   "SNS 로그인",
              //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              // ),
              Platform.isIOS
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.watch(authControllerProvider.notifier).signInWithApple(context);
                        },
                        icon: Image.asset(
                          'assets/apple.png',
                          width: 35,
                        ),
                        label: Text(
                          'applelogin'.tr(),
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: height / 80),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.watch(authControllerProvider.notifier).signInWithGoogle(context);
                  },
                  icon: Image.asset(
                    'assets/google.png',
                    width: 35,
                  ),
                  label: Text(
                    'googlelogin'.tr(),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height / 80),

              TextButton(
                onPressed: () {
                  // setState(() {
                  //   emailLogin = true;
                  // });
                  context.push(EmailLoginScreen.routeURL);
                },
                child: Text(
                  'emaillogin'.tr(),
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
