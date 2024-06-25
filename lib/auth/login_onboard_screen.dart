import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wakeuphoney/auth/login_tabscreen.dart';

import '../common/common.dart';

class LoginOnBoardScreen extends StatelessWidget {
  static const routeName = "loginonboardnewscreen";
  static const routeUrl = "/loginonboardnewscreen";
  const LoginOnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            image: Image.asset(
              'assets/images/wakeupbear/wakeupbearsleep.png',
              width: context.deviceWidth / 3 * 2,
            ),
            title: 'wakeUpYourSleepingFriend'.tr(),
            body: 'friendHearTheAlarm'.tr(),
            decoration: getPageDecoration(context),
          ),
          PageViewModel(
            image: Image.asset(
              'assets/images/wakeupbear/wakeupbearbefore.png',
              width: context.deviceWidth / 3 * 2,
            ),
            title: 'surprised'.tr(),
            body: 'sendAMessage'.tr(),
            decoration: getPageDecoration(context),
          ),
          PageViewModel(
            image: Image.asset(
              'assets/images/wakeupbear/wakeupbearready.png',
              width: context.deviceWidth / 3 * 2,
            ),
            title: 'preparingWakeThemUp'.tr(),
            body: 'linkWithCode'.tr(),
            decoration: getPageDecoration(context),
          ),
          // PageViewModel(
          //   image: Image.asset('assets/images/aiphotos/rabbitalarm.png'),
          //   title: '상대를 깨울 수 있어요!',
          //   body: '버튼 하나로 알람 보내기',
          //   decoration: getPageDecoration(context),
          // ),
        ],
        done: Text('signIn'.tr()),
        onDone: () {
          context.go(LoginNewScreen.routeUrl);
        },
        next: const Icon(Icons.arrow_forward_ios), // 아이콘도 지정되면 바뀌지 않으므로 const 처리
        nextStyle: const ButtonStyle(),

        showSkipButton: true,
        skip: Text('Skip'.tr()),
        onSkip: () {
          // 로그인 페이지로 이동
          context.go(LoginNewScreen.routeUrl);
        },

        // showBackButton = 뒤로가기 버튼 활성화 여부, 첫번째 페이지가 아닐 때 활성화
        showBackButton: false,
        back: const Icon(Icons.arrow_back_ios),
        backStyle: const ButtonStyle(),
      ),
    );
  }

  PageDecoration getPageDecoration(BuildContext context) {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        // 타이틀 텍스트 스타일
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.primary600,
      ),
      bodyTextStyle: TextStyle(
        // 본문 텍스트 스타일
        fontSize: 18,
        color: AppColors.point800,
      ),
      imagePadding: EdgeInsets.only(top: 100), // 이미지 padding
      pageColor: Colors.white, // 배경색상
    );
  }
}
