import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';

import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_accept_box.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_accepted_box.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_empty.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_manager.dart';
import 'package:wakeuphoney/tabs/alarm/feed_blur_box.dart';
import 'package:wakeuphoney/tabs/alarm/feedbox.dart';
import 'package:wakeuphoney/tabs/wake/wake_controller.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';
import 'package:wakeuphoney/tabs/wake/wake_tabscreen.dart';

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
      return Center(
        child: Image.asset('assets/images/wakeupbear/wakeupbear.png'),
      );
    }
    if (friend == null) {
      return const Center(
        child: NoFriendBox(),
      );
    }
    final myAlarm = ref.watch(alarmListStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: '예약된 알람을 확인하세요'.text.lg.make(),
      ),
      body: SingleChildScrollView(
        child: myAlarm.when(
          data: (alarm) {
            if (alarm.isEmpty) {
              return const Center(
                child: EmptyBox(),
              );
            }
            return Center(
              // if (!kDebugMode) const AlarmManager(),
              child: AlarmList(ref, alarm: alarm, user: friend ?? user),
            );
          },
          error: (error, stackTrace) => StreamError(error, stackTrace),
          //나중에 글로벌 에러 핸들링으로 변경
          loading: () => const CircularProgressIndicator(), // Define the 'loading' variable
          // 나ㅇ에 글로벌 로딩 페이지으로 변경
        ),
      ),
    );
  }
}

class AlarmList extends StatefulWidget {
  final List<WakeModel> alarm;
  final UserModel user;
  final WidgetRef ref;
  const AlarmList(this.ref, {required this.alarm, required this.user, super.key});

  @override
  State<AlarmList> createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> {
  final String iOSIdAlarm = 'ca-app-pub-5897230132206634/3120978311';
  final String androidIdAlarm = 'ca-app-pub-5897230132206634/5879003590';
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();

    BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOSIdAlarm : androidIdAlarm,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // logger.d('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (!kDebugMode) ? context.deviceHeight - 190 : context.deviceHeight - 100,
      child: ListView.builder(
        itemCount: widget.alarm.length,
        itemBuilder: (context, index) {
          final wake = widget.alarm[index];
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
                wake.wakeTime.isBefore(DateTime.now())
                    ? Container()
                    : wake.isApproved
                        ? AcceptedBox(widget.user, wake)
                        : AcceptBox(widget.user, wake),
                height10,
                //feed box 는 오직 알람이 이미 울렸고 승인된 경우
                //blur box 는 알람이 울릴 예정이고 승인되지 않은 경우 울렸더라도 승인되지 않는경우
                (wake.wakeTime.isBefore(DateTime.now()) && wake.isApproved)
                    ? FeedBox(widget.user, wake)
                    : FeedBlurBox(widget.user, wake),
                if (index == 0)
                  if (_bannerAd != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height > 800 ? 120 : 80,
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
