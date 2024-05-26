import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/firebase_providers.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/common/widget/normal_button.dart';
import 'package:wakeuphoney/common/widget/w_long_button.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/common/widget/w_main_button_disabled.dart';
import 'package:wakeuphoney/common/widget/w_menu_button.dart';
import 'package:wakeuphoney/common/widget/w_round_button.dart';
import 'package:wakeuphoney/common/widget/w_text_field_with_delete.dart';
import 'package:wakeuphoney/tabs/wake/wake_controller.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';

class AlarmReplyScreen extends ConsumerStatefulWidget {
  static const routeName = 'alarmreply';
  static const routeUrl = '/alarmreply';
  const AlarmReplyScreen({super.key});

  @override
  ConsumerState<AlarmReplyScreen> createState() => _AlarmReplyScreenState();
}

class _AlarmReplyScreenState extends ConsumerState<AlarmReplyScreen> {
  Logger logger = Logger();
  final _letterController = TextEditingController();
  final textEditingFucus = FocusNode();

  String imageUrl = "";

  File? bannerFile;
  File? letterImageFile;
  bool isLoading = false;

  void selectBannerImage() async {
    ImagePicker imagePicker = ImagePicker();
    final res = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 15,
    );

    if (res != null) {
      setState(() {
        bannerFile = File(res.path);
      });
    }
  }

  void takePhotoAndGetImage() async {
    final letterCameraPicked = await takeCameraImage();
    if (letterCameraPicked != null) {
      setState(() {
        letterImageFile = File(letterCameraPicked.path);
        isLoading = true;
      });
      uploadImageToStorage();
    }
  }

  void uploadImageToStorage() async {
    Reference refImageToUpload = ref.read(storageProvider).ref().child(FirebaseConstants.alarmImage).child(DateTime.now().toString());
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: '답장하기'.text.make(),
      ),
      body: SafeArea(
        child: Tap(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height40,
                height40,
                Image.asset('assets/images/wakeupbear/wakeupbearsleep.png', width: Constants.cardPngWidth),
                height10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    '답장하기'.text.semiBold.make(),
                  ],
                ),
                height10,
                Tap(
                  onTap: () => FocusScope.of(context).requestFocus(textEditingFucus),
                  child: Container(
                      decoration: containerBoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFieldWithDelete(
                            isBorder: false,
                            controller: _letterController,
                            focusNode: textEditingFucus,
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
                      ).pSymmetric(h: 10, v: 10)),
                ),
                height10,
                letterImageFile == null
                    ? Tap(
                        onTap: () {
                          takePhotoAndGetImage();
                          showToast('사진을 찍어주세요.');
                        },
                        child: Container(
                          decoration: containerBoxDecoration(),
                          child: Row(
                            children: [
                              '카메라'.text.color(AppColors.grey500).lg.medium.make(),
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
                                '카메라'.text.color(AppColors.grey500).lg.medium.make(),
                                const EmptyExpanded(),
                                Tap(
                                    onTap: () => setState(() {
                                          letterImageFile = null;
                                          showToast('사진을 삭제했습니다.');
                                          // delete at server
                                        }),
                                    child: isLoading ? const Loader() : const Icon(Icons.cancel)),
                              ],
                            ).pSymmetric(h: 20, v: 10),
                            Image.file(letterImageFile!)
                          ],
                        ),
                      ),
                height20,
                _letterController.text.isEmpty
                    ? isLoading
                        ? MainButton('업로드 중', onPressed: () {})
                        : MainButtonDisabled('답장하기', onPressed: () {
                            context.showSnackbar('답장 내용을 입력해주세요');
                          })
                    : MainButton(
                        '답장하기',
                        onPressed: () {
                          //답장 로직 지금 내가 답장을 하고 있다는 것을 어떻게 알지 전 게시물을 보고 있을 때 알람에서 넘겨줘야겠다
                          //보내는 사람,
                          final now = DateTime.now();
                          final wakeModel = WakeModel.empty();
                          final wake = ref.read(wakeIdProvider);
                          // wakeModel
                          //   ..senderUid = user?.uid
                          //   ..senderName = user?.displayName
                          //   ..senderPhotoUrl = user?.photoURL
                          //   ..receiverUid = wake
                          //   ..receiverName = wake
                          //   ..receiverPhotoUrl = wake
                          //   ..wakeTime = now
                          //   ..wakeMessage = controller.text;
                          final image = ref.read(imageUrlProvider);
                          final voice = ref.read(voiceUrlProvider);
                          final video = ref.read(videoUrlProvider);
                          ref.read(wakeControllerProvider.notifier).reply(wake, _letterController.text, image, voice, video);
                          Navigator.of(context).pop();
                        },
                      ),

                // NormalButton(text: 'NormalButton', onPressed: () {}),
                // RoundButton(text: 'RoundButton', onTap: () {}),
                // LongButton(title: 'LongButton', onTap: () {}),
                // MainButton('MainButton', onPressed: () {}),
                // MenuButton????('text', onTap: () {}),
              ],
            ).pSymmetric(h: 20),
          ),
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
