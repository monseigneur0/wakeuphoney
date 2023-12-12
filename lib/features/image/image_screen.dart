import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';

import '../../core/common/loader.dart';
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
  CroppedFile? _croppedFile;

  void selectImage() async {
    final imagePicked = await selectGalleryImage();

    if (imagePicked != null) {
      setState(() {
        imageFile = File(imagePicked.path);
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
            child: _croppedFile != null
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    // width: 250,
                    child: Image.file(File(_croppedFile!.path)),
                  )
                : imageFile != null
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
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
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              isLoading
                  ? const Loader()
                  : _croppedFile == null
                      ? Container()
                      : TextButton(
                          onPressed: () async {
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
                              await refImageToUpload
                                  .putFile(File(_croppedFile!.path));
                              imageUrl =
                                  await refImageToUpload.getDownloadURL();
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                                logger.e(e.toString());
                              });
                            }
                            ref
                                .watch(profileControllerProvider.notifier)
                                .updateProfileImage(imageUrl);
                            if (mounted) {
                              Navigator.of(context).pop();
                              showSnackBar(context, "사진을 저장했어요");
                            }
                          },
                          child: const Text(
                            "저장",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
              if (_croppedFile == null)
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      fnCropImage();
                    },
                    backgroundColor: const Color(0xFFEA6357),
                    tooltip: 'Crop',
                    child: const Icon(Icons.crop),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  Future<void> fnCropImage() async {
    if (imageFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 10, ratioY: 10),
        compressQuality: 5,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
            // minimumAspectRatio: 1,
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
            aspectRatioPickerButtonHidden: true,
            resetAspectRatioEnabled: false,
            aspectRatioLockDimensionSwapEnabled: true,
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }
}
