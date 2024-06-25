import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/tabs/manager/manager_controller.dart';

class ManageUserScreen extends ConsumerStatefulWidget {
  static const String routeName = 'manage_user';
  static const String routeUrl = '/manage_user';
  const ManageUserScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends ConsumerState<ManageUserScreen> {
  @override
  Widget build(BuildContext context) {
    final recentUser = ref.watch(futureRecentUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Center(
              child: Text('Manage User Screen'),
            ),
            //새로운 사용자 1주일 이내 생성자 이면서 커플 등록자들

            // 새로운 유저 등록 버튼
            MainButton('New User Registration', onPressed: () {
              ref.read(managerControllerProvider.notifier).createNewUser();
            }),
            //사용자들 목록 보여주기
            recentUser.when(
              data: (users) {
                return Column(
                  children: users.map((user) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(user.displayName),
                          subtitle: Text(user.email),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ).pSymmetric(h: 20, v: 20),
      ),
    );
  }
}
