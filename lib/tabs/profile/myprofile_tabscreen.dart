import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/firebase_providers.dart';
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
        title: const Text('내 프로필'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            height40,
            height40,
            _profileImage(user!),
            height10,
            user.displayName.text.lg.medium.make(),
            height30,
            infobox(user, ref, context),
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

Widget infobox(UserModel friend, WidgetRef ref, BuildContext context) {
  return Column(
    children: [
      Container(
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
              child: GestureDetector(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((value) {
                    if (value != null) {
                      ref.read(loginControllerProvider.notifier).updateBirthday(value);
                      // analytics.logSelectContent(
                      //     contentType: 'birthday', itemId: 'editbirthday');
                    }
                  });
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
              child: Tap(
                onTap: () {
                  showModalBottomSheet(
                      constraints: const BoxConstraints(maxHeight: 200),
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 10,
                              width: MediaQuery.of(context).size.width,
                            ),
                            GestureDetector(
                              onTap: () {
                                final analytics = ref.read(analyticsProvider);
                                Navigator.pop(context);
                                ref.read(loginControllerProvider.notifier).updateGender(1);
                                analytics.logSelectContent(contentType: "gender", itemId: "editgender");
                              },
                              child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width - 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))]),
                                      child: Center(child: Text('male'.tr(), style: const TextStyle(fontSize: 24))))
                                  .pSymmetric(v: 10),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                ref.read(loginControllerProvider.notifier).updateGender(2);
                              },
                              child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width - 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))]),
                                      child: Center(child: Text('female'.tr(), style: const TextStyle(fontSize: 24))).p(5))
                                  .pSymmetric(v: 10),
                            ),
                          ],
                        );
                      });
                },
                child: Column(
                  children: [
                    '성별'.text.lg.medium.color(AppColors.primary600).make(),
                    (friend.gender == 'female') ? '여성'.text.lg.make() : '남성'.text.lg.make(),
                  ],
                ),
              ),
            ),
          ],
        ).pSymmetric(v: 10, h: 20),
      ),
    ],
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
