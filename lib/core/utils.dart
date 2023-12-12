import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
      ),
    );
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

Future<FilePickerResult?> takePhoto() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);

  return image;
}
