import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/oldbitcoin/bitcoin_screen.dart';
import 'package:wakeuphoney/features/oldchatgpt/cs_screen.dart';
import 'package:wakeuphoney/core/image/image_screen.dart';
import 'package:wakeuphoney/common/common.dart';
import '../oldauth/auth_controller.dart';
import '../oldauth/auth_repository.dart';
import '../oldauth/login_screen.dart';
import 'profile_controller.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  static String routeName = 'profileedit';
  static String routeURL = '/profileedit';
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  Logger logger = Logger();
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  static const double smallGap = 10;
  static const double midGap = 20;
  static const double largeGap = 40;

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
    ref.watch(profileControllerProvider.notifier).updateWakeUpTime(DateTime(2021, 1, 1, _time.hour, _time.minute));
    ref.watch(analyticsProvider).logSelectContent(contentType: "time", itemId: "editwakeuptime");

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
        title: Text('editprofile'.tr()),
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
                      analytics.logSelectContent(contentType: 'image', itemId: 'profileimage');
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
                        'name'.tr(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: smallGap,
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
                                            .read(profileControllerProvider.notifier)
                                            .updateDisplayName(_textEditingController.text);

                                        Navigator.pop(context);
                                        _textEditingController.clear();
                                        analytics.logSelectContent(contentType: 'name', itemId: 'editname');
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "'writechangename'.tr()",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "'writename'.tr()";
                                      }
                                      return null;
                                    },
                                  ).pOnly(top: 10, right: 10, left: 10, bottom: context.mq.viewInsets.bottom),
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
                                        .read(profileControllerProvider.notifier)
                                        .updateDisplayName(_textEditingController.text);

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
                          Text(user.displayName, style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: largeGap,
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
                          ref.read(profileControllerProvider.notifier).updateBirthday(value);
                          analytics.logSelectContent(contentType: 'birthday', itemId: 'editbirthday');
                        }
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('birthday'.tr(), style: const TextStyle(fontSize: 18)),
                          Text(DateFormat("yyyy/MM/dd").format(user.birthDate),
                              style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                        ],
                      ).pSymmetric(v: 8, h: 20),
                    ),
                  ),
                  const SizedBox(
                    height: smallGap,
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
                                  height: midGap,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref.read(profileControllerProvider.notifier).updateGender(1);
                                    analytics.logSelectContent(contentType: "gender", itemId: "editgender");
                                  },
                                  child: Container(
                                          height: 60,
                                          width: MediaQuery.of(context).size.width - 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    blurRadius: 10,
                                                    offset: const Offset(8, 8))
                                              ]),
                                          child: Center(child: Text('male'.tr(), style: const TextStyle(fontSize: 24))))
                                      .pSymmetric(v: 10),
                                ),
                                const SizedBox(
                                  height: smallGap,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref.read(profileControllerProvider.notifier).updateGender(2);
                                  },
                                  child: Container(
                                          height: 60,
                                          width: MediaQuery.of(context).size.width - 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    blurRadius: 10,
                                                    offset: const Offset(8, 8))
                                              ]),
                                          child:
                                              Center(child: Text('female'.tr(), style: const TextStyle(fontSize: 24)))
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
                          Text('gender'.tr(), style: const TextStyle(fontSize: 18)),
                          Text(user.gender == "male" ? 'male'.tr() : 'female'.tr(),
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ).pSymmetric(v: 8, h: 20),
                    ),
                  ),
                  const SizedBox(
                    height: smallGap,
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
                    height: largeGap,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'myaccount'.tr(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: smallGap,
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
                    height: midGap,
                  ),

                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'coupleaccount'.tr(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: smallGap,
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
                        Text(user.coupleDisplayName ?? 'no'.tr(),
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
                          Text('wakeuptime'.tr(),
                              style: TextStyle(
                                color: Colors.grey[700],
                              )),
                          Text(DateFormat('afterwakeup'.tr()).format(user.coupleWakeUpTime!),
                              style: TextStyle(
                                color: Colors.grey[700],
                              )),
                        ],
                      ).pSymmetric(v: 8, h: 20),
                    ),
                  ),
                  const SizedBox(
                    height: largeGap,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(CustomerServiceScreen.routeName);
                      analytics.logSelectContent(contentType: "go", itemId: "chatgptcs");
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
                          Text('cscenter'.tr(), style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: smallGap,
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrlString("https://sweetgom.com/5");
                      analytics.logSelectContent(contentType: "go", itemId: "appinfoonline");
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
                          Text('appintro'.tr(), style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: smallGap,
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
                            Text('appversion'.tr(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("1.0.36", style: TextStyle(fontSize: 18)),
                            SizedBox(width: 20, height: 40),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: smallGap,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(BitcoinScreen.routeName);
                      analytics.logSelectContent(contentType: "go", itemId: "bitcoin");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text("Bitcoin price", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: smallGap,
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrlString('https://sweetgom.com/4');
                      analytics.logSelectContent(contentType: "go", itemId: "appinfopolicy");
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
                          Text('inforule'.tr(), style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: largeGap,
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
                  //   height: smallGap,
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
                  //   height: midGap,
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
                  //   height: smallGap,
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
                    height: largeGap,
                  ),
                  GestureDetector(
                    onTap: () {
                      Platform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Text('sure'.tr()),
                                content: Text('logout'.tr()),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('no'.tr()),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.goNamed(LoginHome.routeName);
                                      ref.watch(authRepositoryProvider).logout();
                                      analytics.logSelectContent(contentType: "logout", itemId: "logout");
                                    },
                                    isDestructiveAction: true,
                                    child: Text('yes'.tr()),
                                  ),
                                ],
                              ),
                            )
                          : showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('logout'.tr()),
                                  content: Text('sure'.tr()),
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
                                        ref.watch(authRepositoryProvider).logout();
                                        Navigator.of(context).pop();
                                        analytics.logSelectContent(contentType: "logout", itemId: "logout");
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
                          Text('logout'.tr(), style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: midGap,
                  ),
                  GestureDetector(
                    onTap: () {
                      Platform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Text('breakup'.tr()),
                                content: Text('deletesure'.tr()),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('no'.tr()),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      ref.watch(authControllerProvider.notifier).brokeup();
                                      analytics.logSelectContent(contentType: "breakup", itemId: "breakup");
                                    },
                                    isDestructiveAction: true,
                                    child: Text('yes'.tr()),
                                  ),
                                ],
                              ),
                            )
                          : showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('breakup'.tr()),
                                  content: Text('deletesure'.tr()),
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
                                        ref.watch(authControllerProvider.notifier).brokeup();
                                        Navigator.of(context).pop();
                                        analytics.logSelectContent(contentType: "breakup", itemId: "breakup");
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
                          Text('breakup'.tr(), style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: midGap,
                  ),
                  GestureDetector(
                    onTap: () {
                      Platform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Text('delete'.tr()),
                                content: Text('deletesure'.tr()),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('no'.tr()),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.goNamed(LoginHome.routeName);

                                      ref.watch(authRepositoryProvider).deleteUser();
                                      analytics.logSelectContent(contentType: "delete", itemId: "delete");
                                    },
                                    isDestructiveAction: true,
                                    child: Text('yes'.tr()),
                                  ),
                                ],
                              ),
                            )
                          : showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('delete'.tr()),
                                  content: Text('deletesure'.tr()),
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
                                        ref.watch(authRepositoryProvider).deleteUser();
                                        Navigator.of(context).pop();
                                        analytics.logSelectContent(contentType: "delete", itemId: "delete");
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
                          Text('deleteaccount'.tr(), style: const TextStyle(fontSize: 20)),
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
              child: Text('erroruser'.tr()),
            );
          },
          loading: () => const Loader()),
    );
  }
}
