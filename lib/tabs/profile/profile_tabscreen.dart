import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/firebase_providers.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/widget/w_arrow.dart';

import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/auth/login_tabscreen.dart';
import 'package:wakeuphoney/opensource/s_opensource.dart';
import 'package:wakeuphoney/tabs/customer/cs_service_screen.dart';
import 'package:wakeuphoney/tabs/match/match_tab_controller.dart';
import 'package:wakeuphoney/tabs/profile/myprofile_tabscreen.dart';

class ProfileTabScreen extends StatefulHookConsumerWidget {
  const ProfileTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends ConsumerState<ProfileTabScreen> {
  @override
  Widget build(BuildContext context) {
    final analytics = ref.watch(analyticsProvider);
    final user = ref.watch(userModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: const Row(
                children: [],
              ).pSymmetric(h: 20),
            ),
            height20,
            Column(
              children: [
                if (kDebugMode || user!.uid == 'WvELgU4cO6gOeyzfu92j3k9vuBH2')
                  LinkCard('WakeupBear'.tr(), onTap: () {
                    context.push('/manager');
                  }),
                LinkCard('App Introduction'.tr(), onTap: () {
                  launchUrlString("https://sweetgom.com/5");
                  analytics.logSelectContent(contentType: "go", itemId: "appinfoonline");
                }),
                LinkCard('My account information'.tr(), onTap: () {
                  context.push(MyProfileTabScreen.routeUrl);
                }),
                LinkCard('Wake confirmation time', onTap: () {}),
                LinkCard('Customer Center'.tr(), onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerServiceScreen(),
                      ));
                }),
                LinkCard('App Version Information'.tr(), info: '1.1.9', onTap: () {}),
                LinkCard('Open Source'.tr(), onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OpensourceScreen(),
                      ));
                }),
                LinkCard('Privacy Policy'.tr(), onTap: () {
                  launchUrlString('https://sweetgom.com/4');
                  analytics.logSelectContent(contentType: "go", itemId: "appinfopolicy");
                }),
                LinkCard('login information', info: user!.loginType == null ? 'null'.tr() : user.loginType.toString(), onTap: () {
                  context.showSnackbar('로그인 정보: ${user.loginType}\n이메일 정보: ${user.email}');
                }),
                LinkCard('Signout'.tr(), onTap: () {
                  context.go(LoginNewScreen.routeUrl);
                  ref.read(loginControllerProvider.notifier).signOut(context);
                }),
                LinkCard('disconnect friend'.tr(), onTap: () {
                  Platform.isIOS
                      ? showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: Text('disconnect friend'.tr()),
                                content: Text('disconnect friend'.tr()),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('no'.tr()),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      ref.read(matchTabControllerProvider.notifier).breakUp();
                                      Navigator.of(context).pop();
                                    },
                                    isDestructiveAction: true,
                                    child: Text('yes'.tr()),
                                  ),
                                ],
                              ))
                      : showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('disconnect friend'.tr()),
                              content: Text('disconnect friend'.tr()),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ref.read(matchTabControllerProvider.notifier).breakUp();
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            );
                          });
                }),
                LinkCard('delete user'.tr(), onTap: () {
                  ref.read(matchTabControllerProvider.notifier).breakUp();
                  ref.read(loginControllerProvider.notifier).deleteUser();
                }),
              ],
            ),
            height30,
            height30,
          ],
        ),
      ),
    );
  }
}

class LinkCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String? info;
  const LinkCard(
    this.title, {
    required this.onTap,
    this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: Row(
        children: [
          title.tr().text.make(),
          const EmptyExpanded(),
          info.isEmptyOrNull ? const Arrow() : info!.tr().text.make(),
        ],
      ).pSymmetric(h: 20, v: 15),
    );
  }
}
