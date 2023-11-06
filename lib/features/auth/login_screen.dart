import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/auth/auth_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakeuphoney/features/auth/login_email_screen.dart';
import 'package:wakeuphoney/features/main/main_screen.dart';

import '../../core/utils.dart';

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
  bool emailLogin = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
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
          //         color: Color(0xFFD72499),
          //       ))
          // ],
          backgroundColor: Colors.grey[900],
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
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            messageList[randomNum],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
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
                child: CustomPaint(painter: Triangle(Colors.grey.shade800)),
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
                ),
                iconSize: 130,
              ),
              const SizedBox(height: 30),
              const Text(
                "SNS 로그인",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
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
              const SizedBox(
                height: 10,
              ),
              !emailLogin
                  ? TextButton(
                      onPressed: () {
                        // setState(() {
                        //   emailLogin = true;
                        // });
                        context.push(EmailLoginScreen.routeName);
                      },
                      child: const Text(
                        '이메일로 로그인하기',
                        style: TextStyle(color: Colors.white),
                      ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 185,
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "이메일"),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "이메일 주소를 입력하세요";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: pwdController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "비밀번호"),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "비밀번호를 입력하세요";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          try {
                                            UserCredential userCredential =
                                                await FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                                        email: emailController
                                                            .text,
                                                        password: pwdController
                                                            .text) //아이디와 비밀번호로 로그인 시도
                                                    .then((value) {
                                              print(value);
                                              value.user!.email ==
                                                      emailController
                                                          .text //이메일 인증 여부
                                                  ? context
                                                      .go(MainScreen.routeURL)
                                                  : print("이메일 확ㅣ 불");
                                              // showSnackBar(
                                              //     context, "이메일 확인 불가");tezPib-5qovxu-bydruk

                                              return value;
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            //로그인 예외처리
                                            if (e.code == 'user-not-found') {
                                              print('등록되지 않은 이메일입니다');
                                            } else if (e.code ==
                                                'wrong-password') {
                                              print('비밀번호가 틀렸습니다');
                                            } else {
                                              print(e.code);
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 50,
                                          color: Colors.black,
                                          child: const Center(
                                            child: Text(
                                              '로그인',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  ],
                                )),
                          ),
                        ),
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
