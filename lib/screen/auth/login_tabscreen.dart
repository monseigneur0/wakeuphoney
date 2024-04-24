import 'package:flutter/material.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/w_text_field_with_delete.dart';
import 'package:wakeuphoney/features/oldmain/main_screen.dart';
import 'package:wakeuphoney/screen/main/tabs/match/match_tabscreen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'logintabs';
  static const routeUrl = '/logintabs';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          height40,
          Image.asset(
            'assets/images/alarmbearno.png',
            width: context.deviceWidth / 3,
          ),
          height40,
          Row(
            children: [
              Expanded(
                child: TextFieldWithDelete(
                  textInputAction: TextInputAction.search,
                  controller: emailController,
                  texthint: "이메일",
                  onEditingComplete: () {
                    //print(controller.text);
                    //검색 버튼 눌렀을때 처리 //search
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
                  textInputAction: TextInputAction.search,
                  controller: passController,
                  texthint: "비밀번호",
                  onEditingComplete: () {
                    //print(controller.text);
                    //검색 버튼 눌렀을때 처리 //search
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
                    onPressed: () {
                      //로그인 버튼 눌렀을때 처리
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
              TextButton(
                  onPressed: () {
                    // context.showToast(msg: '회원가입 준비 중입니다.');
                    showToast('회원가입 준비 중입니다.');
                    context.showSnackbar('회원가입 준비 중입니다.');
                  },
                  child: '회원가입하러가기'.text.color(context.appColors.lessImportant).make()),
            ],
          ),
          height30,
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
              ClipRRect(
                  borderRadius: BorderRadius.circular(Constants.snsLogin / 2),
                  child: Container(
                      color: Colors.black,
                      width: Constants.snsLogin,
                      child: Image.asset('assets/images/apple-128.png', scale: 4))),
              width20,
              ClipRRect(
                  borderRadius: BorderRadius.circular(Constants.snsLogin / 2),
                  child: Container(
                      width: Constants.snsLogin,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(Constants.snsLogin / 2)),
                        border: Border.all(color: context.appColors.lessImportant),
                      ),
                      child: Image.asset('assets/images/google.png', scale: 4))),
            ],
          ),
          height40,
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Nav.push(const MainScreen());
                  },
                  child: '이전 디자인'.text.make()),
              ElevatedButton(
                  onPressed: () {
                    Nav.push(const MatchTabScreen());
                  },
                  child: '이전 디자인'.text.make()),
            ],
          ),
        ],
      ).pSymmetric(h: 20),
    );
  }
}
