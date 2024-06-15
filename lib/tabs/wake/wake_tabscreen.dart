import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth/user_model.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/tabs/alarm/feedbox.dart';
import 'package:wakeuphoney/tabs/match/match_tabscreen.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';
import 'package:wakeuphoney/tabs/wake/wake_write_screen.dart';

import 'wake_controller.dart';

class WakeTabScreen extends StatefulHookConsumerWidget {
  static const routeName = 'wake';
  static const routeUrl = '/wake';
  const WakeTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeTabScreenState();
}

class _WakeTabScreenState extends ConsumerState<WakeTabScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);
    final myWake = ref.watch(wakeListStreamProvider);
    final friend = ref.watch(friendUserModelProvider);
    if (user == null) {
      return const CircularProgressIndicator();
    }
    if (friend == null) {
      return const NoFriendBox();
    }
    Logger logger = Logger();
    return Material(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: 'Try setting an alarm.'.tr().text.lg.make(),
              actions: [
                Transform.translate(
                  offset: const Offset(-5, 0),
                  child: IconButton(
                    onPressed: () {
                      context.push(WakeWriteScreen.routeUrl);
                    },
                    // icon: Image.asset(
                    //   'assets/images/alarm-clock.png',
                    //   width: 30,
                    //   color: AppColors.primary600,
                    icon: const Icon(
                      Icons.add,
                      size: 30,
                      color: AppColors.primary600,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
                child: myWake.when(
              data: (wake) {
                if (wake.isEmpty) {
                  return const Center(
                    child: EmptyBox(),
                  );
                }
                return SizedBox(
                  height: context.deviceHeight * 0.8,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => height10,
                      itemCount: wake.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            if (wake[index].isApproved == false && wake[index].wakeTime.isAfter(DateTime.now())) WakeAcceptBox(ref, wake[index]),
                            // height5,
                            FeedBox(user, wake[index]),
                          ],
                        );
                      }),
                ).pSymmetric(h: 20);
              },
              error: (error, stackTrace) {
                logger.d('Error: $error Stack Trace: $stackTrace');

                return Text('Error: $error');
              }, // Define the 'error' variable
              //나중에 글로벌 에러 핸들링으로 변경
              loading: () => const CircularProgressIndicator(), // Define the 'loading' variable
              // 나ㅇ에 글로벌 로딩 페이지으로 변경
            )),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     context.push(WakeWriteScreen.routeUrl);
            //   },
            //   child: const Icon(Icons.add),
            // ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
          const FloatingAlarmButton(),
        ],
      ),
    );
  }
}

class FloatingAlarmButton extends ConsumerWidget {
  const FloatingAlarmButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: FloatingActionButton(
            onPressed: () {
              context.push(WakeWriteScreen.routeUrl);
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}

class WakeAcceptBox extends StatelessWidget {
  final WidgetRef ref;
  final WakeModel wake;
  const WakeAcceptBox(this.ref, this.wake, {super.key});

  @override
  Widget build(BuildContext context) {
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
          DateFormat('a hh:mm').format(wake.wakeTime).toString().text.medium.color(AppColors.primary700).make(),
          Image.asset('assets/images/wakeupbear/wakeupbearsleep.png', width: Constants.cardPngWidth),
          if (!wake.isApproved) 'You can wake them up if they accept!'.tr().text.medium.make(),
          height10,
          if (!wake.isApproved)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NormalButton(
                  text: 'cancel'.tr(),
                  onPressed: () {
                    ref.read(wakeControllerProvider.notifier).deleteWakeUp(wake.wakeUid);
                  },
                  isPreferred: false,
                ),
                // width10,
                // NormalButton(
                //   text: '수정하기',
                //   onPressed: () {},
                // ),
              ],
            ),
        ],
      ),
    );
  }
}

class TextMessageBox extends StatelessWidget {
  final String text;
  const TextMessageBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return text.isEmpty
        ? Container()
        : Container(
            padding: const EdgeInsets.all(15),
            width: context.deviceWidth - 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.point900),
            ),
            child: text.selectableText.normal.make(),
          );
  }
}

class ImageBox extends StatelessWidget {
  final String s;
  const ImageBox(this.s, {super.key});

  @override
  Widget build(BuildContext context) {
    return s.isEmpty
        ? Container()
        : Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                s,
                fit: BoxFit.contain,
              ),
            ),
          );
  }
}

class ImageBlurBox extends StatelessWidget {
  final String s;
  const ImageBlurBox(this.s, {super.key});

  @override
  Widget build(BuildContext context) {
    return s.isEmpty
        ? Container()
        : Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  s,
                  fit: BoxFit.cover,
                  width: context.deviceWidth - 80,
                  height: context.deviceWidth - 80,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: SizedBox(
                    width: context.deviceWidth - 80,
                    height: context.deviceWidth - 80,
                  ),
                ),
              ),
            ],
          );
  }
}

class TextMessageBlurBox extends StatelessWidget {
  final String text;
  const TextMessageBlurBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return text.isEmpty
        ? Container()
        : Container(
            padding: const EdgeInsets.all(15),
            width: context.deviceWidth - 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.point900),
            ),
            child: (text.length < 10)
                ? Stack(
                    children: [
                      Text(text),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: const SizedBox(
                            width: 150,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Text(
                        '${text.substring(0, 10)}...',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: const SizedBox(
                            width: 150,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
  }
}

class EditBox extends StatelessWidget {
  final List<WakeModel?> wake;
  final WidgetRef ref;
  const EditBox(
    this.wake,
    this.ref, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (wake.isEmpty) {
      return const EmptyBox();
    }
    return SizedBox(
      height: context.deviceHeight * 0.8,
      child: ListView.separated(
          separatorBuilder: (context, index) => height10,
          itemCount: wake.length,
          itemBuilder: (context, index) {
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
                  const Text('오전 07:31'),
                  DateFormat('hh:mm a').format(wake[index]!.wakeTime).toString().text.medium.make(),
                  Image.asset('assets/images/wakeupbear/wakeupbearsleep.png', width: Constants.cardPngWidth),
                  'You can wake them up if they accept!'.tr().text.medium.make(),
                  height10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NormalButton(
                        text: 'cancel'.tr(),
                        onPressed: () {
                          ref.read(wakeControllerProvider.notifier).deleteWakeUp(wake[index]!.wakeUid);
                        },
                        isPreferred: false,
                      ),
                      width10,
                      NormalButton(
                        text: 'edit'.tr(),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class NoFriendBox extends StatelessWidget {
  const NoFriendBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // height: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.whiteBackground,
            border: Border.all(color: AppColors.point700),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/wakeupbear/wakeupbearsleep.png', width: context.deviceWidth / 2),
              'Please register your friend.'.tr().text.medium.make(),
              height10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  width10,
                  NormalButton(
                    text: 'Register'.tr(),
                    onPressed: () {
                      context.push(MatchTabScreen.routeUrl);
                    },
                  ),
                ],
              ),
              height40,
              height40,
              height40,
              height40,
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyBox extends StatelessWidget {
  const EmptyBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteBackground,
        border: Border.all(color: AppColors.point700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          height40,
          Image.asset('assets/images/wakeupbear/wakeupbearsleep.png', width: context.deviceWidth / 2),
          'You can wake them up!'.text.medium.make(),
          height10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              width10,
              NormalButton(
                text: 'Wake Up',
                onPressed: () {
                  context.push(WakeWriteScreen.routeUrl);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeBar extends StatelessWidget {
  final WakeModel wake;
  const TimeBar(
    this.wake, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DateFormat('a').format(wake.wakeTime).text.color(AppColors.primary700).make(),
        width5,
        DateFormat('hh:mm').format(wake.wakeTime).text.medium.size(20).color(AppColors.primary700).make(),
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

class NameBar extends StatelessWidget {
  final UserModel user;
  const NameBar(
    this.user, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            width: Constants.userIcon,
            imageUrl: user.photoURL,
            fit: BoxFit.fill,
            placeholder: (context, url) => Container(
              height: 40,
            ),
          ),
          // Image.asset('assets/images/alarmbearno.png', width: Constants.userIcon),
        ),
        width5,
        user.displayName.text.medium.make(),
        emptyExpanded,
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  showToast('nodeletepast'.tr());
                },
                child: Text('delete'.tr()),
              ),
            ];
          },
        ).box.height(32).make(),
      ],
    );
  }
}