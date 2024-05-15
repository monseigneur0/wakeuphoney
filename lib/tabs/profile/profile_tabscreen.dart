import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/w_arrow.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/auth/login_tabscreen.dart';
import 'package:wakeuphoney/tabs/match/match_tabscreen.dart';
import 'package:wakeuphoney/tabs/profile/single_profile_screen.dart';
import 'package:wakeuphoney/opensource/s_opensource.dart';

class ProfileTabScreen extends StatefulHookConsumerWidget {
  const ProfileTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends ConsumerState<ProfileTabScreen> {
  @override
  Widget build(BuildContext context) {
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
                        onTap: () => context.go(SingleProfileScreen.routeUrl),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/samples/cherryblossom.png',
                            width: Constants.pngSize,
                            height: Constants.pngSize,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Text('프로필'),
                    ],
                  ),
                  width20,
                  Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/samples/cherryblossom.png',
                          width: Constants.pngSize,
                          height: Constants.pngSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Text('프로필2'),
                    ],
                  ),
                ],
              ).pSymmetric(h: 20),
            ),
            height20,
            Column(
              children: [
                LinkCard('앱소개', onTap: () {}),
                LinkCard('내 정보 관리', onTap: () {}),
                LinkCard('편지 확인 가능 시간', onTap: () {}),
                LinkCard('고객센터', onTap: () {}),
                LinkCard('버전정보', version: '1.1.0', onTap: () {}),
                LinkCard('오픈소스', onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OpensourceScreen(),
                      ));
                }),
                LinkCard('개인정보처리방침', onTap: () {}),
                LinkCard('로그아웃', onTap: () {
                  // context.go(LoginNewScreen.routeUrl);
                  context.go(LoginNewScreen.routeUrl);
                  ref.watch(loginControllerProvider.notifier).signOut(context);
                }),
                if (kDebugMode)
                  Column(
                    children: [
                      LinkCard('그냥 로그아웃', onTap: () {
                        // context.go(LoginNewScreen.routeUrl);
                        ref.watch(loginControllerProvider.notifier).signJustOut(context);
                      }),
                      LinkCard('로그인페이지  context.push', onTap: () {
                        context.push(LoginNewScreen.routeUrl);
                      }),
                    ],
                  ),
                LinkCard('연결끊기', onTap: () {}),
                LinkCard('회원탈퇴', onTap: () {}),
                if (kDebugMode)
                  Row(
                    children: [
                      ElevatedButton(onPressed: () {}, child: '이전 디자인'.text.make()),
                      ElevatedButton(
                          onPressed: () {
                            context.go(MatchTabScreen.routeUrl);
                          },
                          child: '현재 디자인'.text.make()),
                    ],
                  ),
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
