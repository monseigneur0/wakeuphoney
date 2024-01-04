import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/letter/letter_controller.dart';

import '../../core/common/loader.dart';
import '../../core/constants/design_constants.dart';
import '../../core/providers/providers.dart';
import '../../core/utils.dart';

class LetterCreateScreen extends ConsumerStatefulWidget {
  static String routeName = 'letter_create_screen';
  static String routeURL = '/letter_create_screen';
  const LetterCreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterCreateScreenState();
}

class _LetterCreateScreenState extends ConsumerState<LetterCreateScreen> {
  Logger logger = Logger();

  final TextEditingController _letterController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String imageUrl = "";

  bool isLoading = false;

  File? letterImageFile;
  void selectLetterImage() async {
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
          title: Text(
              '${DateFormat("yyyy년 MM월 dd일 ").format(ref.watch(selectedDateTime))} 편지')),
      body: isLoading
          ? const Loader()
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          minLines: 3,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          controller: _letterController,
                          validator: (value) {
                            if (value == null || value.isEmpty || value == "") {
                              return '편지를 써 줘요';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: "어떤 하루를 보냈으면 좋겠어요?"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 20),
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(AppColors.myPink)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                showSnackBar(context, "저장 중입니다.");
                                String uniqueImageName =
                                    DateTime.now().toString();
                                Reference refRoot =
                                    ref.watch(storageProvider).ref();
                                Reference refDirImage = refRoot.child('images');
                                Reference refImageToUpload =
                                    refDirImage.child(uniqueImageName);
                                if (letterImageFile != null) {
                                  try {
                                    await refImageToUpload
                                        .putFile(File(letterImageFile!.path));
                                    imageUrl =
                                        await refImageToUpload.getDownloadURL();
                                  } catch (e) {
                                    logger.e(
                                        "Error uploading image or no image file selected");
                                    logger.e(e.toString());

                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                                //메세지 작성 위치 조심
                                // ref
                                //     .watch(dailyControllerProvider.notifier)
                                //     .createDailyMessageImage(
                                //         _letterController.text, imageUrl);
                                ref
                                    .watch(letterControllerProvider.notifier)
                                    .createLetter(
                                        _letterController.text, imageUrl);
                                if (mounted) {
                                  Navigator.of(context).pop();
                                  showSnackBar(context, "Saved");
                                }
                              }
                              _letterController.clear();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 13),
                              child: Text(
                                '보내기',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                              onTap: () {
                                selectLetterImage();
                              },
                              child: letterImageFile != null
                                  ? SizedBox(
                                      height: 300,
                                      width: 250,
                                      child: Image.file(letterImageFile!),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30)),
                                        color: Colors.grey[300],
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.photo_album_outlined,
                                              size: 40,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "사진 첨부하기",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}