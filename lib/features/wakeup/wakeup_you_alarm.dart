import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/common/common.dart';

import '../profile/profile_controller.dart';
import 'wakeup_controller.dart';
import 'wakeup_status.dart';
import 'wakeup_you_screen.dart';

class WakeUpYouAlarmScreen extends ConsumerStatefulWidget {
  const WakeUpYouAlarmScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeUpYouAlarmScreenState();
}

class _WakeUpYouAlarmScreenState extends ConsumerState<WakeUpYouAlarmScreen> {
  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(getUserProfileStreamProvider);
    final wakeUpMeAlarm = ref.watch(wakeUpMeAlarmProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: (kDebugMode) ? const Text('WakeUpYouAlarmScreen') : Text(AppLocalizations.of(context)!.wakeupgom),
      ),
      body: userInfo.when(
          data: (user) {
            return wakeUpMeAlarm.when(
                data: (alarm) {
                  if (user.couple == null || user.couple!.isEmpty || user.couple! == "") {
                    return Container(
                      child: const Center(
                        child: Text("You don't have a friend yet."),
                      ),
                    );
                  }
                  if (alarm.isEmpty) {
                    return Container(
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(8, 8))
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
                                    imageUrl: user.couplePhotoURL ?? Constants.userDefault,
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
                              image: AssetImage('assets/images/rabbitwake.png'),
                              height: Constants.pngSize,
                              opacity: AlwaysStoppedAnimation<double>(0.3),
                            ),
                            WakeUpStatus(AppLocalizations.of(context)!.wakeupyou),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                NoIconWakeUp(Icons.photo_size_select_actual_outlined),
                                NoIconWakeUp(Icons.email_outlined),
                                NoIconWakeUp(Icons.voice_chat),
                              ],
                            ),
                            10.heightBox
                          ],
                        )).p(10);
                  }
                  return GestureDetector(
                    onTap: () {},
                    child: ListView.builder(
                      itemCount: alarm.length,
                      itemBuilder: (context, index) {
                        if (alarm[index].senderUid == user.uid || alarm[index].wakeTime.isAfter(DateTime.now())) {
                          //목록 중에 내가 보낸 알람이거나, 아직 시간이 안 지난 알람이면 보여야지?
                          //목록 중에 상대가 보낸거면 여기 보일 필요 없지?
                          //목록 중에 내가 보낸 적 없고 이 시간 이후 다음 설정된 알람이 없으면 꺠워 줘야지? 둘 다 겹쳐야해.
                          //
                          return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(8, 8))
                                  ]),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                            width: 45, imageUrl: user.couplePhotoURL ?? Constants.userDefault),
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
                                      "00:001".text.bold.gray400.size(18).make().pSymmetric(h: 14),
                                    ],
                                  ),
                                  const Image(
                                    image: AssetImage('assets/images/rabbitwake.png'),
                                    height: Constants.pngSize,
                                    opacity: AlwaysStoppedAnimation<double>(0.3),
                                  ),
                                  WakeUpStatus(AppLocalizations.of(context)!.wakeupyou),
                                  10.heightBox
                                ],
                              )).p(10);
                        }
                        if (alarm[index].senderUid == user.uid) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(8, 8))
                                    ]),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            width: 45,
                                            imageUrl: user.couplePhotoURL ?? Constants.userDefault,
                                          ),
                                        ).p(10),
                                        user.coupleDisplayName!.text.make(),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        const ImageIcon(
                                          AssetImage('assets/alarm-clock.png'),
                                          size: 29,
                                          // color: AppColors.myPink,
                                        ),
                                        DateFormat("HH:mm")
                                            .format(alarm[index].wakeTime)
                                            .toString()
                                            .text
                                            .bold
                                            .size(18)
                                            .make()
                                            .pSymmetric(h: 14),
                                      ],
                                    ),
                                    const Image(
                                      image: AssetImage('assets/images/rabbitwake.png'),
                                      height: Constants.pngSize,
                                      opacity: AlwaysStoppedAnimation<double>(0.6),
                                    ),
                                    WakeUpStatus(AppLocalizations.of(context)!.wakeupmenotapproved),
                                    10.heightBox
                                  ],
                                )).p(10),
                          );
                        }
                        return null;
                      },
                    ),
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
                });
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
