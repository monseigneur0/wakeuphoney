import 'package:alarm/model/alarm_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/oldauth/user_model.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_controller.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_model.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_tabscreen.dart';

class AlarmTabScreen extends ConsumerStatefulWidget {
  static const routeName = '/alarm';
  static const routeUrl = '/alarm';
  const AlarmTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmTabScreenState();
}

class _AlarmTabScreenState extends ConsumerState<AlarmTabScreen> {
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
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
        return AlarmList(ref, alarm: alarm, user: user);
      },
      error: (error, stackTrace) => Text('Error: $error'), // Define the 'error' variable
      //나중에 글로벌 에러 핸들링으로 변경
      loading: () => const CircularProgressIndicator(), // Define the 'loading' variable
      // 나ㅇ에 글로벌 로딩 페이지으로 변경
    );
  }
}

class AlarmTile extends StatelessWidget {
  const AlarmTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('AlarmTile'),
      onTap: () {
        context.go('/main/alarm');
      },
    );
  }
}

class AlarmList extends StatelessWidget {
  final List<WakeModel> alarm;
  final UserModel user;
  final WidgetRef ref;
  const AlarmList(this.ref, {required this.alarm, required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}

class AcceptBox extends ConsumerWidget {
  final UserModel user;
  final WakeModel wake;
  const AcceptBox(
    this.user,
    this.wake, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DateFormat('a hh:mm').format(wake.wakeTime).toString().text.bold.color(AppColors.primary700).make(),
        Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
        '이때 깨워줄게요!'.text.bold.make(),
        height10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalButton(
              text: '거절하기',
              onPressed: () {
                ref.read(wakeControllerProvider.notifier).deleteWakeUp(wake.wakeUid);
              },
              isPreferred: false,
            ),
            width10,
            NormalButton(
              text: '승낙하기',
              onPressed: () {
                ref.read(wakeControllerProvider.notifier).acceptWakeUp(wake.wakeUid);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class AcceptedBox extends ConsumerWidget {
  final UserModel user;
  final WakeModel wake;
  const AcceptedBox(
    this.user,
    this.wake, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DateFormat('a hh:mm').format(wake.wakeTime).toString().text.bold.color(AppColors.primary700).make(),
        Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
        '이때 깨워줄게요!'.text.bold.make(),
        height10,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     NormalButton(
        //       text: '거절하기',
        //       onPressed: () {
        //         ref.read(wakeControllerProvider.notifier).deleteWakeUp(wake.wakeUid);
        //       },
        //       isPreferred: false,
        //     ),
        //     width10,
        //     NormalButton(
        //       text: '승낙하기',
        //       onPressed: () {
        //         ref.read(wakeControllerProvider.notifier).acceptWakeUp(wake.wakeUid);
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class FeedBox extends StatelessWidget {
  final UserModel user;
  final WakeModel wake;
  const FeedBox(
    this.user,
    this.wake, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteBackground.withOpacity(0.1),
        border: Border.all(color: AppColors.point700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          NameBar(user),
          TimeBar(wake),
          height10,
          TextMessageBox(wake.message),
          height10,
          ImageBlurBox(wake.messagePhoto),
        ],
      ),
    );
  }
}

class EmptyAlarm extends StatelessWidget {
  const EmptyAlarm({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: () {
        if (user.couples!.isEmpty) {
          context.go('/main/match');
        } else {
          context.go('/main/wake');
          context.showSnackbar('깨우러 가기');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/aiphotos/awakebear.png",
            width: Constants.emptyPagePngWidth,
          ),
          height20,
          user.couples != null
              ? user.couples!.isEmpty
                  ? '상대와 연결해주세요'.text.size(18).bold.make()
                  : '상대가 아직 깨워주지 않았어요!'.text.size(18).bold.make()
              : '로그인 실패했습니다. 다시 시도해주세요.'.text.color(Colors.red).size(18).bold.make(),
          height40,
        ],
      ),
    );
  }
}
