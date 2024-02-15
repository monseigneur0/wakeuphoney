import 'dart:io';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wakeuphoney/features/main/main_screen.dart';

import '../../core/common/loader.dart';
import '../../core/constants/design_constants.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/providers/firebase_providers.dart';
import '../../core/utils.dart';
import '../alarm/alarm_new_ring_screen.dart';
import 'wakeup_controller.dart';
import 'wakeup_model.dart';

class WakeUpEditScreen extends ConsumerStatefulWidget {
  static String routeName = "wakeupedit";
  static String routeURL = "/wakeupedit";
  const WakeUpEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WakeUpEditScreenState();
}

class _WakeUpEditScreenState extends ConsumerState<WakeUpEditScreen> {
  Logger logger = Logger();

  bool loading = false;
  bool creating = true;
  bool isLoading = false;

  late WakeUpModel _wakeUp;

  late DateTime selectedWakeUpTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late double fadeDuration;
  late String assetAudio;

  late TimeOfDay selectedTime;

  late Time _time;

  final TextEditingController _letterController = TextEditingController();
  final ExpansionTileController _expansionTileController =
      ExpansionTileController();

  final _formKey = GlobalKey<FormState>();
  final FocusNode _letterFocusNode = FocusNode();

  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    selectedWakeUpTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().add(const Duration(days: 1)).day,
      7,
      0,
    );
    // selectedWakeUpTime = DateTime.now()
    //     .add(const Duration(minutes: 1))
    //     .copyWith(second: 0, millisecond: 0);
    selectedTime = TimeOfDay(
        hour: selectedWakeUpTime.hour, minute: selectedWakeUpTime.minute);
    loopAudio = false;
    vibrate = false;
    volume = null;
    assetAudio = 'assets/marimba.mp3';
  }

  @override
  void dispose() {
    _letterController.dispose();
    _letterFocusNode.dispose();
    super.dispose();
  }

  File? letterImageFile;

  void selectLetterImage() async {
    final letterImagePicked = await selectGalleryImage();
    if (letterImagePicked != null) {
      setState(() {
        letterImageFile = File(letterImagePicked.path);
      });
    }
  }

  void takeletterCameraImage() async {
    final letterCameraPicked = await takeCameraImage();
    if (letterCameraPicked != null) {
      setState(() {
        letterImageFile = File(letterCameraPicked.path);
      });
    }
  }

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  Future<void> pickTime() async {
    _time = Time(hour: selectedTime.hour, minute: selectedTime.minute);
    final res = await Navigator.of(context).push(showPicker(
      showSecondSelector: false,
      context: context,
      value: _time,
      onChange: onTimeChanged,
      minuteInterval: TimePickerInterval.ONE,
      iosStylePicker: true,
      minHour: 0,
      maxHour: 23,
      is24HrFormat: true,
      width: 360,
      // dialogInsetPadding:
      //     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
      hourLabel: ':',
      minuteLabel: ' ',
      // Optional onChange to receive value as DateTime
      onChangeDateTime: (DateTime dateTime) {},
    ));

    if (res != null) {
      setState(() {
        selectedTime = _time.toTimeOfDay();
      });
    }
    logger.d(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().add(const Duration(days: 1)).day,
        selectedTime.hour,
        selectedTime.minute));
  }

  void saveWakeUp() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    _wakeUp = WakeUpModel(
      wakeUpUid: const Uuid().v4(),
      createdTime: DateTime.now(),
      modifiedTimes: DateTime.now(),
      alarmId: DateTime.now().millisecondsSinceEpoch % 100000,
      wakeTime: selectedWakeUpTime,
      assetAudioPath: "",
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume ?? 0.8,
      fadeDuration: fadeDuration,
      notificationTitle: "WakeUpGom alarm", //wakeupgomalarm
      notificationBody: "Alarm rings with a letter", //wakeupgomletter
      enableNotificationOnKill: true,
      androidFullScreenIntent: true,
      isDeleted: false,
      isApproved: false,
      approveTime: null,
      senderUid: "",
      letter: "",
      letterPhoto: "",
      letterAudio: "",
      letterVideo: "",
      reciverUid: "",
      answerTime: null,
      answer: "",
      answerPhoto: "",
      answerAudio: "",
      answerVideo: "",
    );
    setState(() {
      loading = false;
    });
    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("언제 깨워 볼까요?"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.goNamed(MainScreen.routeName),
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AlarmNewScreen.routeName),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      pickTime();
                      _letterFocusNode.unfocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(8, 8))
                          ]),
                      child: Text(
                        selectedTime.format(context),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.black, fontSize: 30),
                      ),
                    ),
                  ),
                  10.heightBox,
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(8, 8))
                        ]),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: "알람 상세 설정".text.make(),
                      backgroundColor: AppColors.myAppBarBackgroundPink,
                      controller: _expansionTileController,
                      onExpansionChanged: (value) {
                        if (value) {
                          _letterFocusNode.unfocus();
                        }
                      },
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(8, 8))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.customvolume,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Switch(
                                value: volume != null,
                                onChanged: (value) =>
                                    setState(() => volume = value ? 0.8 : null),
                              ),
                            ],
                          ).pSymmetric(h: 20),
                        ).pSymmetric(h: 10, v: 5),
                        SizedBox(
                          height: 30,
                          child: volume != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      volume! > 0.7
                                          ? Icons.volume_up_rounded
                                          : volume! > 0.1
                                              ? Icons.volume_down_rounded
                                              : Icons.volume_mute_rounded,
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: volume!,
                                        onChanged: (value) {
                                          setState(() => volume = value);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(8, 8))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.loopalarmaudio,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Switch(
                                value: loopAudio,
                                onChanged: (value) =>
                                    setState(() => loopAudio = value),
                              ),
                            ],
                          ).pSymmetric(h: 20),
                        ).pSymmetric(h: 10, v: 5),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(8, 8))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.vibrate,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Switch(
                                value: vibrate,
                                onChanged: (value) =>
                                    setState(() => vibrate = value),
                              ),
                            ],
                          ).pSymmetric(h: 20),
                        ).pSymmetric(h: 10, v: 5),
                        10.heightBox,
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(8, 8))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.sound,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              DropdownButton(
                                value: assetAudio,
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: 'assets/marimba.mp3',
                                    child: Text('Marimba'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'assets/nature.mp3',
                                    child: Text('Nature'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'assets/childhood.mp3',
                                    child: Text('Childhood'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'assets/happylife.mp3',
                                    child: Text('Happy Life'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'assets/mozart.mp3',
                                    child: Text('Mozart'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'assets/nokia.mp3',
                                    child: Text('Nokia'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'assets/one_piece.mp3',
                                    child: Text('One Piece'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'assets/star_wars.mp3',
                                    child: Text('Star Wars'),
                                  ),
                                ],
                                onChanged: (value) =>
                                    setState(() => assetAudio = value!),
                              ),
                            ],
                          ).pSymmetric(h: 20),
                        ).pSymmetric(h: 10, v: 5),
                        10.heightBox,
                      ],
                    ),
                  ),
                  10.heightBox,
                  if (!creating)
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.deletealarm,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  20.heightBox,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              minLines: 2,
                              maxLines: 8,
                              keyboardType: TextInputType.multiline,
                              controller: _letterController,
                              focusNode: _letterFocusNode,
                              onTap: () => _expansionTileController.collapse(),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value == "") {
                                  return AppLocalizations.of(context)!
                                      .putsometext;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    AppLocalizations.of(context)!.wakeupyou,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.heightBox,
                  // if (_letterFocusNode.hasFocus) {
                  //     _letterFocusNode.unfocus();
                  //   } else {
                  //     _letterFocusNode.requestFocus();
                  //     _expansionTileController.collapse();
                  //   }
                  10.heightBox,
                  letterImageFile != null
                      ? SizedBox(
                          height: 300,
                          width: 250,
                          child: Image.file(letterImageFile!),
                        )
                      : Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showToast("사진 가져오기");

                                selectLetterImage();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(8, 8))
                                    ]),
                                child: Row(
                                  children: [
                                    Text(
                                      "앨범",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    const Icon(Icons.image_outlined)
                                  ],
                                ).pSymmetric(h: 20, v: 10),
                              ),
                            ),
                            10.heightBox,
                            GestureDetector(
                              onTap: () {
                                showToast("사진 찍기");
                                takeletterCameraImage();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(8, 8))
                                    ]),
                                child: Row(
                                  children: [
                                    Text(
                                      "카메라",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    const Icon(Icons.camera_alt_outlined)
                                  ],
                                ).pSymmetric(h: 20, v: 10),
                              ),
                            ),
                          ],
                        ),
                  10.heightBox,
                  GestureDetector(
                    onTap: () {
                      showToast("음성 녹음 준비 중이에요");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(8, 8))
                          ]),
                      child: Row(
                        children: [
                          Text(
                            "음성 녹음",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          const Icon(Icons.mic_none)
                        ],
                      ).pSymmetric(h: 20, v: 10),
                    ),
                  ),
                  10.heightBox,
                ],
              ),
              10.heightBox,
              Row(
                children: [
                  isLoading
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          child: const Center(child: Loader()),
                        )
                      : Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                showToast("저장 중이에요");
                                setState(() {
                                  isLoading = true;
                                });
                                String uniqueImageName =
                                    DateTime.now().toString();
                                Reference refRoot =
                                    ref.watch(storageProvider).ref();
                                Reference refDirImage = refRoot
                                    .child(FirebaseConstants.wakeUpImage);
                                Reference refImageToUpload =
                                    refDirImage.child(uniqueImageName);
                                if (letterImageFile != null) {
                                  try {
                                    await refImageToUpload
                                        .putFile(File(letterImageFile!.path));
                                    imageUrl =
                                        await refImageToUpload.getDownloadURL();
                                  } catch (e) {
                                    logger.e(
                                        "Error uploading image or no image file selected");
                                    logger.e(e.toString());

                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                                ref
                                    .watch(wakeUpControllerProvider.notifier)
                                    .createWakeUp(
                                        DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now()
                                                .add(const Duration(days: 1))
                                                .day,
                                            selectedTime.hour,
                                            selectedTime.minute),
                                        _letterController.text,
                                        imageUrl,
                                        volume ?? 0.8,
                                        vibrate);
                                if (mounted) {
                                  context.goNamed(MainScreen.routeName);
                                  showToast(
                                      AppLocalizations.of(context)!.saved);
                                }
                                _letterController.clear();
                                ref.watch(getTomorrowWakeUpYouProvider);
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.myPink,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(),
                              ),
                              child: Center(child: "깨우기".text.white.make())
                                  .pSymmetric(v: 10),
                            ),
                          ),
                        ),
                ],
              ),
              10.heightBox,
            ],
          ).pSymmetric(h: 15),
        ),
      )),
    );
  }
}
