import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
    ImagePicker imagePicker = ImagePicker();
    final res = await imagePicker.pickImage(source: ImageSource.camera);

    if (res != null) {
      setState(() {
        bannerFile = File(res.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = "39xWyVZmEqRxPmmSsOVSE2UvQnE2";

    final dateList100 = ref.watch(dateStateProvider);
    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMd().format(listDateTime[0]),
          style: const TextStyle(color: Colors.black),
        ),
        actions: const [],
        backgroundColor: Colors.white,
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
                ref.watch(getDailyCoupleMessageProvider(dateList100[0])).when(
                      data: (message) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 10,
                                // decoration: BoxDecoration(color: Colors.grey[700]),
                              ),
                              Text(
                                message.message,
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        print("error");

                        return Column(
                          children: const [
                            SizedBox(
                              height: 50,
                            ),
                            Text("no letter..."),
                            SizedBox(
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
                              MaterialStatePropertyAll(Color(0xFFD72499))),
                      child: const Text('I woke up!'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          showSnackBar(context, "messgae is saved");
                          final String message = _messgaeController.text;

                          String uniqueFileName =
                              DateTime.now().toString().replaceAll(' ', '');

                          //Get a reference to storage root
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImages =
                              referenceRoot.child('images');

                          //Create a reference for the image to be stored
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
                              .createResponseMessage(message, imageUrl);
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
