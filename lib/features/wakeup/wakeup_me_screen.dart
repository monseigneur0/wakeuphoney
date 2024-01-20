import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../core/constants/design_constants.dart';
import 'wakeup_controller.dart';

class WakeUpMeScreen extends ConsumerStatefulWidget {
  const WakeUpMeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeUpMeScreenState();
}

class _WakeUpMeScreenState extends ConsumerState<WakeUpMeScreen> {
  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    final wakeMeUp = ref.watch(getTomorrowWakeUpMeProvider);

    return Container(
        child: wakeMeUp.when(
            data: (data) {
              if (data.letter.isEmpty || data.letter == "") {
                return Container(
                  color: Colors.blue,
                  child: const Center(child: Text("상대가 아직 깨워주지 않았어요")),
                );
              }
              if (data.isApproved == true) {
                return Container(
                    color: AppColors.myPink,
                    child: Column(children: [
                      Text(data.wakeUpUid),
                      Text(data.createdTime.toString()),
                      Text(data.letter),
                      Text(data.senderUid),
                      Text(data.reciverUid),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(data.wakeUpUid),
                      Text(data.wakeTime.toString()),
                      const Text("승낙하시면 알람이 울립니다."),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) {
              logger.e(err);

              return const Center(
                child: Text(
                  "Error\n please restart your app",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }));
  }
}
