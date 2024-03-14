import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/design_constants.dart';
import 'wakeup_controller.dart';
import 'wakeup_edit_screen.dart';
import 'wakeup_status.dart';

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

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(AppLocalizations.of(context)!.wakeupbear),
      // ),
      body: wakeUpYou.when(
          data: (wakeUp) {
            if (wakeUp.letter.isEmpty || wakeUp.letter == "") {
              return Column(
                children: [
                  80.heightBox,
                  GestureDetector(
                      onTap: () {
                        context.pushNamed(WakeUpEditScreen.routeName);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.rabbitspeak,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(8, 8))
                            ]),
                        // color: AppColors.rabbitspeak,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 5,
                                        offset: const Offset(4, 4))
                                  ]),
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.wakeupyou,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      // fontFamily: GoogleFonts.anticSlab().fontFamily,
                                    ),
                                  ).p(10),
                                ],
                              ),
                            ).pSymmetric(h: 10, v: 10),
                            const Image(
                              image:
                                  AssetImage('assets/images/sleepingbear.png'),
                              height: Constants.pngSize,
                            ),
                          ],
                        ),
                      )).pSymmetric(h: 15, v: 15),
                ],
              );
            } else if (wakeUp.isApproved == true) {
              return Container(
                  color: AppColors.rabbitspeak,
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                // height: MediaQuery.of(context).size.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
          }),
    );
  }
}
