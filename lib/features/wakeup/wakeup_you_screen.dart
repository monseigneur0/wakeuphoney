import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/auth/auth_controller.dart';

import '../../core/constants/design_constants.dart';
import 'wakeup_controller.dart';
import 'wakeup_edit_screen.dart';

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
    final coupleUid = ref.watch(getFutureMyUserDataProvider);

    return Column(
      children: [
        100.heightBox,
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
                          height: MediaQuery.of(context).size.height - 300,
                          color: AppColors.sleepingbear,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text("상대를 깨워 볼까요?"),
                                  Image(
                                    image: AssetImage(
                                        'assets/images/sleepingbear.jpeg'),
                                    height: 250,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  } else if (data.isApproved == true) {
                    return Container(
                        color: AppColors.awakebear,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 250,
                        child: Column(children: [
                          Text(data.wakeUpUid),
                          Text(data.createdTime.toString()),
                          Text(data.letter),
                          Text(data.senderUid),
                          Text(data.reciverUid),
                          Text(data.wakeTime.toString()),
                          const Text("승낙하셨습니다."),
                          const Image(
                            image: AssetImage('assets/images/rabbitspeak.jpeg'),
                            height: 250,
                          )
                        ]));
                  }
                  return Container(
                      color: AppColors.awakebear,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 250,
                      child: Column(children: [
                        const Text("이 때 깨울거에요!!ㅎㅎ 아직 승낙 안했어요"),
                        Text(data.wakeUpUid),
                        Text(data.createdTime.toString()),
                        Text(data.letter),
                        Text(data.senderUid),
                        Text(data.reciverUid),
                        Text(data.wakeTime.toString()),
                        Text(data.isApproved.toString()),
                        const Image(
                          image: AssetImage('assets/images/awakebear.jpeg'),
                          height: 250,
                        ),
                        const Text("이 때 깨울거에요!!ㅎㅎ 아직 승낙 안했어요"),
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
