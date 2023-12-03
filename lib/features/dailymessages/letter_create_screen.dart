import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';

import '../../core/common/loader.dart';
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

  File? letterImageFile;

  String imageUrl = "";

  bool isLoading = false;

  void selectLetterImage() async {
    final letterImagePicked = await pickImage();

    if (letterImagePicked != null) {
      setState(() {
        letterImageFile = File(letterImagePicked.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${ref.watch(selectedDate)}에 편지 쓰기')),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
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
                            return '편지를 써  주요';
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(labelText: ref.watch(selectedDate)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                              : const Icon(
                                  Icons.photo_album_outlined,
                                  size: 40,
                                  color: Colors.black,
                                )),
                      ElevatedButton(
                        child: const Text('저장'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            showSnackBar(context, "저장 중입니다.");
                            String uniqueImageName = DateTime.now().toString();
                            Reference refRoot =
                                ref.watch(storageProvider).ref();
                            Reference refDirImage = refRoot.child('images');
                            Reference refImageToUpload =
                                refDirImage.child(uniqueImageName);
                            try {
                              //Store the file
                              await refImageToUpload
                                  .putFile(File(letterImageFile!.path));
                              imageUrl =
                                  await refImageToUpload.getDownloadURL();
                              ref
                                  .watch(dailyControllerProvider.notifier)
                                  .createDailyMessageImage(
                                      _letterController.text, imageUrl);
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                                logger.e(e.toString());
                              });
                            }
                            if (mounted) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              showSnackBar(context, "Saved");
                            }
                          }
                          _letterController.clear();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
