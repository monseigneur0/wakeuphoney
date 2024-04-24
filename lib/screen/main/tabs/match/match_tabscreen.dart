import 'package:flutter/material.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/w_text_field_with_delete.dart';

class MatchTabScreen extends StatelessWidget {
  const MatchTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inviteCodeMeController = TextEditingController();
    final inviteCodeController = TextEditingController();
    final time = DateTime.now();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/login/cloud.png'),
          Image.asset('assets/images/login/linkcouple.png'),
          '서로의 초대코드를 입력하면 \n연결돼요!'.text.color(AppColors.primary600).size(20).bold.align(TextAlign.center).make(),
          height30,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '내 초대코드${time.toString()}'.text.fontWeight(FontWeight.w600).make(),
              height5,
              TextFieldWithDelete(controller: inviteCodeController),
              height20,
              '내 초대코드${time.toString()}'.text.fontWeight(FontWeight.w600).make(),
              height5,
              TextFieldWithDelete(controller: inviteCodeController),
              height20,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
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
                        child: '연결하기'.text.color(Colors.white).bold.size(16).make(),
                      ).pOnly(top: 5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ).pSymmetric(h: 20),
    );
  }
}
