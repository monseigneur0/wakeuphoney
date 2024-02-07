import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:wakeuphoney/features/chatgpt/cs_screen.dart';
import 'package:wakeuphoney/features/image/image_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_repository.dart';
import '../auth/login_screen.dart';
import 'profile_controller.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  static String routeName = 'profileedit';
  static String routeURL = '/profileedit';
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  Logger logger = Logger();
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  String imageUrl = "";
  File? profileImageFile;
  void selectProfileImage() async {
    final profileImagePicked = await selectGalleryImage();
    if (profileImagePicked != null) {
      setState(() {
        profileImageFile = File(profileImagePicked.path);
      });
    }
  }

  late TimeOfDay selectedTime;
  late Time _time;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  Future<void> pickTime() async {
    _time = Time(hour: 5, minute: 0);
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
      onChangeDateTime: (DateTime dateTime) {
        // logger.d(dateTime);
        logger.d("[debug datetime]:  $dateTime");
      },
    ));
    logger.d(_time);
    ref
        .watch(profileControllerProvider.notifier)
        .updateWakeUpTime(DateTime(2021, 1, 1, _time.hour, _time.minute));
    ref
        .watch(analyticsProvider)
        .logSelectContent(contentType: "time", itemId: "editwakeuptime");

    //     showTimePicker(
    //   initialTime: selectedTime,
    //   context: context,
    // );
    if (res != null) {
      setState(() {
        selectedTime = _time.toTimeOfDay();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(getMyUserInfoProvider);
    final analytics = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editprofile),
      ),
      backgroundColor: Colors.grey[200],
      body: userProfile.when(
          data: (user) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(ImageScreen.routeName);
                      analytics.logSelectContent(
                          contentType: 'image', itemId: 'profileimage');
                    },
                    child: Center(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              width: 100,
                              imageUrl: user.photoURL,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => const SizedBox(
                                height: 40,
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(30, -20),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                  )),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // CircleAvatar(
                  //   radius: 100,
                  //   child: CircleAvatar(
                  //     radius: 99,
                  //     backgroundColor: Colors.black,
                  //     child: CachedNetworkImage(
                  //       imageUrl: user.photoURL,
                  //     ),
                  //   ),
                  // ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.name,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      _textEditingController.text = user.displayName;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _textEditingController,
                                    autofocus: true,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () {
                                      if (_formKey.currentState!.validate()) {
                                        ref
                                            .read(profileControllerProvider
                                                .notifier)
                                            .updateDisplayName(
                                                _textEditingController.text);

                                        Navigator.pop(context);
                                        _textEditingController.clear();
                                        analytics.logSelectContent(
                                            contentType: 'name',
                                            itemId: 'editname');
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      hintText:
                                          "AppLocalizations.of(context)!.writechangename",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "AppLocalizations.of(context)!.writename";
                                      }
                                      return null;
                                    },
                                  ).pOnly(
                                      top: 10,
                                      right: 10,
                                      left: 10,
                                      bottom: context.mq.viewInsets.bottom),
                                ),
                              ),
                              IconButton(
                                iconSize: 42,
                                color: Colors.black,
                                icon: const Icon(
                                  Icons.arrow_circle_up,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ref
                                        .read(
                                            profileControllerProvider.notifier)
                                        .updateDisplayName(
                                            _textEditingController.text);

                                    Navigator.pop(context);
                                    _textEditingController.clear();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text(user.displayName,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateBirthday(value);
                          analytics.logSelectContent(
                              contentType: 'birthday', itemId: 'editbirthday');
                        }
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.birthday,
                              style: const TextStyle(fontSize: 18)),
                          Text(DateFormat("yyyy/MM/dd").format(user.birthDate),
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600])),
                        ],
                      ).pSymmetric(v: 8, h: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          constraints: const BoxConstraints(maxHeight: 300),
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref
                                        .read(
                                            profileControllerProvider.notifier)
                                        .updateGender(1);
                                    analytics.logSelectContent(
                                        contentType: "gender",
                                        itemId: "editgender");
                                  },
                                  child: Container(
                                          height: 60,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    offset: const Offset(8, 8))
                                              ]),
                                          child: Center(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .male,
                                                  style: const TextStyle(
                                                      fontSize: 24))))
                                      .pSymmetric(v: 10),
                                ),
                                10.heightBox,
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref
                                        .read(
                                            profileControllerProvider.notifier)
                                        .updateGender(2);
                                  },
                                  child: Container(
                                          height: 60,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    offset: const Offset(8, 8))
                                              ]),
                                          child: Center(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .female,
                                                      style: const TextStyle(
                                                          fontSize: 24)))
                                              .p(5))
                                      .pSymmetric(v: 10),
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.gender,
                              style: const TextStyle(fontSize: 18)),
                          Text(
                              user.gender == "male"
                                  ? AppLocalizations.of(context)!.male
                                  : AppLocalizations.of(context)!.female,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ).pSymmetric(v: 8, h: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   color: Colors.white,
                  //   child: const Row(
                  //     children: [
                  //       SizedBox(
                  //         width: 20,
                  //         height: 40,
                  //       ),
                  //       Text("위치", style: TextStyle(fontSize: 18)),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  //   child: Text(
                  //     "입력하신 위치는 날씨 정보 제공을 위해 사용됩니다.",
                  //     style: TextStyle(color: Colors.grey[700]),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.myaccount,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 40,
                        ),
                        Text(user.email,
                            style: TextStyle(
                              color: Colors.grey[700],
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.coupleaccount,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 40,
                        ),
                        Text(
                            user.coupleDisplayName ??
                                AppLocalizations.of(context)!.no,
                            style: TextStyle(
                              color: Colors.grey[700],
                            )),
                      ],
                    ),
                  ),
                  10.heightBox,
                  GestureDetector(
                    onTap: () {
                      pickTime();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.wakeuptime,
                              style: TextStyle(
                                color: Colors.grey[700],
                              )),
                          Text(
                              DateFormat(
                                      AppLocalizations.of(context)!.afterwakeup)
                                  .format(user.coupleWakeUpTime!),
                              style: TextStyle(
                                color: Colors.grey[700],
                              )),
                        ],
                      ).pSymmetric(v: 8, h: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(CustomerServiceScreen.routeName);
                      analytics.logSelectContent(
                          contentType: "go", itemId: "chatgptcs");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text(AppLocalizations.of(context)!.cscenter,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrlString("https://sweetgom.com/5");
                      analytics.logSelectContent(
                          contentType: "go", itemId: "appinfoonline");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text(AppLocalizations.of(context)!.appintro,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 40,
                            ),
                            Text(AppLocalizations.of(context)!.appversion,
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("1.0.30", style: TextStyle(fontSize: 18)),
                            SizedBox(width: 20, height: 40),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrlString('https://sweetgom.com/4');
                      analytics.logSelectContent(
                          contentType: "go", itemId: "appinfopolicy");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text(AppLocalizations.of(context)!.inforule,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Row(
                  //   children: [
                  //     const SizedBox(
                  //       width: 20,
                  //     ),
                  //     Text(
                  //       "내 계정 정보",
                  //       style: TextStyle(color: Colors.grey[700]),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   color: Colors.white,
                  //   child: Row(
                  //     children: [
                  //       const SizedBox(
                  //         width: 20,
                  //         height: 40,
                  //       ),
                  //       Text(user.email,
                  //           style: TextStyle(
                  //             color: Colors.grey[700],
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Row(
                  //   children: [
                  //     const SizedBox(
                  //       width: 20,
                  //     ),
                  //     Text(
                  //       "상대 계정 정보",
                  //       style: TextStyle(color: Colors.grey[700]),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   color: Colors.white,
                  //   child: Row(
                  //     children: [
                  //       const SizedBox(
                  //         width: 20,
                  //         height: 40,
                  //       ),
                  //       Text(user.coupleDisplayName ?? "없어요",
                  //           style: TextStyle(
                  //             color: Colors.grey[700],
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Platform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Text(AppLocalizations.of(context)!.sure),
                                content:
                                    Text(AppLocalizations.of(context)!.logout),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child:
                                        Text(AppLocalizations.of(context)!.no),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.goNamed(LoginHome.routeName);
                                      ref
                                          .watch(authRepositoryProvider)
                                          .logout();
                                      analytics.logSelectContent(
                                          contentType: "logout",
                                          itemId: "logout");
                                    },
                                    isDestructiveAction: true,
                                    child:
                                        Text(AppLocalizations.of(context)!.yes),
                                  ),
                                ],
                              ),
                            )
                          : showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      AppLocalizations.of(context)!.logout),
                                  content:
                                      Text(AppLocalizations.of(context)!.sure),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.goNamed(LoginHome.routeName);
                                        ref
                                            .watch(authRepositoryProvider)
                                            .logout();
                                        Navigator.of(context).pop();
                                        analytics.logSelectContent(
                                            contentType: "logout",
                                            itemId: "logout");
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                );
                              });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text(AppLocalizations.of(context)!.logout,
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Platform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title:
                                    Text(AppLocalizations.of(context)!.breakup),
                                content: Text(
                                    AppLocalizations.of(context)!.deletesure),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child:
                                        Text(AppLocalizations.of(context)!.no),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      ref
                                          .watch(
                                              authControllerProvider.notifier)
                                          .brokeup();
                                      analytics.logSelectContent(
                                          contentType: "breakup",
                                          itemId: "breakup");
                                    },
                                    isDestructiveAction: true,
                                    child:
                                        Text(AppLocalizations.of(context)!.yes),
                                  ),
                                ],
                              ),
                            )
                          : showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      AppLocalizations.of(context)!.breakup),
                                  content: Text(
                                      AppLocalizations.of(context)!.deletesure),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ref
                                            .watch(
                                                authControllerProvider.notifier)
                                            .brokeup();
                                        Navigator.of(context).pop();
                                        analytics.logSelectContent(
                                            contentType: "breakup",
                                            itemId: "breakup");
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                );
                              });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text(AppLocalizations.of(context)!.breakup,
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Platform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title:
                                    Text(AppLocalizations.of(context)!.delete),
                                content: Text(
                                    AppLocalizations.of(context)!.deletesure),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child:
                                        Text(AppLocalizations.of(context)!.no),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.goNamed(LoginHome.routeName);

                                      ref
                                          .watch(authRepositoryProvider)
                                          .deleteUser();
                                      analytics.logSelectContent(
                                          contentType: "delete",
                                          itemId: "delete");
                                    },
                                    isDestructiveAction: true,
                                    child:
                                        Text(AppLocalizations.of(context)!.yes),
                                  ),
                                ],
                              ),
                            )
                          : showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      AppLocalizations.of(context)!.delete),
                                  content: Text(
                                      AppLocalizations.of(context)!.deletesure),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.goNamed(LoginHome.routeName);
                                        ref
                                            .watch(authRepositoryProvider)
                                            .deleteUser();
                                        Navigator.of(context).pop();
                                        analytics.logSelectContent(
                                            contentType: "delete",
                                            itemId: "delete");
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                );
                              });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text(AppLocalizations.of(context)!.deleteaccount,
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            logger.e(error);
            return Center(
              child: Text(AppLocalizations.of(context)!.erroruser),
            );
          },
          loading: () => const Loader()),
    );
  }
}
