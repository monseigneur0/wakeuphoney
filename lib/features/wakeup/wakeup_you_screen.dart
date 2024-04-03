import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/common/common.dart';

import '../profile/profile_controller.dart';
import 'wakeup_controller.dart';
import 'wakeup_me_alarm.dart';
import 'wakeup_write_screen.dart';
import 'wakeup_status.dart';

class WakeUpYouScreen extends ConsumerStatefulWidget {
  const WakeUpYouScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeUpYouScreenState();
}

class _WakeUpYouScreenState extends ConsumerState<WakeUpYouScreen> {
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(getUserProfileStreamProvider);

    final wakeUpYou = ref.watch(getTomorrowWakeUpYouProvider);
    Logger logger = Logger();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: (kDebugMode) ? const Text('WakeUpYouScreeeeeeen') : Text(AppLocalizations.of(context)!.wakeupgom),
      ),
      body: userInfo.when(
          data: (user) {
            return wakeUpYou.when(
              data: (wakeUp) {
                if (wakeUp.letter.isEmpty || wakeUp.letter == "") {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => context.pushNamed(WakeUpWriteScreen.routeName),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
                                ]),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        width: 45,
                                        imageUrl: user.couplePhotoURL ??
                                            "https://firebasestorage.googleapis.com/v0/b/wakeuphoneys2.appspot.com/o/images%2F2024-01-08%2019:23:12.693630?alt=media&token=643f9416-0203-4e75-869a-ea0240e14ca4",
                                      ),
                                    ).p(10),
                                    user.coupleDisplayName!.text.make(),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    ImageIcon(
                                      const AssetImage('assets/alarm-clock.png'),
                                      size: 29,
                                      color: Colors.grey[400],
                                    ),
                                    "00:00".text.bold.gray400.size(18).make().pSymmetric(h: 14),
                                  ],
                                ),
                                const Image(
                                  image: AssetImage('assets/images/sleepingbear.png'),
                                  height: Constants.pngSize,
                                  opacity: AlwaysStoppedAnimation<double>(0.3),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WakeUpStatus(AppLocalizations.of(context)!.wakeupyou),
                                    const Icon(Icons.add, size: 40).p(10),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    NoIconWakeUp(Icons.photo_size_select_actual_outlined),
                                    NoIconWakeUp(Icons.mode_edit_outlined),
                                    NoIconWakeUp(Icons.mic_none_outlined),
                                  ],
                                ),
                                10.heightBox
                              ],
                            )).p(10),
                      ),
                      // GestureDetector(
                      //     onTap: () {
                      //       context.pushNamed(WakeUpWriteScreen.routeName);
                      //     },
                      //     child: Container(
                      //       width: MediaQuery.of(context).size.width * 0.6,
                      //       height: 300,
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(30),
                      //           color: AppColors.rabbitspeak,
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
                      //           ]),
                      //       // color: AppColors.rabbitspeak,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Container(
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(15),
                      //                 color: Colors.white,
                      //                 boxShadow: [
                      //                   BoxShadow(
                      //                       color: Colors.black.withOpacity(0.02),
                      //                       blurRadius: 5,
                      //                       offset: const Offset(4, 4))
                      //                 ]),
                      //             child: Column(
                      //               children: [
                      //                 Text(
                      //                   AppLocalizations.of(context)!.wakeupyou,
                      //                   style: const TextStyle(
                      //                     fontSize: 16,
                      //                     // fontFamily: GoogleFonts.anticSlab().fontFamily,
                      //                   ),
                      //                 ).p(10),
                      //               ],
                      //             ),
                      //           ).pSymmetric(h: 10, v: 10),
                      //           const Image(
                      //             image: AssetImage('assets/images/sleepingbear.png'),
                      //             height: Constants.pngSize,
                      //           ),
                      //         ],
                      //       ),
                      //     )).pSymmetric(h: 15, v: 15),
                    ],
                  );
                } else if (wakeUp.isApproved == true) {
                  return Container(
                      color: AppColors.rabbitspeak,
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        WakeUpStatus(AppLocalizations.of(context)!.wakeupapproved),
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
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      WakeUpStatus(AppLocalizations.of(context)!.wakeupnotapproved),
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
              },
            );
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

class NoIconWakeUp extends StatelessWidget {
  final IconData icon;
  const NoIconWakeUp(
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: Icon(icon, size: 25).p(10));
  }
}

class IconWakeUp extends StatelessWidget {
  final IconData icon;
  const IconWakeUp(
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.myPink.withOpacity(0.7),
        ),
        child: Icon(icon, size: 25).p(10));
  }
}
