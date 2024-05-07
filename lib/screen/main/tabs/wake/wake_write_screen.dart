import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/util/app_keyboard_util.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/common/widget/w_text_field_with_delete.dart';
import 'package:wakeuphoney/features/oldvoice/audio_player_example.dart';
import 'package:wakeuphoney/features/oldvoice/audio_recoder_example.dart';
import 'package:wakeuphoney/features/oldwakeup/wakeup_write_screen.dart';

class WakeWriteScreen extends ConsumerStatefulWidget {
  static const routeName = 'wakewrite';
  static const routeUrl = '/wakewrite';
  const WakeWriteScreen({super.key});

  @override
  ConsumerState<WakeWriteScreen> createState() => _WakeWriteScreenState();
}

class _WakeWriteScreenState extends ConsumerState<WakeWriteScreen> {
  Logger logger = Logger();

  //알람 설정 변수
  //시간
  late TimeOfDay selectedTime;

  //음량
  late double volume = 0.8;

  //반복 스누즈아님
  late bool loopAudio = false;

  //진동
  late bool vibrate = false;

  //기본음악
  late String assetAudio = 'marimba.mp3';

  //audio
  bool showAudio = false;
  bool showPlayer = false;
  String? audioPath;

  //camera
  File? letterImageFile;

  final TextEditingController _letterController = TextEditingController();

  void takePhotoAndGetImage() async {
    final letterCameraPicked = await takeCameraImage();
    if (letterCameraPicked != null) {
      setState(() {
        letterImageFile = File(letterCameraPicked.path);
      });
    }
  }

  void selecAlbumImage() async {
    final letterImagePicked = await selectGalleryImage();
    if (letterImagePicked != null) {
      setState(() {
        letterImageFile = File(letterImagePicked.path);
      });
    }
  }

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
      body: Tap(
        onTap: () => AppKeyboardUtil.hide(context),
        child: SingleChildScrollView(
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
                    color: AppColors.whiteBackground,
                    border: Border.all(color: AppColors.grey400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.volume_mute),
                      Expanded(
                        child: Slider(
                          value: volume,
                          onChanged: (value) {
                            setState(() => volume = value);
                          },
                        ),
                      ),
                      const Icon(Icons.volume_up),
                    ],
                  ).pSymmetric(h: 20, v: 1)),
              height10,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteBackground,
                  border: Border.all(color: AppColors.grey400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        '알람 반복'.text.size(14).make(),
                        Switch(
                          inactiveThumbColor: AppColors.whiteBackground,
                          trackOutlineColor: MaterialStateColor.resolveWith((states) {
                            switch (states.contains(MaterialState.selected)) {
                              case true:
                                return AppColors.primary600;
                              case false:
                                return AppColors.grey200;
                            }
                          }),
                          value: loopAudio,
                          onChanged: (value) => setState(() => loopAudio = value),
                        ),
                      ],
                    ),
                    const Divider(height: 1, color: AppColors.grey200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        '진동'.text.size(14).make(),
                        Switch(
                          inactiveThumbColor: AppColors.whiteBackground,
                          trackOutlineColor: MaterialStateColor.resolveWith((states) {
                            switch (states.contains(MaterialState.selected)) {
                              case true:
                                return AppColors.primary600;
                              case false:
                                return AppColors.grey200;
                            }
                          }),
                          value: vibrate,
                          onChanged: (value) => setState(() => vibrate = value),
                        ),
                      ],
                    ),
                    const Divider(height: 1, color: AppColors.grey200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        '알람 기본 음악'.text.size(14).make(),
                        DropdownButton(
                          value: assetAudio,
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'marimba.mp3',
                              child: Text('Marimba'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'nature.mp3',
                              child: Text('Nature'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'childhood.mp3',
                              child: Text('Childhood'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'happylife.mp3',
                              child: Text('Happy Life'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'mozart.mp3',
                              child: Text('Mozart'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'nokia.mp3',
                              child: Text('Nokia'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'one_piece.mp3',
                              child: Text('One Piece'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'star_wars.mp3',
                              child: Text('Star Wars'),
                            ),
                          ],
                          onChanged: (value) => setState(() => assetAudio = value!),
                        ),
                      ],
                    ),
                  ],
                ).pSymmetric(h: 20, v: 1),
              ),
              height10,
              '내용'.text.size(14).make(),
              height5,
              Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteBackground,
                    border: Border.all(color: AppColors.grey400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Container(
                      //   child: '오늘 벚꽃놀이 가기로 한 거 잊지 않았지? 늦잠 자면 진짜 안돼~ 부지런히 일어나~~!!!!!!!!!!!~~~!~!~!~!~!~!~!~!~!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~'
                      //       .text
                      //       .size(14)
                      //       .make(),
                      // ),
                      TextFieldWithDelete(
                        isBorder: false,
                        controller: _letterController,
                        onChanged: (p0) {
                          if (_letterController.text.length > 300) {
                            _letterController.text = _letterController.text.substring(0, 300);
                          }
                          setState(() {});
                        },
                      ),
                      height30,
                      '${_letterController.text.length}/300자'.text.color(AppColors.grey500).make(),
                    ],
                  ).pSymmetric(h: 20, v: 10)),
              height10,
              Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteBackground,
                    border: Border.all(color: AppColors.grey400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: showPlayer
                      ? Row(
                          children: [
                            '음성 재생'.text.color(AppColors.grey500).size(16).bold.make(),
                            Expanded(
                              child: Container(),
                            ),
                            Center(
                              child: AudioPlayer(
                                source: audioPath!,
                                onDelete: () {
                                  setState(() => showPlayer = false);
                                },
                              ),
                            )
                          ],
                        ).pOnly(left: 20, top: 10, bottom: 10)
                      : Row(
                          children: [
                            '음성 녹음'.text.color(AppColors.grey500).size(16).bold.make(),
                            Expanded(
                              child: Container(),
                            ),
                            Recorder(
                              onStop: (path) {
                                logger.d('Recorded file path: $path');
                                setState(() {
                                  audioPath = path;
                                  showPlayer = true;
                                });
                              },
                            ),
                          ],
                        ).pOnly(left: 20, top: 10, bottom: 10)),

              height10,
              Tap(
                onTap: () {
                  takePhotoAndGetImage();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteBackground,
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
              ),
              height10,
              Tap(
                onTap: () {
                  selecAlbumImage();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteBackground,
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
              ),
              height10,
              // Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //     color: AppColors.whiteBackground,
              //     border: Border.all(color: AppColors.grey400),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Row(
              //     children: [
              //       Text(
              //         "답장을 해야 알람이 다시 울리지 않습니다.",
              //         style: Theme.of(context).textTheme.titleMedium,
              //       ),
              //       Expanded(
              //         child: Container(),
              //       ),
              //       const Icon(Icons.warning_amber)
              //     ],
              //   ).pSymmetric(h: 20, v: 10),
              // ),

              const MainButton('깨우기'),
              height40,
            ],
          ).pSymmetric(h: 20),
        ),
      ),
    );
  }
}
