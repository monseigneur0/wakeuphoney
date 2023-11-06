import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wakeuphoney/core/common/loader.dart';
import 'package:wakeuphoney/core/constants/design_constants.dart';
import 'package:wakeuphoney/features/main/main_screen.dart';

//  test123@wakeupgom.com
//  tezPib-5qovxu-bydruk
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
        title: const Text("이메일로 로그인"),
      ),
      body: Column(
        children: [
          const Center(
            child: Text("이메일과 비밀번호를 입력해주세요."),
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
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
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
                                } else if (e.code == 'wrong-password') {
                                  print("비밀번호가 틀ㅣ니다.");
                                } else {
                                  print(e.code);
                                }
                              }
                            },
                            child: const Text('로그인'),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          UserCredential userCredential =
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: pwdController.text,
                          )
                                  .then((value) {
                            print(value);
                            value.user!.email == emailController.text
                                ? context.go(MainScreen.routeURL)
                                : print("이메일 이상함");
                            return value;
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print("등록되지 않은 이메일입니다.");
                          } else if (e.code == 'wrong-password') {
                            print("비밀번호가 틀ㅣ니다.");
                          } else {
                            print(e.code);
                          }
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        color: AppColors.myPink,
                        child: const Center(
                            child: Text(
                          'login',
                        )),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
