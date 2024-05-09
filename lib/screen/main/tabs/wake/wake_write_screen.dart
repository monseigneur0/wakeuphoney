import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/util/app_keyboard_util.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/common/widget/w_text_field_with_delete.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/oldwakeup/wakeup_write_screen.dart';
import 'package:wakeuphoney/screen/main/main_tabscreen.dart';
import 'package:wakeuphoney/screen/main/tabs/wake/wake_controller.dart';

import 'audio/audio_player.dart';
import 'audio/audio_recoder.dart';

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
  late TimeOfDay selectedTime = TimeOfDay.now();

  //음량
  late double volume = 0.8;

  //소리반복 스누즈아님
  late bool loopAudio = true;

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
  bool useAlbum = false;
  bool useCamera = false;

  bool isLoading = false;

  final TextEditingController _letterController = TextEditingController();

  final ExpansionTileController _expansionTileController = ExpansionTileController();

  void takePhotoAndGetImage() async {
    final letterCameraPicked = await takeCameraImage();
    if (letterCameraPicked != null) {
      setState(() {
        useCamera = true;
        letterImageFile = File(letterCameraPicked.path);
        isLoading = true;
      });
      uploadImageToStorage();
    }
  }

  void selecAlbumImage() async {
    final letterImagePicked = await selectGalleryImage();
    if (letterImagePicked != null) {
      setState(() {
        useAlbum = true;
        letterImageFile = File(letterImagePicked.path);
        isLoading = true;
      });
      uploadImageToStorage();
    }
  }

  void uploadImageToStorage() async {
    Reference refImageToUpload =
        ref.read(storageProvider).ref().child(FirebaseConstants.alarmImage).child(DateTime.now().toString());
    if (letterImageFile != null) {
      try {
        await refImageToUpload.putFile(File(letterImageFile!.path));
        ref.read(imageUrlProvider.notifier).state = await refImageToUpload.getDownloadURL();
        logger.d(ref.read(imageUrlProvider));
      } catch (e) {
        logger.e("Error uploading image or no image file selected");
        logger.e(e.toString());
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void uploadVoiceToStorage() async {
    Reference refVoiceToUpload =
        ref.read(storageProvider).ref().child(FirebaseConstants.alarmVoice).child(DateTime.now().toString());
    if (audioPath != null) {
      try {
        await refVoiceToUpload.putFile(File(audioPath!));
        ref.read(voiceUrlProvider.notifier).state = await refVoiceToUpload.getDownloadURL();
        logger.d(ref.read(voiceUrlProvider));
      } catch (e) {
        logger.e("Error uploading image or no image file selected");
        logger.e(e.toString());
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _letterController.dispose();
    super.dispose();
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
              kDebugMode
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WakeUpWriteScreen()),
                    )
                  : null;
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
              height10,
              '내용'.text.make(),
              height5,
              Container(
                  decoration: containerBoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
              Tap(
                onTap: () => context.showSnackbar('목소리로 깨워보세요!\n알람음 대신 녹음한 목소리로 깨워드립니다.'),
                child: Container(
                    decoration: containerBoxDecoration(),
                    child: showPlayer
                        ? Row(
                            children: [
                              '음성 재생'.text.color(AppColors.grey500).size(16).bold.make(),
                              const EmptyExpanded(),
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
                              const EmptyExpanded(),
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
              ),

              height10,
              useAlbum == false
                  ? letterImageFile == null
                      ? Tap(
                          onTap: () {
                            takePhotoAndGetImage();
                            showToast('사진을 찍어주세요.');
                          },
                          child: Container(
                            decoration: containerBoxDecoration(),
                            child: Row(
                              children: [
                                '카메라'.text.color(AppColors.grey500).size(16).bold.make(),
                                const EmptyExpanded(),
                                const Icon(Icons.camera_alt),
                              ],
                            ).pSymmetric(h: 20, v: 10),
                          ),
                        )
                      : Container(
                          decoration: containerBoxDecoration(),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  '카메라'.text.color(AppColors.grey500).size(16).bold.make(),
                                  const EmptyExpanded(),
                                  Tap(
                                      onTap: () => setState(() {
                                            useAlbum = false;
                                            letterImageFile = null;
                                            showToast('사진을 삭제했습니다.');
                                          }),
                                      child: isLoading ? const Loader() : const Icon(Icons.cancel)),
                                ],
                              ).pSymmetric(h: 20, v: 10),
                              Image.file(letterImageFile!)
                            ],
                          ),
                        )
                  : Container(),
              height10,
              useCamera == false
                  ? letterImageFile == null
                      ? Tap(
                          onTap: () {
                            selecAlbumImage();
                            showToast('사진을 선택해주세요.');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteBackground,
                              border: Border.all(color: AppColors.grey400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                '앨범'.text.color(AppColors.grey500).size(16).bold.make(),
                                const EmptyExpanded(),
                                const Icon(Icons.photo_library),
                              ],
                            ).pSymmetric(h: 20, v: 10),
                          ),
                        )
                      : Container(
                          decoration: containerBoxDecoration(),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  '앨범'.text.color(AppColors.grey500).size(16).bold.make(),
                                  const EmptyExpanded(),
                                  Tap(
                                      onTap: () => setState(() {
                                            useAlbum = false;
                                            letterImageFile = null;
                                            showToast('사진을 삭제했습니다.');
                                          }),
                                      child: isLoading ? const Loader() : const Icon(Icons.cancel)),
                                ],
                              ).pSymmetric(h: 20, v: 10),
                              Image.file(letterImageFile!)
                            ],
                          ),
                        )
                  : Container(),
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              height20,
              Container(
                  decoration: containerBoxDecoration(),
                  child: ExpansionTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: '알람 상세 설정'.text.color(AppColors.grey500).size(16).bold.make(),
                      backgroundColor: AppColors.whiteBackground,
                      controller: _expansionTileController,
                      onExpansionChanged: (value) {},
                      children: [
                        const Divider(height: 1, color: AppColors.grey200),
                        Column(
                          children: [
                            Row(
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
                            ).pSymmetric(v: 1),
                            const Divider(height: 1, color: AppColors.grey200),
                            Row(
                              children: [
                                '알람 반복'.text.make(),
                                const EmptyExpanded(),
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
                              children: [
                                '진동'.text.make(),
                                const EmptyExpanded(),
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
                                '알람 기본 음악'.text.make(),
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
                      ])),
              height20,

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

              MainButton(
                '깨우기',
                onPressed: () {
                  if (context.mounted) {
                    context.go('/main/wake');
                    //text, voice, photo, alarm 전달
                    ref
                        .read(wakeControllerProvider.notifier)
                        .createWakeUp(_letterController.text, selectedTime, volume, vibrate, assetAudio);
                    _letterController.clear();
                  }
                },
              ),
              if (kDebugMode)
                MainButton(
                  '깨우기',
                  onPressed: () {
                    if (context.mounted) {
                      // context.go('/main/wake');
                      showToast('saved'.tr());
                      // logger.d('go to /main/wake');
                      //text, voice, photo, alarm 전달
                      logger.d('friendid${ref.read(userModelProvider)!.couples!.first}');
                      // _letterController.clear();
                    }
                  },
                ),
              height40,
            ],
          ).pSymmetric(h: 20),
        ),
      ),
    );
  }

  BoxDecoration containerBoxDecoration() {
    return BoxDecoration(
      color: AppColors.whiteBackground,
      border: Border.all(color: AppColors.grey400),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
