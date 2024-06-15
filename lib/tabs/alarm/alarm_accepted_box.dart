import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';

class AcceptedBox extends ConsumerWidget {
  final UserModel user;
  final WakeModel wake;
  const AcceptedBox(
    this.user,
    this.wake, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DateFormat('a hh:mm').format(wake.wakeTime).toString().text.medium.color(AppColors.primary700).make(),
        Image.asset('assets/images/wakeupbear/wakeupbearsleep.png', width: Constants.cardPngWidth),
        'I will wake you up at'.tr().text.medium.make(),
        height10,
      ],
    );
  }
}