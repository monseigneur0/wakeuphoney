import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/loader.dart';
import '../../core/constants/design_constants.dart';
import '../alarm/alarm_screen.dart';
import '../auth/login_screen.dart';
import 'drawer.dart';
import 'match_controller.dart';

class MatchScreen extends ConsumerStatefulWidget {
  static String routeName = "Matchscreen";
  static String routeURL = "/match";
  const MatchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  String toTick(DateTime time) {
    int leftSec = 3600 -
        ((DateTime.now().millisecondsSinceEpoch -
                time.millisecondsSinceEpoch) ~/
            1000);
    Timer timer = Timer.periodic(const Duration(seconds: 1), onTick);
    return format(leftSec);
  }

  void onTick(Timer timer) {
    int totalSeconds = 10;
    if (totalSeconds < 1) {
      if (context.mounted) {
        context.go(AlarmHome.routeURL);
      }
    } else {
      if (mounted) {
        setState(() {
          // state 변경에 대한 코드.
        });
      }
      totalSeconds = totalSeconds - 1;
    }
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    // logger.d("duration $duration");
    return duration.toString().split(".").first.substring(2, 7);
  }

  var logger = Logger();

  @override
  void dispose() {
    _honeyCodeController.dispose();
    super.dispose();
  }

  final TextEditingController _honeyCodeController = TextEditingController();

  bool _visiblebear = true;
  int randomNum = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> messageList = [
      AppLocalizations.of(context)!.hello,
      AppLocalizations.of(context)!.goodmorning,
      AppLocalizations.of(context)!.honeywakeup,
      AppLocalizations.of(context)!.writealetter,
      AppLocalizations.of(context)!.sendaphoto,
      AppLocalizations.of(context)!.checktheletter,
      AppLocalizations.of(context)!.watchthephoto,
      AppLocalizations.of(context)!.replyletter,
      AppLocalizations.of(context)!.canyoureply,
      AppLocalizations.of(context)!.writemorning,
      AppLocalizations.of(context)!.howareyou,
      AppLocalizations.of(context)!.imissyou,
    ];

    final hasCoupleId = ref.watch(getUserProfileStreamProvider);
    final userProfileStream = ref.watch(getUserProfileStreamProvider);
    final userCoupleProfileStream = ref.watch(getCoupleProfileStreamProvider);

    return hasCoupleId.when(
      data: (data) => data.couples.isNotEmpty
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.myAppBarBackgroundPink,
                elevation: 0,
                title: Text(
                  AppLocalizations.of(context)!.profile,
                  style: const TextStyle(color: Colors.black),
                ),
                // const Text(
                //   "Profile",
                //   style: TextStyle(
                //       color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                // ),
              ),
              backgroundColor: AppColors.myBackgroundPink,
              body: Column(
                children: [
                  Container(
                    height: 1,
                    decoration: BoxDecoration(color: Colors.grey[800]),
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedOpacity(
                        opacity: _visiblebear ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 0),
                        child: Container(
                          width: 250,
                          height: 75,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(19),
                              topRight: Radius.circular(19),
                              bottomLeft: Radius.circular(19),
                              bottomRight: Radius.circular(19),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                messageList[randomNum],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _visiblebear ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 0),
                        child: CustomPaint(
                            painter: Triangle(Colors.grey.shade500)),
                      ),
                      const SizedBox(height: 30),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _visiblebear = !_visiblebear;
                            randomNum = Random().nextInt(10);
                          });
                        },
                        icon: Image.asset(
                          'assets/alarmbearno.png',
                        ),
                        iconSize: 50,
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 100,
                              child: userProfileStream.when(
                                data: (data) => CachedNetworkImage(
                                  imageUrl: data.photoURL,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 70,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                error: (error, stackTrace) {
                                  // logger.d("error$error ");
                                  return const Image(
                                    image: AssetImage('assets/human.jpg'),
                                    height: 30,
                                  );
                                },
                                loading: () => const Loader(),
                              ),
                            ),
                            userProfileStream.when(
                              data: (data) => Text(
                                data.displayName,
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                              error: (error, stackTrace) {
                                // logger.d("error$error ");
                                return const Text(
                                  "no couple",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ),
                                );
                              },
                              loading: () => const Loader(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 100,
                              child: userCoupleProfileStream.when(
                                data: (data) => CachedNetworkImage(
                                  imageUrl: data.photoURL,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 70,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                error: (error, stackTrace) {
                                  // logger.d("error$error ");
                                  return const Image(
                                    image: AssetImage('assets/human.jpg'),
                                    height: 30,
                                  );
                                },
                                loading: () => const Loader(),
                              ),
                            ),
                            userCoupleProfileStream.when(
                              data: (data) => Text(
                                data.displayName,
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                              error: (error, stackTrace) {
                                // logger.d("error$error ");
                                return const Text(
                                  "no couple",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                );
                              },
                              loading: () => const Loader(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              endDrawer: ProfileDrawer(ref: ref),
            )
          : Scaffold(
              //singlechildscrollview 위젯이 이동한다
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: AppColors.myAppBarBackgroundPink,
                elevation: 0,
                title: Text(
                  AppLocalizations.of(context)!.connectto,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              backgroundColor: AppColors.myBackgroundPink,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "서로의 초대코드를 입력하면 연결돼요.",
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ref.watch(getMatchCodeFutureProvider).when(
                          data: (data) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "내 초대코드 (남은시간) ${toTick(data.time)}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  enabled: false,

                                  initialValue: data.vertifynumber.toString(),

                                  style: const TextStyle(
                                      fontSize: 40, color: Colors.white),
                                  maxLength: 6,
                                  // textInputAction: wow,반드시 설ㅓ할 것 enter누르면 편하니
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[900],
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    hintStyle: const TextStyle(
                                        fontSize: 30, color: Colors.white),
                                    focusColor: Colors.red,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            );
                          },
                          error: (error, stackTrace) => const Text("error"),
                          loading: () => const Loader(),
                        ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "상대의 초대코드를 전달받았나요?",
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          // textInputAction: wow,반드시 설ㅓ할 것
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty || value == "") {
                              return null;
                            } else {
                              if (value.length < 6 || value.length > 6
                                  // || value == wow
                                  ) {
                                return null;
                              }
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _honeyCodeController,
                          cursorColor: Colors.white,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[900],
                            labelText: '초대코드 입력',
                            labelStyle: const TextStyle(color: Colors.grey),

                            hintText: '000000',
                            hintStyle: const TextStyle(
                                fontSize: 30, color: Colors.grey),
                            focusColor: Colors.red,
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.black, width: 2.0),
                            // ),
                            // enabledBorder: const OutlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.green, width: 2.0),
                            // ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFD72499))),
                          onPressed: () {
                            // to delete
                            // ref
                            //     .watch(matchConrollerProvider.notifier)
                            //     .matchProcess();
                            if (_honeyCodeController.text.isNotEmpty) {
                              final int honeyCode =
                                  int.parse(_honeyCodeController.text);
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .watch(checkMatchProcessProvider(honeyCode))
                                    .when(
                                        data: (data) {
                                          if (data.uid.isNotEmpty) {
                                            ref
                                                .watch(matchConrollerProvider
                                                    .notifier)
                                                .matchCoupleIdProcessDone(
                                                    data.uid);
                                            logger.d(data.uid);
                                            // PEaTihL8yRdGEknlFfQ9F7XdoUt2 apple
                                            _honeyCodeController.clear();
                                            showSnackBar(context, "inviteed");
                                          }
                                        },
                                        error: (error, stacktrace) =>
                                            showSnackBar(
                                                context, "no invited honey"),
                                        loading: () => const Loader());
                              }
                            }
                          },
                          child:
                              Text(AppLocalizations.of(context)!.connectwith),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              endDrawer: ProfileDrawer(ref: ref),
            ),
      error: (error, stackTrace) {
        logger.d("error hasCoupleId  $error ");
        return const Center(child: Text('error'));
      },
      loading: () => const Loader(),
    );
  }

  // Future<void> _update() async {
  //   await showModalBottomSheet(
  //     backgroundColor: Colors.grey[900],
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext ctx) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //             top: 20,
  //             left: 20,
  //             right: 20,
  //             bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Form(
  //               key: _formKey,
  //               child: TextFormField(
  //                 cursorColor: Colors.white,
  //                 style: const TextStyle(color: Colors.white),
  //                 minLines: 5,
  //                 maxLines: 10,
  //                 keyboardType: TextInputType.multiline,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty || value == "") {
  //                     return 'Please enter some text';
  //                   }
  //                   return null;
  //                 },
  //                 autofocus: true,
  //                 autovalidateMode: AutovalidateMode.always,
  //                 controller: _messgaeController,
  //                 decoration: InputDecoration(
  //                   focusedBorder: const OutlineInputBorder(
  //                     borderSide: BorderSide(color: Colors.white, width: 2.0),
  //                   ),
  //                   enabledBorder: const OutlineInputBorder(
  //                     borderSide: BorderSide(color: Colors.white, width: 2.0),
  //                   ),
  //                   labelText: 'message at ${ref.read(selectedDate)}',
  //                   border: const OutlineInputBorder(),
  //                   labelStyle: const TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 isImageEmpty
  //                     ? ElevatedButton(
  //                         style: ButtonStyle(
  //                           backgroundColor:
  //                               MaterialStatePropertyAll(Colors.grey[900]),
  //                         ),
  //                         // child: const Text('Photo'),
  //                         child: const Icon(
  //                           Icons.photo_album_outlined,
  //                           size: 40,
  //                           color: Colors.white,
  //                         ),
  //                         onPressed: () async {
  //                           ImagePicker imagePicker = ImagePicker();
  //                           XFile? file = await imagePicker.pickImage(
  //                             source: ImageSource.gallery,
  //                             imageQuality: 15,
  //                           );
  //                           // logger.d('${file?.path}');

  //                           String uniqueFileName =
  //                               DateTime.now().toString().replaceAll(' ', '');

  //                           //Get a reference to storage root
  //                           Reference referenceRoot =
  //                               FirebaseStorage.instance.ref();
  //                           Reference referenceDirImages =
  //                               referenceRoot.child('images');

  //                           //Create a reference for the image to be stored
  //                           Reference referenceImageToUpload =
  //                               referenceDirImages.child(uniqueFileName);

  //                           //Handle errors/success
  //                           try {
  //                             //Store the file
  //                             await referenceImageToUpload
  //                                 .putFile(File(file!.path));
  //                             //Success: get the download URL
  //                             imageUrl =
  //                                 await referenceImageToUpload.getDownloadURL();

  //                             ref
  //                                 .watch(dailyControllerProvider.notifier)
  //                                 .updateDailyImage(imageUrl);
  //                           } catch (error) {
  //                             //Some error occurred
  //                           }
  //                         },
  //                       )
  //                     : Container(),
  //                 ElevatedButton(
  //                   style: const ButtonStyle(
  //                     backgroundColor:
  //                         MaterialStatePropertyAll(Color(0xFFD72499)),
  //                   ),
  //                   child: const Text('Edit'),
  //                   onPressed: () async {
  //                     if (_formKey.currentState!.validate()) {
  //                       showSnackBar(context, "message is edited");
  //                       final String message = _messgaeController.text;
  //                       ref
  //                           .watch(dailyControllerProvider.notifier)
  //                           .updateDailyMessage(message);

  //                       _messgaeController.clear();
  //                       Navigator.of(context).pop();
  //                     }
  //                   },
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
