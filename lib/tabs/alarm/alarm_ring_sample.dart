import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/tabs/friend/friend_tabscreen.dart';
import 'package:wakeuphoney/tabs/wake/wake_controller.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';
import 'package:wakeuphoney/tabs/wake/wake_tabscreen.dart';

class AlarmRingSampleScreen extends ConsumerWidget {
  static String routeName = "alarmringsample";
  static String routeUrl = "/alarmringsample";
  const AlarmRingSampleScreen({super.key});

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
                  orElse: () => WakeModel.sample(),
                );
                logger.d('ringingAlarm: $ringingAlarm');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    height40,
                    height40,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TimeBar(ringingAlarm),
                      ],
                    ),
                    height10,
                    profileImage(friend ?? UserModel.empty()),
                    height10,
                    '${friend?.displayName ?? UserModel.empty()}님이 알람 메세지를 남겼어요'.text.medium.make(),
                    height20,
                    TextMessageBox(ringingAlarm.message),
                    height10,
                    ImageBox(ringingAlarm.messagePhoto),
                    height40,
                    CoupleButton(ref), //버튼 위치는 항상 고정해야하지 않을까
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

class CoupleButton extends StatelessWidget {
  final WidgetRef ref;
  const CoupleButton(this.ref, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // ref.read(wakeControllerProvider.notifier).approveWake();
              // //stop alarm
              // Alarm.stop;
              // context.push(WakeTabScreen.routeUrl);
            },
            child: '다시 알림'.text.make(),
          ),
        ),
        width10,
        Expanded(
          child: NormalButton(
            onPressed: () {
              // ref.read(wakeControllerProvider.notifier).rejectWake();
              // context.push(FriendTabScreen.routeUrl);
            },
            text: '답장하러 가기',
          ),
        ),
      ],
    );
  }
}
