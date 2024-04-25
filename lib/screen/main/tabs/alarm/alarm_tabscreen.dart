import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';

class AlarmTabScreen extends StatefulHookConsumerWidget {
  const AlarmTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmTabScreenState();
}

class _AlarmTabScreenState extends ConsumerState<AlarmTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/aiphotos/awakebear.png",
          width: Constants.emptyPagePngWidth,
        ),
        height20,
        '상대가 아직 깨워주지 않았어요!'.text.size(18).bold.make(),
        height40,
      ],
    );
  }
}
