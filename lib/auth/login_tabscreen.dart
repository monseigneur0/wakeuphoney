import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/util/app_keyboard_util.dart';
import 'package:wakeuphoney/common/widget/w_text_field_with_delete.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/common/widget/w_text_form_field.dart';
import 'package:wakeuphoney/tabs/main_tabscreen.dart';
import 'package:wakeuphoney/auth/user_widget.dart';

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

  Logger logger = Logger();

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
              Container(height: context.deviceHeight / 5),
              Image.asset('assets/images/wakeupbear/wakeupbear.png', width: context.deviceWidth / 3),
              height20,
              Row(
                children: [
                  Expanded(
                    child: TextFieldWithDelete(
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      deleteRightPadding: 5,
                      texthint: 'email'.tr(),
                      onEditingComplete: () {
                        //logger.d(controller.text);
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
                    child: TextFormFieldWithDelete(
                      obscureText: true,
                      focusNode: FocusNode(),
                      textInputAction: TextInputAction.done,
                      controller: pwdController,
                      deleteRightPadding: 5,
                      texthint: 'password'.tr(),
                      onEditingComplete: () async {
                        //logger.d(controller.text);
                        await loginProcess(context);
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
                      child: !_isLoading
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                // Login button pressed

                                await loginProcess(context);
                              },
                              child: 'signIn'.tr().text.color(Colors.white).medium.make(),
                            ).pOnly(top: 5)
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                //로그인 버튼 눌렀을때 처리
                              },
                              child: const Loader(),
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
                          context.showSnackbar('readySignUp'.tr());
                        },
                        child: 'goToSignUp'.tr().text.size(10).color(context.appColors.lessImportant).make()),
                  ),
                ],
              ),
              if (kDebugMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 30,
                      child: TextButton(
                          onPressed: () {
                            // context.showToast(msg: '회원가입 준비 중입니다.');
                            // showToast('회원가입 준비 중입니다.');
                            ref.read(loginControllerProvider.notifier).signInWithManager(context);
                            context.go('/alarm');
                          },
                          child: '관리자계정'.tr().text.size(10).color(context.appColors.lessImportant).make()),
                    ),
                  ],
                ),

              if (kDebugMode) const UserLoggedInWidget(),

              height20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(height: 1, color: context.appColors.middleImportant)),
                  width10,
                  'loginWithSNSAccount'.tr().text.color(context.appColors.justImportant).make(),
                  width10,
                  Expanded(child: Container(height: 1, color: context.appColors.middleImportant)),
                ],
              ),
              height20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SnsLogin(
                      image: 'assets/images/login/apple-128.png',
                      backgroundColor: Colors.black,
                      company: 'Apple',
                      onTap: () {
                        ref.watch(loginControllerProvider.notifier).signInWithApple(context);
                      }),
                  width20,
                  SnsLogin(
                      image: 'assets/images/login/google.png',
                      backgroundColor: Colors.white,
                      company: 'Google',
                      onTap: () {
                        ref.watch(loginControllerProvider.notifier).signInWithGoogle(context);
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
              //           child: '이전 디자인'.tr().text.make()),
              //       ElevatedButton(
              //           onPressed: () {
              //             Nav.push(const MatchTabScreen());
              //           },
              //           child: '이전 디자인'.tr().text.make()),
              //     ],
              //   ),
            ],
          ).pSymmetric(h: 20),
        ),
      ),
    );
  }

  Future<void> loginProcess(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    // Attempt login using the provided login controller
    final userCredential =
        await ref.watch(loginControllerProvider.notifier).signInWithEmailAndPassword(context, emailController.text, pwdController.text);

    setState(() {
      _isLoading = false;
    });
    if (userCredential != null) {
      if (context.mounted) {
        context.go(MainTabsScreen.routeUrl);
      }
    }
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
