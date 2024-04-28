import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/w_arrow.dart';
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
              LinkCard('앱소개', onTap: () {}).pSymmetric(h: 20, v: 10),
              LinkCard('내 정보 관리', onTap: () {}).pSymmetric(h: 20, v: 10),
              LinkCard('편지 확인 가능 시간', onTap: () {}).pSymmetric(h: 20, v: 10),
              LinkCard('고객센터', onTap: () {}).pSymmetric(h: 20, v: 10),
              LinkCard('버전정보', onTap: () {}).pSymmetric(h: 20, v: 10),
              LinkCard('개인정보처리방침', onTap: () {}).pSymmetric(h: 20, v: 10),
              LinkCard('로그아웃', onTap: () {}).pSymmetric(h: 20, v: 10),
              LinkCard('회원탈퇴', onTap: () {}).pSymmetric(h: 20, v: 10),
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
  const LinkCard(
    this.title, {
    required this.onTap,
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
          const Arrow(),
        ],
      ),
    );
  }
}
