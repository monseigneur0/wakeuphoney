import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/core/providers/providers.dart';

class AlarmTabScreen extends StatefulHookConsumerWidget {
  static const routeName = '/alarm';
  static const routeUrl = '/alarm';
  const AlarmTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmTabScreenState();
}

class _AlarmTabScreenState extends ConsumerState<AlarmTabScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    if (user == null) {
      return const CircularProgressIndicator();
    }
    return Tap(
      onTap: () {
        if (user.couples!.isEmpty) {
          context.go('/main/match');
        } else {
          context.go('/main/wake');
          context.showSnackbar('깨우러 가기');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/aiphotos/awakebear.png",
            width: Constants.emptyPagePngWidth,
          ),
          height20,
          user.couples != null
              ? user.couples!.isEmpty
                  ? '상대와 연결해주세요'.text.size(18).bold.make()
                  : '상대가 아직 깨워주지 않았어요!'.text.size(18).bold.make()
              : '로그인 실패했습니다. 다시 시도해주세요.'.text.color(Colors.red).size(18).bold.make(),
          height40,
        ],
      ),
    );
  }
}
