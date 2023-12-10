import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';

import '../../core/utils.dart';

class ImageScreen extends ConsumerStatefulWidget {
  static String routeName = 'imagescreen';
  static String routeURL = '/imagescreen';
  const ImageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageScreenState();
}

class _ImageScreenState extends ConsumerState<ImageScreen> {
  Logger logger = Logger();

  String imageUrl = "";
  bool isLoading = false;
  File? imageFile;
  void selectImage() async {
    final imagePicked = await pickImage();

    if (imagePicked != null) {
      setState(() {
        imageFile = File(imagePicked.files.first.path!);
      });
    } else {
      if (context.mounted) {
        context.pop();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: imageFile != null
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    // width: 250,
                    child: Image.file(imageFile!),
                  )
                : Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text(
                    "취소",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () async {
                    showSnackBar(context, "저장 중입니다.");
                    String uniqueImageName = DateTime.now().toString();
                    Reference refRoot = ref.watch(storageProvider).ref();
                    Reference refDirImage = refRoot.child('images');
                    Reference refImageToUpload =
                        refDirImage.child(uniqueImageName);
                    try {
                      await refImageToUpload.putFile(File(imageFile!.path));
                      imageUrl = await refImageToUpload.getDownloadURL();
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                        logger.e(e.toString());
                      });
                    }
                    // ref.watch(provider)
                  },
                  child: const Text(
                    "저장",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
