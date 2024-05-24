import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/tabs/match/match_tab_controller.dart';

class MyProfileTabScreen extends ConsumerWidget {
  static const routeName = 'myprofiletabs';
  static const routeUrl = '/myprofiletabs';
  const MyProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _profileImage(user!),
            height10,
            user.displayName.text.lg.medium.make(),
            height30,
            infobox(user, ref),
            height20,
            // disconnectButton(ref),
            height40,
            height40,
            height40,
          ],
        ).pSymmetric(v: 10, h: 20),
      ),
    );
  }
}

Widget _profileImage(UserModel user, {String? herotag}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: Hero(
      tag: herotag ?? user.uid,
      child: CachedNetworkImage(
        imageUrl: user.photoURL,
        width: 100,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    ),
  );
}

Widget infobox(UserModel friend, WidgetRef ref) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: Tap(
            onTap: () {
              // ref.read(loginControllerProvider.notifier).updateBirthDate();
            },
            child: Column(
              children: [
                '생일'.text.lg.medium.color(AppColors.primary600).make(),
                DateFormat.yMMMMd().format(friend.birthDate).toString().text.lg.make(),
                //make it to update birthdate
              ],
            ),
          ),
        ),
        // const Divider(height: 1, color: AppColors.grey200),
        Container(width: 1, height: 50, color: AppColors.grey300),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              '성별'.text.lg.medium.color(AppColors.primary600).make(),
              (friend.gender == 'female') ? '여성'.text.lg.make() : '남성'.text.lg.make(),
            ],
          ),
        ),
      ],
    ).pSymmetric(v: 10, h: 20),
  );
}

Widget disconnectButton(WidgetRef ref) {
  return MainButton(
    '친구 끊기',
    onPressed: () {
      ref.read(matchTabControllerProvider.notifier).breakUp();
    },
  );
}
