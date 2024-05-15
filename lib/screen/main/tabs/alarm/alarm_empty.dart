import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/screen/auth/user_model.dart';

class EmptyAlarm extends StatelessWidget {
  const EmptyAlarm({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: () {
        if (user.couples!.isEmpty) {
          context.go('/main/match');
        } else {
          context.go('/main/wake');
          context.showSnackbar('깨우러 가기');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/aiphotos/awakebear.png",
            width: Constants.emptyPagePngWidth,
          ),
          height20,
          user.couples != null
              ? user.couples!.isEmpty
                  ? '상대와 연결해주세요'.text.size(18).bold.make()
                  : '상대가 아직 깨워주지 않았어요!'.text.size(18).bold.make()
              : '로그인 실패했습니다. 다시 시도해주세요.'.text.color(Colors.red).size(18).bold.make(),
          height40,
        ],
      ),
    );
  }
}
