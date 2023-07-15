import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/common/error_text.dart';
import '../../core/common/loader.dart';
import '../../core/providers/firebase_providers.dart';
import '../../core/providers/providers.dart';
import '../../core/utils.dart';
import 'daily_controller.dart';

class ResponseScreen extends ConsumerStatefulWidget {
  static String routeName = "response";
  static String routeURL = "/response";
  const ResponseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends ConsumerState<ResponseScreen> {
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
    final uid = ref.watch(authProvider).currentUser!.uid;

    final dateList100 = ref.watch(dateStateProvider);
    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "No Response, No Wake Up",
        ),
        actions: const [],
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
          ref.watch(getDailyMessageProvider(dateList100[0])).when(
                data: (message) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          DateFormat.yMMMd().format(listDateTime[0]),
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[300]),
                        ),
                        Container(
                          height: 10,
                          // decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        Text(
                          message.message,
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
                error: (error, stackTrace) {
                  print("error");

                  return ErrorText(
                      error: DateFormat.yMMMd().format(listDateTime[0]));
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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText:
                      'message at ${DateFormat.yMMMd().format(listDateTime[0])}'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black),
                ),
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
                        // color: Colors.white,
                      ),
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  print('${file?.path}');

                  String uniqueFileName =
                      DateTime.now().toString().replaceAll(' ', '');

                  //Get a reference to storage root
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child('images');

                  //Create a reference for the image to be stored
                  Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueFileName);

                  //Handle errors/success
                  try {
                    //Store the file
                    await referenceImageToUpload.putFile(File(file!.path));
                    //Success: get the download URL
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                  } catch (error) {
                    //Some error occurred
                  }
                },
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFFD72499))),
                child: const Text('I woke up!'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showSnackBar(context, "messgae is saved");
                    final String message = _messgaeController.text;
                    //메세지 작성
                    ref
                        .watch(dailyControllerProvider.notifier)
                        .createResponseMessage(message, uid);
                  }

                  _messgaeController.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
