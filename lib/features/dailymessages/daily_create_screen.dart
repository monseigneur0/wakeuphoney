import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/utils.dart';
import 'daily_controller.dart';

class DailyLetterCreateScreen extends ConsumerStatefulWidget {
  static String routeName = "dailylettercreate";
  static String routeURL = "/dailylettercreate";
  const DailyLetterCreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DailyLetterCreateScreenState();
}

class _DailyLetterCreateScreenState
    extends ConsumerState<DailyLetterCreateScreen> {
  final TextEditingController _messgaeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String imageUrl = "";

  File? bannerFile;
  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
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
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  labelText: 'message at ${ref.read(selectedDate)}',
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    selectBannerImage();
                    // if (bannerFile != null) {
                    //   Image.file(bannerFile!);
                    // }
                  },

                  child: bannerFile != null
                      ? SizedBox(
                          height: 30, width: 30, child: Image.file(bannerFile!))
                      :
                      // ElevatedButton(
                      //     style: const ButtonStyle(
                      //       backgroundColor:
                      //           MaterialStatePropertyAll(Colors.black),
                      //     ),
                      //     child:
                      const Icon(
                          Icons.photo_album_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                  // onPressed: () async {
                  // setState(() {});
                  // ImagePicker imagePicker = ImagePicker();
                  // XFile? file = await imagePicker.pickImage(
                  //     source: ImageSource.gallery);
                  // print('${file?.path}');

                  // String uniqueFileName =
                  //     DateTime.now().toString().replaceAll(' ', '');

                  // //Get a reference to storage root
                  // Reference referenceRoot =
                  //     FirebaseStorage.instance.ref();
                  // Reference referenceDirImages =
                  //     referenceRoot.child('images');

                  // //Create a reference for the image to be stored
                  // Reference referenceImageToUpload =
                  //     referenceDirImages.child(uniqueFileName);

                  // //Handle errors/success
                  // try {
                  //   //Store the file
                  //   await referenceImageToUpload
                  //       .putFile(File(file!.path));
                  //   //Success: get the download URL
                  //   imageUrl = await referenceImageToUpload
                  //       .getDownloadURL();
                  // } catch (error) {
                  //   //Some error occurred
                  // }
                  // },
                ),
                // ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFFD72499)),
                  ),
                  child: const Text('Save'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showSnackBar(context, "Saving");
                      final String message = _messgaeController.text;

                      String uniqueFileName =
                          DateTime.now().toString().replaceAll(' ', '');

                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('images');

                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);
                      //Handle errors/success
                      try {
                        //Store the file
                        await referenceImageToUpload
                            .putFile(File(bannerFile!.path));
                        //Success: get the download URL
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();
                      } catch (error) {
                        //Some error occurred
                      }
                      //메세지 작성
                      ref
                          .watch(dailyControllerProvider.notifier)
                          .createDailyMessageImage(message, imageUrl);
                      Navigator.of(context).pop();
                      showSnackBar(context, "Saved");
                    }

                    _messgaeController.clear();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
