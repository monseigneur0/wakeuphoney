import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:wakeuphoney/features/main/main_screen.dart';
import 'package:wakeuphoney/common/common.dart';

import '../../core/providers/providers.dart';
import 'wakeup_controller.dart';

class ResponseScreen extends ConsumerStatefulWidget {
  static String routeName = "response";
  static String routeURL = "/response";
  const ResponseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends ConsumerState<ResponseScreen> {
  final TextEditingController _messgaeController = TextEditingController();
  Logger logger = Logger();

  final _formKey = GlobalKey<FormState>();

  String imageUrl = "";

  File? bannerFile;

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

  @override
  Widget build(BuildContext context) {
    final getALetter = ref.watch(getALetterforResponseProvider);

    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMd().format(listDateTime[0]),
          style: const TextStyle(color: Colors.black),
        ),
        actions: const [],
        backgroundColor: AppColors.myAppBarBackgroundPink,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Container(
                //   height: 1,
                //   decoration: BoxDecoration(color: Colors.grey[700]),
                // ),
                getALetter.when(
                  data: (letter) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: letter.letterPhoto.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: letter.letterPhoto,
                                    placeholder: (context, url) => Container(
                                      height: 70,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : Container(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Text(
                                    letter.letter,
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    // logger.d("error");

                    return Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          'noletter'.tr(),
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    );
                  },
                  loading: () => const Loader(),
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    minLines: 5,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    autofocus: true,
                    controller: _messgaeController,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelText:
                            'message at ${DateFormat.yMMMd().format(listDateTime[0])}'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: bannerFile != null
                          ? SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.file(bannerFile!))
                          :
                          // ElevatedButton(
                          //     style: const ButtonStyle(
                          //       backgroundColor:
                          //           MaterialStatePropertyAll(Colors.black),
                          //     ),
                          //     child:
                          const Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              // color: Colors.black,
                            ),
                      onTap: () {
                        selectBannerImage();
                      },
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(AppColors.myPink)),
                      child: const Text('보내기',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          showToast("messgae is saved");
                          final String message = _messgaeController.text;

                          String uniqueFileName =
                              DateTime.now().toString().replaceAll(' ', '');

                          //Get a reference to storage root
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImages =
                              referenceRoot.child('responseimages');

                          //Create a reference for the image to be stored
                          Reference referenceImageToUpload =
                              referenceDirImages.child(uniqueFileName);

                          //Handle errors/success
                          if (bannerFile != null) {
                            try {
                              //Store the file
                              await referenceImageToUpload
                                  .putFile(File(bannerFile!.path));
                              //Success: get the download URL
                              imageUrl =
                                  await referenceImageToUpload.getDownloadURL();
                            } catch (error) {
                              //Some error occurred
                              logger.e(error.toString());
                            }
                          }
                          //메세지 작성
                          ref.watch(getALetterforResponseProvider).whenData(
                              (value) => ref
                                  .watch(wakeUpControllerProvider.notifier)
                                  .createResponseLetter(
                                      value.wakeUpUid, message, imageUrl));
                        }
                        _messgaeController.clear();
                        if (context.mounted) {
                          context.go(MainScreen.routeURL);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}