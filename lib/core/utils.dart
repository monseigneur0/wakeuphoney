import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

void showToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);

  return image;
}

Future<XFile?> selectGalleryImage() async {
  ImagePicker imagePicker = ImagePicker();
  final res = await imagePicker.pickImage(
    source: ImageSource.gallery,
    maxHeight: 1080,
    maxWidth: 1080,
    imageQuality: 15,
  );

  return res;
}

Future<XFile?> takeCameraImage() async {
  ImagePicker imagePicker = ImagePicker();
  final res = await imagePicker.pickImage(
    source: ImageSource.camera,
    maxHeight: 1080,
    maxWidth: 1080,
    imageQuality: 15,
  );

  return res;
}

String createUniqueImageName() {
  return DateTime.now().toString();
}

Future<FilePickerResult?> takePhoto() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);

  return image;
}
