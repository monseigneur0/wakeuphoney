import 'package:flutter/material.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/util/app_keyboard_util.dart';

class MatchTabScreen extends StatefulWidget {
  const MatchTabScreen({super.key});

  @override
  State<MatchTabScreen> createState() => _MatchTabScreenState();
}

class _MatchTabScreenState extends State<MatchTabScreen> {
  @override
  Widget build(BuildContext context) {
    final inviteCodeController = TextEditingController();
    final time = DateTime.now();
    return Scaffold(
      body: Tap(
        onTap: () => AppKeyboardUtil.hide(context),
        child: Column(
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
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary600,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SelectableText(
                        '123456',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ).pSymmetric(h: 10, v: 10),
                    ],
                  ),
                ),
                height20,
                '상대방 초대코드'.text.fontWeight(FontWeight.w600).make(),
                height5,
                // TextFieldWithDelete(
                //   controller: inviteCodeController,
                //   focusNode: FocusNode(),
                //   textInputAction: TextInputAction.done,
                //   deleteRightPadding: 5,
                //   texthint: "초대코드를 입력해주세요",
                //   onEditingComplete: () async {},
                // ),
                height10,
                TextFormField(
                  controller: inviteCodeController,
                  focusNode: FocusNode(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: '초대코드를 입력해주세요',
                    hintStyle: const TextStyle(
                      color: AppColors.middleGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.middleGrey,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.primary600,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmptyOrNull) {
                      return '초대코드를 입력해주세요';
                    } else if (value!.length > 5) {
                      //stream 생성
                      return '초대코드를 다시 확인해주세요';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
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
                            showToast('연결하기');
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
      ),
    );
  }
}
