import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_write_screen.dart';

class WakeTabScreen extends StatefulHookConsumerWidget {
  const WakeTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeTabScreenState();
}

class _WakeTabScreenState extends ConsumerState<WakeTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('편지쓰기'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            height10,
            const EditBox(),
            height10,
            Container(
              // height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.whiteBackground,
                border: Border.all(color: AppColors.point700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NameBar(),
                  const TimeBar(),
                  height10,
                  textMessageBox(
                      '오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ 오늘 놀자~ '),
                  imageBox('assets/images/samples/cherryblossom.png'),
                ],
              ),
            ),
            height40,
            height40,
            height40,
          ],
        ).pSymmetric(h: 20),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Nav.push(const WakeWriteScreen());
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget textMessageBox(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: text.text.make(),
    );
  }

  Widget imageBox(String s) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: Image.asset(
          s,
          fit: BoxFit.contain,
        ),
      ).pSymmetric(v: 20),
    );
  }
}

class EditBox extends StatelessWidget {
  const EditBox({
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
          const Text('오전 07:31'),
          Image.asset('assets/images/aiphotos/awakebear.png', width: Constants.cardPngWidth),
          '상대가 승락하면 깨울 수 있어요!'.text.bold.make(),
          height10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NormalButton(
                text: '취소하기',
                onPressed: () {},
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
  }
}

class TimeBar extends StatelessWidget {
  const TimeBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text('오전 07:31'),
        Icon(Icons.mic),
      ],
    );
  }
}

class NameBar extends StatelessWidget {
  const NameBar({
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
        '이영희'.text.bold.make(),
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
