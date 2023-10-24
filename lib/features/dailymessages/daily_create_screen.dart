import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wakeuphoney/core/common/loader.dart';

import '../../core/constants/design_constants.dart';
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

  bool isLoading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return origianl(context);
  }
  // return Scaffold(
  //   appBar: AppBar(title: const Text('Image Upload')),
  //   body: const ImageUploadButton(),
  // );

  Scaffold origianl(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("편지 쓰기"),
      ),
      backgroundColor: AppColors.myAppBarBackgroundPink,
      body: Padding(
        padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: isLoading
            ? const Loader()
            : Column(
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
                      controller: _messgaeController,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
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
                                height: 300,
                                width: 250,
                                child: Image.file(bannerFile!))
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
                        // logger.d('${file?.path}');

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
                            setState(() {
                              isLoading = true;
                            });

                            showSnackBar(context, "Please wait, saving...");
                            final String message = _messgaeController.text;

                            String uniqueFileName =
                                DateTime.now().toString().replaceAll(' ', '');

                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
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
                            } catch (e) {
                              //Some error occurred
                              setState(() {
                                isLoading = false;
                                error = e.toString();
                              });
                            }
                            //메세지 작성
                            ref
                                .watch(dailyControllerProvider.notifier)
                                .createDailyMessageImage(message, imageUrl);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              showSnackBar(context, "Saved");
                            }
                          }

                          _messgaeController.clear();
                        },
                      ),
                    ],
                  ),
                  if (error != null) ...[
                    const Text("An error occurred"),
                    Text(error!),
                    ElevatedButton(
                        onPressed: () => setState(() => error = null),
                        child: const Text("Dismiss"))
                  ]
                ],
              ),
      ),
    );
  }
}

// class ImageUploadButton extends StatefulWidget {
//   const ImageUploadButton({super.key});

//   @override
//   _ImageUploadButtonState createState() => _ImageUploadButtonState();
// }

// class _ImageUploadButtonState extends State<ImageUploadButton> {
//   File? _image;
//   bool isLoading = false;

//   Future<void> getImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future<void> _uploadImage() async {
//     setState(() {
//       isLoading = true;
//     });

//     final ref = FirebaseStorage.instance
//         .ref()
//         .child('images')
//         .child('${DateTime.now()}.jpg');

//     try {
//       await ref.putFile(_image!).whenComplete(() => null);
//       final url = await ref.getDownloadURL();

//       // FirebaseFirestore.instance.collection('images').add({'url': url});

//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         isLoading
//             ? const Loader()
//             : ElevatedButton.icon(
//                 onPressed: getImage,
//                 icon: const Icon(Icons.image),
//                 label: const Text('Pick Image'),
//               ),
//         const SizedBox(height: 10),
//         isLoading
//             ? Container()
//             : (_image != null ? Image.file(_image!) : Container()),
//         const SizedBox(height: 10),
//         isLoading
//             ? Container()
//             : (ElevatedButton.icon(
//                 onPressed: _uploadImage,
//                 icon: const Icon(Icons.cloud_upload),
//                 label: const Text('Upload Image'),
//               )),
//       ],
//     );
//   }
// }
