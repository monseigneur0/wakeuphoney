import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wakeuphoney/common/loader.dart';
import 'package:wakeuphoney/common/constants/app_colors.dart';
import 'package:wakeuphoney/features/main/main_screen.dart';

import '../../core/utils.dart';

//  test123@wakeupgom.com
//  tezPib-5qovxu-bydruk
// takho@wakeup.com
// !
class EmailLoginScreen extends StatefulWidget {
  static String routeName = "emaillogin";
  static String routeURL = "/emaillogin";
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.myAppBarBackgroundPink,
        title: const Text(
          "이메일로 로그인",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Center(
            child: Text(
              "이메일과 비밀번호를 입력해주세요.",
            ),
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelText: '이메일',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "이메일 주소를 입력하세요.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: pwdController,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelText: '비밀번호',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "이메일 주소를 입력하세요.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _isLoading
                        ? const Loader()
                        : ElevatedButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                UserCredential userCredential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: pwdController.text,
                                )
                                    .then((value) {
                                  print(value);
                                  value.user!.email == emailController.text
                                      ? context.go(MainScreen.routeURL)
                                      : print("이메일 이상함");
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return value;
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  print("등록되지 않은 이메일입니다.");
                                  if (context.mounted) {
                                    showToast("등록되지 않은 이메일입니다.");
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else if (e.code == 'wrong-password') {
                                  print("비밀번호가 틀ㅣ니다.");

                                  if (context.mounted) {
                                    showToast("비밀번호가 틀립니다.");
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else {
                                  print(e.code);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.myPink)),
                            child: const Text(
                              '로그인',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
