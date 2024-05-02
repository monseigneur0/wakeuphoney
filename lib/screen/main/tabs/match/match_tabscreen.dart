import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/util/app_keyboard_util.dart';
import 'package:wakeuphoney/screen/auth/login_controller.dart';
import 'package:wakeuphoney/screen/main/tabs/match/match_tab_controller.dart';

import 'package:wakeuphoney/screen/main/tabs/match/user_widget.dart';

//  test123@wakeupgom.com
//  tezPib-5qovxu-bydruk
// when no couple.

class MatchTabScreen extends ConsumerStatefulWidget {
  static const routeName = 'matchtabs';
  static const routeUrl = '/matchtabs';
  const MatchTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MatchTabScreenState();
}

class _MatchTabScreenState extends ConsumerState<MatchTabScreen> {
  @override
  Widget build(BuildContext context) {
    final inviteCodeController = TextEditingController();
    final time = DateTime.now();

    final matchNumber = ref.watch(matchNumberProvider);

    /// match model 로딩하고 생성해서 보여주기.
    /// match model을 가져오고
    /// uid 는 stateprovider로 관리
    /// user model에서 couple이 없으면 match
    ///
    return Scaffold(
      body: Tap(
        onTap: () => AppKeyboardUtil.hide(context),
        child: SingleChildScrollView(
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
                  if (kDebugMode)
                    Column(
                      children: [
                        const UserLoggedInWidget(),
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
                                    showToast('홈가기');
                                    context.go('/main/home');
                                  },
                                  child: '홈가기'.text.color(Colors.white).bold.size(16).make(),
                                ).pOnly(top: 5),
                              ),
                            ),
                          ],
                        ),
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
                                    showToast('wake홈가기');
                                    context.go('/main/wake');
                                  },
                                  child: 'wake홈가기'.text.color(Colors.white).bold.size(16).make(),
                                ).pOnly(top: 5),
                              ),
                            ),
                          ],
                        ),
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
                                    showToast('홈가기');
                                    context.go('/main/feed');
                                  },
                                  child: 'feed가기'.text.color(Colors.white).bold.size(16).make(),
                                ).pOnly(top: 5),
                              ),
                            ),
                          ],
                        ),
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
                                    showToast('홈가기');
                                    context.go('/main/feed');
                                  },
                                  child: 'feed가기'.text.color(Colors.white).bold.size(16).make(),
                                ).pOnly(top: 5),
                              ),
                            ),
                          ],
                        ),
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
                                    showToast('홈가기');
                                    context.go('/main/feed');
                                  },
                                  child: 'feed가기'.text.color(Colors.white).bold.size(16).make(),
                                ).pOnly(top: 5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ).pSymmetric(h: 20),
        ),
      ),
    );
  }
}
