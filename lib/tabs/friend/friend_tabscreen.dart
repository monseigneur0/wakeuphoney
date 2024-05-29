import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/image/image_full_screen.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/common/widget/w_main_button_disabled.dart';
import 'package:wakeuphoney/tabs/match/match_tab_controller.dart';

class FriendTabScreen extends ConsumerWidget {
  const FriendTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userModelProvider);
    final friend = ref.watch(friendUserModelProvider);
    final now = DateTime.now();
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('친구'),
      // ),
      body: Stack(
        children: [
          Center(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: SizedBox(
                height: 700,
                width: 800,
                child: Image.asset(
                  'assets/images/wakeupbear/wakeupbear_friend_back2.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tap(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageFullScreen(
                              imageURL: user.photoURL,
                              herotag: 'profileImage',
                            ),
                          ));
                    },
                    child: Column(
                      children: [
                        profileImage(user!),
                        user.displayName.text.lg.medium.make(),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      profileImage(friend!),
                      friend.displayName.text.lg.medium.make(),
                    ],
                  ),
                ],
              ).pSymmetric(v: 10, h: 10),
              height10,
              // user.displayName.text.lg.medium.make(),
              height30,
              'has been'.tr().text.xl2.medium.make(),
              // infobox(user),
              height20,

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: AppColors.primary600),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        '${DateTime(now.year, now.month, now.day + 1).difference(user.matchedDateTime!).inDays + 1}'
                            .text
                            .xl4
                            .bold
                            .color(AppColors.primary600)
                            .make(),
                  ),
                  width5,
                  'days'.tr().text.xl2.medium.make(),
                ],
              ),
              height10,
              // friend.displayName.text.lg.medium.make(),
              height30,
              // infobox(friend),
              height20,
              // disconnectButton(ref),
              height40,
              height40,
            ],
          ).pSymmetric(v: 10, h: 20),
        ],
      ),
    );
  }
}

Widget profileImage(UserModel friend, {String? herotag}) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Image.asset('assets/images/wakeupbear/wakeupbearprofile.png', width: 115),
      ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Hero(
          tag: herotag ?? friend.uid,
          child: CachedNetworkImage(
            imageUrl: friend.photoURL,
            width: 100,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    ],
  );
}

Widget infobox(UserModel friend) {
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
          child: Column(
            children: [
              'Birthaday'.text.lg.medium.color(AppColors.primary600).make(),
              DateFormat.yMMMMd()
                  .format(friend.birthDate)
                  .toString()
                  .text
                  .lg
                  .make(),
            ],
          ),
        ),
        // const Divider(height: 1, color: AppColors.grey200),
        Container(width: 1, height: 50, color: AppColors.grey300),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              'Gender'.tr().text.lg.medium.color(AppColors.primary600).make(),
              (friend.gender == 'female')
                  ? 'Female'.tr().text.lg.make()
                  : 'Male'.tr().text.lg.make(),
            ],
          ),
        ),
      ],
    ).pSymmetric(v: 10, h: 20),
  );
}

Widget disconnectButton(WidgetRef ref) {
  return MainButtonDisabled(
    'disconnect friend'.tr(),
    onPressed: () {
      ref.read(matchTabControllerProvider.notifier).breakUp();
    },
  );
}
