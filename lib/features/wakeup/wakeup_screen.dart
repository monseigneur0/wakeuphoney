import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/wakeup/wakeup_edit_screen.dart';

import '../../core/constants/design_constants.dart';
import '../wake/wake_edit_screen.dart';
import 'wakeup_controller.dart';

class WakeUpScreen extends ConsumerStatefulWidget {
  const WakeUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeUpScreenState();
}

class _WakeUpScreenState extends ConsumerState<WakeUpScreen> {
  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.7,
          child: WakeEditScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wakeMeUp = ref.watch(getTomorrowWakeMeUpProvider);
    final wakeYouUp = ref.watch(getTomorrowWakeYouUpProvider);
    Logger logger = Logger();

    return Scaffold(
      appBar: AppBar(
        title: const Text('깨워볼까요?!'),
      ),
      body: Column(children: [
        Flexible(
            flex: 3,
            child: wakeMeUp.when(
                data: (data) {
                  if (data.letter.isEmpty || data.letter == "") {
                    return Container(
                      color: Colors.green,
                      child: const Center(child: Text("상대가 깨워주지 않았어요?")),
                    );
                  }
                  if (data.isApproved == true) {
                    return Container(
                        color: AppColors.myPink,
                        child: Column(children: [
                          Text(data.wakeUpUid),
                          Text(data.wakeTime.toString()),
                          const Text("승낙하셨습니다."),
                        ]));
                  }
                  return GestureDetector(
                    onTap: () {
                      ref
                          .watch(wakeUpControllerProvider.notifier)
                          .wakeUpAprove(data.wakeUpUid);
                    },
                    child: Container(
                        color: AppColors.myPink,
                        child: Column(children: [
                          Text(data.wakeUpUid),
                          Text(data.wakeTime.toString()),
                          const Text("승낙하시면 알람이 울립니다."),
                        ])),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  logger.e(err);

                  return const Center(
                    child: Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                })),
        Flexible(
            flex: 3,
            child: wakeYouUp.when(
                data: (data) {
                  if (data.letter.isEmpty || data.letter == "") {
                    return GestureDetector(
                        onTap: () {
                          context.pushNamed(WakeUpEditScreen.routeName);
                        },
                        child: Container(
                          color: Colors.green,
                          child: const Center(child: Text("깨워볼까요?!")),
                        ));
                  }
                  return Container(
                      color: AppColors.myPink,
                      child: Column(children: [
                        Text(data.wakeUpUid),
                        Text(data.wakeTime.toString()),
                        const Text("이때 깨울거야 각오해"),
                      ]));
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  logger.e(err);

                  return const Center(
                    child: Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                })),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.yellow,
            child: Center(child: "여긴 광고에요".text.make()),
          ),
        ),
      ]),
    );
  }
}
