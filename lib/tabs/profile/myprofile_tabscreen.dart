import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/firebase_providers.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/common/widget/w_text_form_field.dart';
import 'package:wakeuphoney/tabs/match/match_tab_controller.dart';

class MyProfileTabScreen extends ConsumerWidget {
  static const routeName = 'myprofiletabs';
  static const routeUrl = '/myprofiletabs';
  const MyProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userModelProvider);
    final userStream = ref.watch(getUserStreamProvider);

    final textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('myProfile'.tr()),
      ),
      body: SingleChildScrollView(
        child: userStream.when(
          data: (user) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                height40,
                height40,
                _profileImage(user),
                height10,
                user.displayName.text.lg.medium.make(),
                _nameBox(user, ref, context, textEditingController),
                height30,
                infobox(user, ref, context),
                height20,
                // disconnectButton(ref),
                height40,
                height40,
                height40,
              ],
            ).pSymmetric(v: 10, h: 20);
          },
          error: (error, stackTrace) => StreamError(error, stackTrace),

          //나중에 글로벌 에러 핸들링으로 변경
          loading: () => const CircularProgressIndicator(), // Define the 'loading' variable
          // 나ㅇ에 글로벌 로딩 페이지으로 변경
        ),
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

Widget _nameBox(UserModel user, WidgetRef ref, BuildContext context, TextEditingController textEditingController) {
  return Column(
    children: [
      Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Tap(
            onTap: () {
              GestureDetector(
                onTap: () {
                  textEditingController.text = user.displayName;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormFieldWithDelete(
                              obscureText: true,
                              focusNode: FocusNode(),
                              textInputAction: TextInputAction.done,
                              controller: textEditingController,
                              deleteRightPadding: 5,
                              texthint: user.displayName.tr(),
                              onEditingComplete: () async {},
                            ).pOnly(top: 5),
                          ),
                          IconButton(
                            iconSize: 42,
                            color: Colors.black,
                            icon: const Icon(
                              Icons.arrow_circle_up,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              // ref
                              //     .read(
                              //         profileControllerProvider.notifier)
                              //     .updateDisplayName(
                              //         _textEditingController.text);

                              Navigator.pop(context);
                              textEditingController.clear();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 40,
                      ),
                      Text(user.displayName, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              );
            },
            child: user.displayName.text.lg.medium.make().pSymmetric(v: 10, h: 20),
          )),
    ],
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
                    'Birthday'.tr().text.lg.medium.color(AppColors.primary600).make(),
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
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: const Offset(8, 8))
                                          ]),
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
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: const Offset(8, 8))
                                          ]),
                                      child:
                                          Center(child: Text('female'.tr(), style: const TextStyle(fontSize: 24))).p(5))
                                  .pSymmetric(v: 10),
                            ),
                          ],
                        );
                      });
                },
                child: Column(
                  children: [
                    'female'.tr().text.lg.medium.color(AppColors.primary600).make(),
                    (friend.gender == 'female') ? 'female'.tr().text.lg.make() : 'male'.tr().text.lg.make(),
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
    'disconnect friend'.tr(),
    onPressed: () {
      ref.read(matchTabControllerProvider.notifier).breakUp();
    },
  );
}
