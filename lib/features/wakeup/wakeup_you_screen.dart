import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                          height: MediaQuery.of(context).size.width - 70,
                          color: AppColors.sleepingbear,
                          child: Center(
                            child: Column(
                              children: [
                                WakeUpStatus(
                                    AppLocalizations.of(context)!.wakeupyou),
                                const Image(
                                  image: AssetImage(
                                      'assets/images/sleepingbear.jpeg'),
                                  height: 220,
                                ),
                              ],
                            ),
                          ),
                        ));
                  } else if (data.isApproved == true) {
                    return Container(
                        color: AppColors.rabbitspeak,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width - 70,
                        child: Column(children: [
                          WakeUpStatus(
                              AppLocalizations.of(context)!.wakeupapproved),
                          const Image(
                            image: AssetImage('assets/images/rabbitspeak.jpeg'),
                            height: 220,
                          )
                        ]));
                  }
                  return Container(
                      color: AppColors.awakebear,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Column(children: [
                        WakeUpStatus(
                            AppLocalizations.of(context)!.wakeupnotapproved),
                        const Image(
                          image: AssetImage('assets/images/awakebear.jpeg'),
                          height: 220,
                        ),
                      ]));
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  logger.e(err);

                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.erroruser,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                })),
      ],
    );
  }
}
