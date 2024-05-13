import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/features/oldauth/user_model.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_model.dart';

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
        DateFormat('a hh:mm').format(wake.wakeTime).toString().text.bold.color(AppColors.primary700).make(),
        Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
        '이때 깨워줄게요!'.text.bold.make(),
        height10,
      ],
    );
  }
}
