import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/features/oldwakeup/wakeup_write_screen.dart';

class WakeWriteScreen extends StatefulWidget {
  static const routeName = 'wakewrite';
  static const routeUrl = '/wakewrite';
  const WakeWriteScreen({super.key});

  @override
  State<WakeWriteScreen> createState() => _WakeWriteScreenState();
}

class _WakeWriteScreenState extends State<WakeWriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('깨워볼까요?'),
        backgroundColor: AppColors.myBackground,
        actions: [
          IconButton(
            onPressed: () {
              //save
              //navigate to wakeup write screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WakeUpWriteScreen()),
              );
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // chooseTime,

            SizedBox(
              height: context.deviceHeight / 7,
              width: context.deviceWidth,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  // Do something with the selected time
                },
              ),
            ),
            '음량'.text.size(14).make(),
            height5,
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    '음량'.text.color(AppColors.grey500).size(16).bold.make(),
                    const Icon(Icons.volume_up),
                  ],
                ).pSymmetric(h: 20, v: 10)),
            height10,
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      '알람 반복'.text.size(14).make(),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      '진동'.text.size(14).make(),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      '알람 기본 음악'.text.size(14).make(),
                    ],
                  ),
                ],
              ).pSymmetric(h: 20, v: 10),
            ),
            height10,
            '내용'.text.size(14).make(),
            height5,
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: '오늘 벚꽃놀이 가기로 한 거 잊지 않았지? 늦잠 자면 진짜 안돼~ 부지런히 일어나~~!!!!!!!!!!!~~~!~!~!~!~!~!~!~!~!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~'
                          .text
                          .size(14)
                          .make(),
                    ),
                    height30,
                    '30/50자'.text.color(AppColors.grey500).make(),
                  ],
                ).pSymmetric(h: 20, v: 10)),
            height10,
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  '알람 녹음'.text.color(AppColors.grey500).size(16).bold.make(),
                  const Icon(Icons.mic),
                ],
              ).pSymmetric(h: 20),
            ),
            height10,
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  '카메라'.text.color(AppColors.grey500).size(16).bold.make(),
                  const Icon(Icons.camera_alt),
                ],
              ).pSymmetric(h: 20),
            ),
            height10,
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  '앨범'.text.color(AppColors.grey500).size(16).bold.make(),
                  const Icon(Icons.camera_alt),
                ],
              ).pSymmetric(h: 20),
            ),

            const MainButton('깨우기')
          ],
        ).pSymmetric(h: 20),
      ),
    );
  }
}
