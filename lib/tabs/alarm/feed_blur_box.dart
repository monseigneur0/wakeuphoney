import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';
import 'package:wakeuphoney/tabs/wake/wake_tabscreen.dart';

class FeedBlurBox extends StatelessWidget {
  final UserModel user;
  final WakeModel wake;
  const FeedBlurBox(
    this.user,
    this.wake, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: () {
        showToast('The alarm will ring and you can check it.'.tr());
      },
      child: Container(
        // height: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.whiteBackground,
          border: Border.all(color: AppColors.point700),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            NameBar(user),
            TimeBar(wake),
            height10,
            TextMessageBlurBox(wake.message),
            height10,
            ImageBlurBox(wake.messagePhoto),
          ],
        ),
      ),
    );
  }
}
