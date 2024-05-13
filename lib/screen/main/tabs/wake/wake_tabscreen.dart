import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/oldauth/user_model.dart';
import 'package:wakeuphoney/screen/main/tabs/alarm/feedbox.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_model.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_write_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('편지쓰기'),
        actions: [
          IconButton(
            onPressed: () {
              context.push(WakeWriteScreen.routeUrl);
            },
            icon: const Icon(Icons.add),
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
                      if (wake[index].isApproved == false) ...[
                        WakeAcceptBox(ref, wake[index]),
                      ],
                      // height5,
                      FeedBox(user!, wake[index]),
                    ],
                  );
                }),
          ).pSymmetric(h: 20);
        },
        error: (error, stackTrace) => Text('Error: $error'), // Define the 'error' variable
        //나중에 글로벌 에러 핸들링으로 변경
        loading: () => const CircularProgressIndicator(), // Define the 'loading' variable
        // 나ㅇ에 글로벌 로딩 페이지으로 변경
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(WakeWriteScreen.routeUrl);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
          DateFormat('a hh:mm').format(wake.wakeTime).toString().text.bold.color(AppColors.primary700).make(),
          Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
          if (!wake.isApproved) '상대가 승락하면 깨울 수 있어요!'.text.bold.make(),
          height10,
          if (!wake.isApproved)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NormalButton(
                  text: '취소하기',
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
            width: context.deviceWidth - 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.point900),
            ),
            child: text.text.make(),
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
                  DateFormat('hh:mm a').format(wake[index]!.wakeTime).toString().text.bold.make(),
                  Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
                  '상대가 승락하면 깨울 수 있어요!'.text.bold.make(),
                  height10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NormalButton(
                        text: '취소하기',
                        onPressed: () {
                          ref.read(wakeControllerProvider.notifier).deleteWakeUp(wake[index]!.wakeUid);
                        },
                        isPreferred: false,
                      ),
                      width10,
                      NormalButton(
                        text: '수정하기',
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
          Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
          ' 깨울 수 있어요!'.text.bold.make(),
          height10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              width10,
              NormalButton(
                text: '깨우기',
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
        DateFormat('hh:mm').format(wake.wakeTime).text.bold.size(20).color(AppColors.primary700).make(),
        width5,
        if (wake.messageAudio.isNotEmpty)
          const CircleAvatar(
            backgroundColor: Colors.black,
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
          child: Image.asset('assets/images/alarmbearno.png', width: Constants.userIcon),
        ),
        width5,
        user.displayName.text.bold.make(),
        emptyExpanded,
        PopupMenuButton(
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
