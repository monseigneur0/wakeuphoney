import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/constants/design_constants.dart';
import 'login_screen.dart';

class LoginOnboardScreen extends StatelessWidget {
  static const routeName = "loginonboardscreen";
  static const routeURL = "/loginonboardscreen";
  const LoginOnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: AppLocalizations.of(context)!.wakeupyou,
          body: 'This is first page'
              'We are making on-boarding screens.'
              'It is very interesting!',
          image: Image.asset('assets/images/sleepingbear.jpeg'),
          decoration: getPageDecoration(AppColors.sleepingbear),
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.wakeupnotapproved,
          body: 'This is second page'
              'We are making on-boarding screens.'
              'It is very interesting!',
          image: Image.asset('assets/images/awakebear.jpeg'),
          decoration: getPageDecoration(AppColors.awakebear),
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.wakeupmenotyet,
          body: 'This is third page'
              'We are making on-boarding screens.'
              'It is very interesting!',
          image: Image.asset('assets/images/rabbitwake.jpeg'),
          decoration: getPageDecoration(AppColors.rabbitwake),
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.wakeupmenotapproved,
          body: 'This is third page'
              'We are making on-boarding screens.'
              'It is very interesting!',
          image: Image.asset('assets/images/rabbitalarm.jpeg'),
          decoration: getPageDecoration(AppColors.rabbitalarm),
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.wakeupapproved,
          body: 'This is third page'
              'We are making on-boarding screens.'
              'It is very interesting!',
          image: Image.asset('assets/images/rabbitspeak.jpeg'),
          decoration: getPageDecoration(AppColors.rabbitspeak),
        ),
      ],
      done: const Text('Done'),
      onDone: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginHome(),
          ),
        );
      },
      next: const Icon(Icons.arrow_forward_ios), // 아이콘도 지정되면 바뀌지 않으므로 const 처리
      nextStyle: const ButtonStyle(),

      // showBackButton = 뒤로가기 버튼 활성화 여부, 첫번째 페이지가 아닐 때 활성화
      showBackButton: true,
      back: const Icon(Icons.arrow_back_ios), // 아이콘도 지정되면 바뀌지 않으므로 const 처리,
      backStyle: const ButtonStyle(),
      // // showSkipButton = 스킵 버튼 활성화 여부
      // showSkipButton: true,
      // // skip = 스킵 버튼
      // skip: const Text('skip'),
      // dotsDecorator = 하단의 페이지 점들에 대한 스타일 지정
      // dotsDecorator: DotsDecorator(
      //   color: const Color.fromARGB(255, 137, 192, 139),
      //   activeColor: const Color.fromARGB(255, 0, 121, 4),
      //   size: const Size(10, 10),
      //   activeSize: const Size(15, 15),
      //   spacing: const EdgeInsets.all(10),
      //   activeShape: // shape 및 round 설정
      //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      // ),
      // curve: Curves.bounceOut, /
    );
  }

  PageDecoration getPageDecoration(Color pageColor) {
    return PageDecoration(
      titleTextStyle: const TextStyle(
        // 타이틀 텍스트 스타일
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        // 본문 텍스트 스타일
        fontSize: 18,
        color: pageColor,
      ),
      imagePadding: const EdgeInsets.only(top: 100), // 이미지 padding
      pageColor: pageColor, // 배경색상
    );
  }
}
