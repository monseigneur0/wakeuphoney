import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/constants/design_constants.dart';
import 'wakeup_controller.dart';
import 'wakeup_edit_screen.dart';
import 'wakeup_me_screen.dart';

class WakeUpYouScreen extends ConsumerStatefulWidget {
  const WakeUpYouScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WakeUpYouScreenState();
}

class _WakeUpYouScreenState extends ConsumerState<WakeUpYouScreen> {
  @override
  Widget build(BuildContext context) {
    final wakeUpYou = ref.watch(getTomorrowWakeUpYouProvider);
    Logger logger = Logger();

    return Column(
      children: [
        // Container(
        //     child: coupleUid.when(
        //         data: (data) {
        //           return Text(data!.couple!);
        //         },
        //         loading: () => const Center(child: CircularProgressIndicator()),
        //         error: (err, stack) {
        //           logger.e(err);

        //           return const Center(
        //             child: Text(
        //               "Error\n please restart your app",
        //               style: TextStyle(color: Colors.red),
        //             ),
        //           );
        //         })),
        Container(
            child: wakeUpYou.when(
                data: (data) {
                  if (data.letter.isEmpty || data.letter == "") {
                    return GestureDetector(
                        onTap: () {
                          context.goNamed(WakeUpEditScreen.routeName);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width - 50,
                          color: AppColors.sleepingbear,
                          child: const Center(
                            child: Column(
                              children: [
                                WakeUpStatus("상대를 깨워 볼까요?"),
                                Image(
                                  image: AssetImage(
                                      'assets/images/sleepingbear.jpeg'),
                                  height: 250,
                                ),
                              ],
                            ),
                          ),
                        ));
                  } else if (data.isApproved == true) {
                    return Container(
                        color: AppColors.rabbitspeak,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width - 50,
                        child: const Column(children: [
                          WakeUpStatus("승낙하셨습니다."),
                          Image(
                            image: AssetImage('assets/images/rabbitspeak.jpeg'),
                            height: 250,
                          )
                        ]));
                  }
                  return Container(
                      color: AppColors.awakebear,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: const Column(children: [
                        WakeUpStatus("이 때 깨울거에요!!ㅎㅎ 아직 승낙 안했어요"),
                        Image(
                          image: AssetImage('assets/images/awakebear.jpeg'),
                          height: 250,
                        ),
                      ]));
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
                })),
      ],
    );
  }
}
