import 'package:flutter/material.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/common/common.dart';

class EmptyAlarm extends StatelessWidget {
  const EmptyAlarm({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteBackground,
        border: Border.all(color: AppColors.point700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Tap(
        onTap: () {
          if (user.couples!.isEmpty) {
            context.go('/main/match');
          } else {
            context.go('/main/wake');
            context.showSnackbar('go to wake friend up'.tr());
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/wakeupbear/wakeupbearsleep.png",
              width: Constants.emptyPagePngWidth,
            ),
            height20,
            user.couples != null
                ? user.couples!.isEmpty
                    ? 'connet to friend'.tr().text.size(18).medium.make()
                    : "Your friend hasn't woken you up yet".tr().text.size(18).medium.make()
                : 'loginFailTryAgain'.tr().text.color(Colors.red).size(18).medium.make(),
            height40,
          ],
        ),
      ),
    );
  }
}
