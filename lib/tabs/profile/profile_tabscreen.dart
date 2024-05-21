import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/auth/login_tabscreen.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/image/image_full_screen.dart';
import 'package:wakeuphoney/common/image/image_screen.dart';
import 'package:wakeuphoney/common/providers/firebase_providers.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/widget/w_arrow.dart';
import 'package:wakeuphoney/opensource/s_opensource.dart';
import 'package:wakeuphoney/tabs/customer/cs_service_screen.dart';
import 'package:wakeuphoney/tabs/friend/friend_tabscreen.dart';

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
        title: const Text('프로필'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            height20,
            SizedBox(
              child: Row(
                children: [
                  Column(
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
                          child: profileImage(
                            user!,
                            herotag: 'profileImage',
                          )),
                      user.displayName.text.make(),
                    ],
                  ),
                  // width20,
                  // Column(
                  //   children: [
                  //     ClipOval(
                  //       child: Image.asset(
                  //         'assets/images/samples/cherryblossom.png',
                  //         width: Constants.pngSize,
                  //         height: Constants.pngSize,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //     const Text('프로필2'),
                  //   ],
                  // ),
                ],
              ).pSymmetric(h: 20),
            ),
            height20,
            Column(
              children: [
                LinkCard('앱소개', onTap: () {
                  launchUrlString("https://sweetgom.com/5");
                  analytics.logSelectContent(contentType: "go", itemId: "appinfoonline");
                }),
                LinkCard('내 정보 관리', onTap: () {}),
                LinkCard('편지 확인 가능 시간', onTap: () {}),
                LinkCard('고객센터', onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerServiceScreen(),
                      ));
                }),
                LinkCard('버전정보', version: '1.1.0', onTap: () {}),
                LinkCard('오픈소스', onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OpensourceScreen(),
                      ));
                }),
                LinkCard('개인정보처리방침', onTap: () {
                  launchUrlString('https://sweetgom.com/4');
                  analytics.logSelectContent(contentType: "go", itemId: "appinfopolicy");
                }),
                LinkCard('로그아웃', onTap: () {
                  // context.go(LoginNewScreen.routeUrl);
                  context.go(LoginNewScreen.routeUrl);
                  ref.read(loginControllerProvider.notifier).signOut(context);
                }),
                // LinkCard('연결끊기', onTap: () {
                //   ref.read(matchTabControllerProvider.notifier).breakUp();
                // }),
                LinkCard('회원탈퇴', onTap: () {}),
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
  final String? version;
  const LinkCard(
    this.title, {
    required this.onTap,
    this.version,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: Row(
        children: [
          title.text.make(),
          const EmptyExpanded(),
          version.isEmptyOrNull ? const Arrow() : version!.text.make(),
        ],
      ).pSymmetric(h: 20, v: 15),
    );
  }
}
