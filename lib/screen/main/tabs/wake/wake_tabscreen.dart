import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/common/widget/w_image_button.dart';
import 'package:wakeuphoney/common/widget/w_menu_button.dart';

import '../../../../common/widget/w_round_button.dart';

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
      body: Column(
        children: [
          Container(
            // height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
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
          ),
          height10,
          Container(
            // height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.point700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                ),
                const Row(
                  children: [
                    Text('오전 07:31'),
                    Icon(Icons.mic),
                  ],
                ),
                height10,
                TextMessageBox('오늘 놀지~오늘 놀지~오늘 놀지~오늘 놀지~오늘 놀지~오늘 놀지~오늘 놀지~오늘 놀지~오늘 놀지~오늘 놀지~'),
              ],
            ),
          ),
        ],
      ).pSymmetric(h: 20),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget TextMessageBox(String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.point900),
        borderRadius: BorderRadius.circular(8),
      ),
      child: text.text.make(),
    );
  }
}
