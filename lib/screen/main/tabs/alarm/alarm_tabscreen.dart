import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';

import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/screen/auth/user_model.dart';
import 'package:wakeuphoney/screen/main/tabs/alarm/alarm_accept_box.dart';
import 'package:wakeuphoney/screen/main/tabs/alarm/alarm_accepted_box.dart';
import 'package:wakeuphoney/screen/main/tabs/alarm/alarm_empty.dart';
import 'package:wakeuphoney/screen/main/tabs/alarm/alarm_manager.dart';
import 'package:wakeuphoney/screen/main/tabs/alarm/feedbox.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_controller.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_model.dart';

/// 이 페이지의 역할
/// 알람을 수락하고 등록하는 페이지
/// 여러 위젯들을 들고있음
///

class AlarmTabScreen extends ConsumerWidget {
  static const routeName = '/alarm';
  static const routeUrl = '/alarm';
  const AlarmTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userModelProvider);
    final friend = ref.watch(friendUserModelProvider);
    if (user == null) {
      return const CircularProgressIndicator();
    }
    final myAlarm = ref.watch(wakeListStreamProvider);
    return myAlarm.when(
      data: (alarm) {
        if (alarm.isEmpty) {
          return EmptyAlarm(user: user);
        }
        return Column(
          children: [
            const AlarmManager(),
            AlarmList(ref, alarm: alarm, user: user),
          ],
        );
      },
      error: streamError, // Define the 'error' variable
      //나중에 글로벌 에러 핸들링으로 변경
      loading: () => const CircularProgressIndicator(), // Define the 'loading' variable
      // 나ㅇ에 글로벌 로딩 페이지으로 변경
    );
  }

  Widget streamError(error, stackTrace) => Text('Error: $error');
}

class AlarmList extends StatelessWidget {
  final List<WakeModel> alarm;
  final UserModel user;
  final WidgetRef ref;
  const AlarmList(this.ref, {required this.alarm, required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (kDebugMode) ? context.deviceHeight - 190 : context.deviceHeight - 100,
      child: ListView.builder(
        itemCount: alarm.length,
        itemBuilder: (context, index) {
          final wake = alarm[index];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.whiteBackground,
              border: Border.all(color: AppColors.point700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                wake.isApproved ? AcceptedBox(user, wake) : AcceptBox(user, wake),
                height10,
                FeedBox(user, wake),
              ],
            ),
          );
        },
      ),
    );
  }
}
