import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/util/app_keyboard_util.dart';
import 'package:wakeuphoney/common/widget/w_text_field_with_delete.dart';
import 'package:wakeuphoney/features/oldauth/auth_controller.dart';
import 'package:wakeuphoney/screen/main/main_tabscreen.dart';

//  test123@wakeupgom.com
//  tezPib-5qovxu-bydruk
// takho@wakeup.com
// !
class LoginNewScreen extends ConsumerStatefulWidget {
  static const routeName = 'logintabs';
  static const routeUrl = '/logintabs';
  const LoginNewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginNewScreenState();
}

class _LoginNewScreenState extends ConsumerState<LoginNewScreen> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Tap(
        onTap: () {
          AppKeyboardUtil.hide(context);
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(height: context.deviceHeight / 6),
              Image.asset('assets/images/alarmbearno.png', width: context.deviceWidth / 3),
              height20,
              Row(
                children: [
                  Expanded(
                    child: TextFieldWithDelete(
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      deleteRightPadding: 5,
                      texthint: "이메일",
                      onEditingComplete: () {
                        //print(controller.text);
                        //검색 버튼 눌렀을때 처리 //search
                        FocusScope.of(context).nextFocus();
                      },
                    ).pOnly(top: 5),
                  ),
                ],
              ),
              height15,
              Row(
                children: [
                  Expanded(
                    child: TextFieldWithDelete(
                      focusNode: FocusNode(),
                      textInputAction: TextInputAction.done,
                      controller: pwdController,
                      deleteRightPadding: 5,
                      texthint: "비밀번호",
                      onEditingComplete: () async {
                        //print(controller.text);
                        //검색 버튼 눌렀을때 처리 //search

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
                                ? Nav.clearAllAndPush(const MainTabsScreen())
                                : print("이메일 이상함");
                            setState(() {
                              _isLoading = false;
                            });
                            if (context.mounted) {
                              Nav.clearAllAndPush(const MainTabsScreen());
                            }

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
                    ).pOnly(top: 5),
                  ),
                ],
              ),
              height20,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          //로그인 버튼 눌렀을때 처리

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
                              // value.user!.email == emailController.text
                              //     ? Nav.clearAllAndPush(const MainTabsScreen())
                              //     : print("이메일 이상함");
                              Nav.push(const MainTabsScreen());

                              setState(() {
                                _isLoading = false;
                              });
                              if (context.mounted) {
                                Nav.push(const MainTabsScreen());
                              }
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
                        child: '로그인'.text.color(Colors.white).bold.make(),
                      ).pOnly(top: 5),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                    child: TextButton(
                        onPressed: () {
                          // context.showToast(msg: '회원가입 준비 중입니다.');
                          // showToast('회원가입 준비 중입니다.');
                          context.showSnackbar('회원가입 준비 중입니다. \nSNS로그인을 이용해주세요.');
                        },
                        child: '회원가입하러가기'.text.size(10).color(context.appColors.lessImportant).make()),
                  ),
                ],
              ),
              height20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(height: 1, color: context.appColors.middleImportant)),
                  width10,
                  'SNS 계정으로 로그인'.text.color(context.appColors.justImportant).make(),
                  width10,
                  Expanded(child: Container(height: 1, color: context.appColors.middleImportant)),
                ],
              ),
              height20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SnsLogin(
                      image: 'assets/images/apple-128.png',
                      backgroundColor: Colors.black,
                      company: '애플',
                      onTap: () {
                        ref.watch(authControllerProvider.notifier).signInWithApple(context);
                      }),
                  width20,
                  SnsLogin(
                      image: 'assets/images/google.png',
                      backgroundColor: Colors.white,
                      company: '구글',
                      onTap: () {
                        ref.watch(authControllerProvider.notifier).signInWithGoogle(context);
                      }),
                ],
              ),
              height40,
              // if (kDebugMode)
              //   Row(
              //     children: [
              //       ElevatedButton(
              //           onPressed: () {
              //             Nav.push(const MainScreen());
              //           },
              //           child: '이전 디자인'.text.make()),
              //       ElevatedButton(
              //           onPressed: () {
              //             Nav.push(const MatchTabScreen());
              //           },
              //           child: '이전 디자인'.text.make()),
              //     ],
              //   ),
            ],
          ).pSymmetric(h: 20),
        ),
      ),
    );
  }
}

class SnsLogin extends StatelessWidget {
  final String image;
  final Color backgroundColor;
  final String company;
  final VoidCallback onTap;
  const SnsLogin({
    required this.image,
    required this.backgroundColor,
    required this.company,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Constants.snsLogin / 2),
        child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(Constants.snsLogin / 2)),
              border: Border.all(color: context.appColors.middleImportant),
            ),
            width: Constants.snsLogin,
            child: Image.asset(image, scale: 4)),
      ),
    );
  }
}
