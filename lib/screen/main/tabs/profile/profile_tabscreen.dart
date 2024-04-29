import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/w_arrow.dart';
import 'package:wakeuphoney/features/oldauth/auth_repository.dart';
import 'package:wakeuphoney/features/oldauth/login_screen.dart';
import 'package:wakeuphoney/screen/auth/login_tabscreen.dart';
import 'package:wakeuphoney/screen/main/tabs/profile/single_profile_screen.dart';

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
      body: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Tap(
                    onTap: () => Nav.push(const SingleProfileScreen()),
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
          height20,
          Column(
            children: [
              LinkCard('앱소개', onTap: () {}),
              LinkCard('내 정보 관리', onTap: () {}),
              LinkCard('편지 확인 가능 시간', onTap: () {}),
              LinkCard('고객센터', onTap: () {}),
              LinkCard('버전정보', version: '1.1.0', onTap: () {}),
              LinkCard('개인정보처리방침', onTap: () {}),
              LinkCard('로그아웃', onTap: () {
                Nav.push(const LoginNewScreen());
                ref.watch(authRepositoryProvider).logout();
              }),
              LinkCard('회원탈퇴', onTap: () {}),
            ],
          )
        ],
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
