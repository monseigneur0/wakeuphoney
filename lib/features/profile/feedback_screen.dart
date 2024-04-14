import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';

import '../../common/constants/app_colors.dart';
import '../../core/providers/providers.dart';
import '../../core/utils.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  static String routeName = "feedback";
  static String routeURL = "/feedback";
  const FeedbackScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final TextEditingController _messgaeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String imageUrl = "";

  File? bannerFile;

  void selectBannerImage() async {
    ImagePicker imagePicker = ImagePicker();
    final res = await imagePicker.pickImage(
      source: ImageSource.gallery,
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
    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.myAppBarBackgroundPink,
        title: const Text(
          "Feedback",
          style: TextStyle(color: Colors.black),
        ),
        actions: const [],
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
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: Colors.black),
                        labelText: 'Feedback at ${DateFormat.yMMMd().format(listDateTime[0])}'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: bannerFile != null
                          ? SizedBox(height: 30, width: 30, child: Image.file(bannerFile!))
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
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.myPink)),
                      child: const Text('Send'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          showToast("messgae is saved");
                          final String message = _messgaeController.text;

                          String uniqueFileName = DateTime.now().toString().replaceAll(' ', '');

                          //Get a reference to storage root
                          Reference referenceRoot = FirebaseStorage.instance.ref();
                          Reference referenceDirImages = referenceRoot.child('feedbackimages');

                          //Create a reference for the image to be stored
                          Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                          //Handle errors/success
                          try {
                            //Store the file
                            await referenceImageToUpload.putFile(File(bannerFile!.path));
                            //Success: get the download URL
                            imageUrl = await referenceImageToUpload.getDownloadURL();
                          } catch (error) {
                            //Some error occurred
                          }
                          //메세지 작성
                          ref.watch(profileControllerProvider.notifier).createFeedback(message, imageUrl);
                        }
                        _messgaeController.clear();
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
