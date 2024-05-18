import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/constants/app_colors.dart';
import 'package:wakeuphoney/common/widget/w_height_and_width.dart';
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
    return Container(
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
    );
  }
}
