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
            title: '자고 있는 친구를 깨워봐요',
            body: '친구가 알람 소리를 듣고 일어날 수 있을까요?',
            decoration: getPageDecoration(context),
          ),
          PageViewModel(
            image: Image.asset(
              'assets/images/wakeupbear/wakeupbearbefore.png',
              width: context.deviceWidth / 3 * 2,
            ),
            title: '깜짝 놀랄 수도 있어요',
            body: '사진, 텍스트 메세지, \n음성 메세지로 하고 싶은 말을 전해보세요',
            decoration: getPageDecoration(context),
          ),
          PageViewModel(
            image: Image.asset(
              'assets/images/wakeupbear/wakeupbearready.png',
              width: context.deviceWidth / 3 * 2,
            ),
            title: '깨울 준비를 해 볼까요?',
            body: '초대코드를 통해 친구와 연결해봐요',
            decoration: getPageDecoration(context),
          ),
          // PageViewModel(
          //   image: Image.asset('assets/images/aiphotos/rabbitalarm.png'),
          //   title: '상대를 깨울 수 있어요!',
          //   body: '버튼 하나로 알람 보내기',
          //   decoration: getPageDecoration(context),
          // ),
        ],
        done: const Text('Done'),
        onDone: () {
          context.go(LoginNewScreen.routeUrl);
        },
        next: const Icon(Icons.arrow_forward_ios), // 아이콘도 지정되면 바뀌지 않으므로 const 처리
        nextStyle: const ButtonStyle(),

        showSkipButton: true,
        skip: const Text('skip'),
        onSkip: () {
          // 로그인 페이지로 이동
          context.go(LoginNewScreen.routeUrl);
        },

        // showBackButton = 뒤로가기 버튼 활성화 여부, 첫번째 페이지가 아닐 때 활성화
        showBackButton: false,
        back: const Icon(Icons.arrow_back_ios), // 아이콘도 지정되면 바뀌지 않으므로 const 처리,
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
