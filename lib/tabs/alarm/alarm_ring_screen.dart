import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/common/widget/w_main_button_disabled.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_reply_screen.dart';
import 'package:wakeuphoney/tabs/wake/wake_controller.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';
import 'package:wakeuphoney/tabs/wake/wake_tabscreen.dart';

class AlarmRingScreen extends ConsumerWidget {
  static String routeName = "alarmringsample";
  static String routeUrl = "/alarmringsample";
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({
    super.key,
    required this.alarmSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAlarm = ref.watch(alarmListStreamProvider);
    final friend = ref.watch(friendUserModelProvider);
    Logger logger = Logger();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: myAlarm.when(
            data: (alarm) {
              if (alarm.isEmpty) {
                return const Center(
                  child: EmptyBox(),
                );
              } else {
                final now = DateTime.now();
                final ringingAlarm = alarm.firstWhere(
                  (a) => a.wakeTime.isBefore(now),
                  orElse: () {
                    return WakeModel.sample();
                  },
                );
                logger.d('ringingAlarm: $ringingAlarm');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    height40,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TimeBarBig(ringingAlarm),
                      ],
                    ),
                    height10,
                    // profileImage(friend ?? UserModel.empty()),
                    height10,
                    'left a message'.tr(args: [friend?.displayName ?? UserModel.empty().displayName]).text.medium.make(),
                    height20,
                    TextMessageBox(ringingAlarm.message),
                    height10,
                    ImageBox(ringingAlarm.messagePhoto),

                    height40,
                    const InfoBox(),
                    height10,
                    WakeModel.sample() == ringingAlarm ? Container() : CoupleButton(ref, ringingAlarm, alarmSettings), //버튼 위치는 항상 고정해야하지 않을까
                  ],
                ).pSymmetric(v: 10, h: 20);
              }
            },
            error: streamError, // Define the 'error' variable
            //나중에 글로벌 에러 핸들링으로 변경
            loading: () => const CircularProgressIndicator(), // Define the 'loading' variable
            // 나ㅇ에 글로벌 로딩 페이지으로 변경
          ),
        ),
      ),
    );
  }

  Widget streamError(error, stackTrace) {
    Logger logger = Logger();
    logger.e(
      'Error: $error Stack Trace: $stackTrace',
    );
    return Text('Error: $error');
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            'Please reply.'.tr().text.medium.make(),
            height10,
            'If you select snooze, it will ring again in 10 minutes.'.tr().text.medium.make(),
          ],
        ),
      ),
    );
  }
}

class CoupleButton extends StatelessWidget {
  final WidgetRef ref;
  final WakeModel wake;
  final AlarmSettings alarmSettings;
  const CoupleButton(this.ref, this.wake, this.alarmSettings, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded(
        //   child: ElevatedButton(
        //     onPressed: () {
        //       // ref.read(wakeControllerProvider.notifier).approveWake();
        //       // //stop alarm
        //       // Alarm.stop;
        //       // context.push(WakeTabScreen.routeUrl);
        //     },
        //     child: '다시 알림'.text.make(),
        //   ),
        // ),
        Expanded(
          child: MainButtonDisabled(
            'Snooze'.tr(),
            onPressed: () {
              // Alarm.stop(alarmSettings.id);
              final now = DateTime.now();
              Alarm.set(
                alarmSettings: alarmSettings.copyWith(
                  dateTime: DateTime(
                    now.year,
                    now.month,
                    now.day,
                    now.hour,
                    now.minute,
                  ).add(const Duration(minutes: 10)),
                ),
              ).then((_) => Navigator.pop(context));

              // ref.read(wakeControllerProvider.notifier).approveWake();
              // //stop alarm
              // Alarm.stop; and restart alarm
              // context.push(WakeTabScreen.routeUrl);
            },
          ),
        ),
        width10,
        Expanded(
          child: MainButton(
            'Go to reply'.tr(),
            onPressed: () {
              Alarm.stop(alarmSettings.id);
              // ref.read(wakeControllerProvider.notifier).rejectWake();
              context.push(AlarmReplyScreen.routeUrl);
              ref.read(wakeIdProvider.notifier).state = wake.wakeUid.toString();
            },
          ),
        ),
      ],
    );
  }
}

class TimeBarBig extends StatelessWidget {
  final WakeModel wake;
  const TimeBarBig(
    this.wake, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DateFormat('a').format(wake.wakeTime).text.size(24).medium.color(AppColors.primary700).make(),
        width5,
        DateFormat('hh:mm').format(wake.wakeTime).text.size(32).semiBold.color(AppColors.primary700).make(),
        width5,
        // if (kDebugMode) wake.wakeTime.toString().text.make(),
        width5,
        if (wake.messageAudio.isNotEmpty)
          const CircleAvatar(
            backgroundColor: AppColors.grey900,
            radius: 13,
            child: Icon(
              Icons.mic,
              color: Colors.white,
              size: 20,
            ),
          ),
      ],
    );
  }
}
