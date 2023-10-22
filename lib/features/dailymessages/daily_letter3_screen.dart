import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/providers/providers.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';
import 'package:wakeuphoney/features/dailymessages/daily_letter_screen.dart';
import 'package:wakeuphoney/features/dailymessages/daily_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';

import '../../core/common/loader.dart';
import '../../core/constants/constants.dart';
import '../../core/constants/design_constants.dart';
import '../../core/utils.dart';
import 'daily_create_screen.dart';

class DailyLetter3Screen extends ConsumerStatefulWidget {
  static String routeName = "dailyletter3";
  static String routeURL = "/dailyletter3";
  const DailyLetter3Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DailyLetter3ScreenState();
}

class _DailyLetter3ScreenState extends ConsumerState<DailyLetter3Screen> {
  final String iOSId2 = 'ca-app-pub-5897230132206634/5936284276';
  final String androidId2 = 'ca-app-pub-5897230132206634/3350483532';

  BannerAd? _bannerAd;

  List allMessages = [];

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

  @override
  void initState() {
    super.initState();

    BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOSId2 : androidId2,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // logger.d('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> listDateTime =
        ref.watch(dateTimeNotTodayStateProvider);

    final listMessage =
        ref.watch(getDailyMessageListProvider).whenData((value) => value);

    final user = ref.watch(getUserProfileStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.myletters,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.myAppBarBackgroundPink,
        actions: const [
          // IconButton(
          //     onPressed: () {
          //       context.pushNamed(DailyLetterScreen.routeName);
          //     },
          //     icon: const Icon(
          //       Icons.connecting_airports_outlined,
          //       color: Color(0xFFD72499),
          //     ))
        ],
      ),
      backgroundColor: AppColors.myBackgroundPink,
      body: user.when(
        data: (data) => data.couples.isEmpty
            ? const Center(
                child: Text(
                  "Please invite, 상대를 초대해주세요.",
                  style: TextStyle(color: Colors.black),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    decoration: BoxDecoration(color: Colors.grey[700]),
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Text(
                  //       AppLocalizations.of(context)!.dafaultletter,
                  //       style: const TextStyle(
                  //         fontSize: 15,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Container(
                  //   height: 5,
                  // ),
                  // Container(
                  //   height: 1,
                  //   decoration: BoxDecoration(color: Colors.grey[900]),
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: const [
                  //     Padding(
                  //       padding: EdgeInsets.only(
                  //         left: 15,
                  //         top: 15,
                  //         bottom: 3,
                  //       ),
                  //       child: Text(
                  //         "Tomorrow",
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Container(
                    decoration:
                        const BoxDecoration(color: AppColors.myBackgroundPink),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height -
                              Constants.adbannerline,
                          child: ListView.builder(
                            itemCount: 100,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return listMessage.when(
                                data: (value) {
                                  var messageNow = value.singleWhere(
                                    (element) =>
                                        element.messagedate ==
                                        DateFormat.yMMMd()
                                            .format(listDateTime[index]),
                                    orElse: () => DailyMessageModel(
                                      message: "메세지를 적어주세요",
                                      messagedate: "messagedate",
                                      messagedatetime: DateTime.now(),
                                      time: DateTime.now(),
                                      sender: "",
                                      reciver: "",
                                      photo: "",
                                      audio: "",
                                      video: "",
                                    ),
                                  );
                                  return messageNow.message != "메세지를 적어주세요"
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: data.photoURL,
                                                        fit: BoxFit.fill,
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          height: 50,
                                                        ),
                                                        width: 50,
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        data.displayName,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  const Icon(Icons.more_vert),
                                                  // IconButton(
                                                  //   onPressed: () {},
                                                  //   icon:
                                                  //       const Icon(Icons.more_vert),
                                                  //   color: Colors.white,
                                                  // )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: InteractiveViewer(
                                                child: messageNow
                                                        .photo.isNotEmpty
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            messageNow.photo,
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          height: 70,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      )
                                                    : Container(),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 10, right: 10),
                                              child: ListTile(
                                                tileColor: Colors.black,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                title: Text(
                                                  messageNow.message,
                                                  // "wow",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  DateFormat.MMMd().format(
                                                      listDateTime[index]),
                                                  style: TextStyle(
                                                      color: Colors.grey[700]),
                                                ),
                                                onTap: () {
                                                  ref
                                                          .read(selectedDate
                                                              .notifier)
                                                          .state =
                                                      DateFormat.yMMMd().format(
                                                          listDateTime[index]);
                                                  bool isImageEmpty =
                                                      messageNow.photo.isEmpty;
                                                  _update(isImageEmpty);
                                                  _messgaeController.text =
                                                      messageNow.message;
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Container(
                                              height: 1,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[800]),
                                            ),
                                            // SizedBox(
                                            //   width:
                                            //       MediaQuery.of(context).size.width - 40,
                                            //   child: messageNow.photo.isNotEmpty
                                            //       ? Image.network(messageNow.photo)
                                            //       : Container(),
                                            // ),

                                            // SizedBox(
                                            //   child: GestureDetector(
                                            //     onTap: () {
                                            //       selectBannerImage();
                                            //     },
                                            //     child: Container(
                                            //       width: double.infinity,
                                            //       decoration: BoxDecoration(
                                            //         borderRadius:
                                            //             BorderRadius.circular(10),
                                            //       ),
                                            //       child: bannerFile != null
                                            //           ? Image.file(bannerFile!)
                                            //           : messageNow.photo.isEmpty ||
                                            //                   messageNow.photo ==
                                            //                       Constants.bannerDefault
                                            //               ? const Center(
                                            //                   child: Icon(
                                            //                     Icons.camera_alt_outlined,
                                            //                     size: 40,
                                            //                     color: Colors.white,
                                            //                   ),
                                            //                 )
                                            //               : Image.network(
                                            //                   messageNow.photo),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                value
                                                    .singleWhere(
                                                      (element) =>
                                                          element.messagedate ==
                                                          DateFormat.yMMMd()
                                                              .format(
                                                                  listDateTime[
                                                                      index]),
                                                      orElse: () =>
                                                          DailyMessageModel(
                                                        message: "메세지를 적어주세요",
                                                        messagedate:
                                                            "messagedate",
                                                        messagedatetime:
                                                            DateTime.now(),
                                                        time: DateTime.now(),
                                                        sender: "",
                                                        reciver: "",
                                                        photo: "",
                                                        audio: "",
                                                        video: "",
                                                      ),
                                                    )
                                                    .message,
                                                // "wow",
                                                style: TextStyle(
                                                    color: Colors.grey[800]),
                                              ),
                                              subtitle: Text(
                                                DateFormat.MMMd().format(
                                                    listDateTime[index]),
                                                style: TextStyle(
                                                    color: Colors.grey[800]),
                                              ),
                                              onTap: () {
                                                ref
                                                    .read(selectedDate.notifier)
                                                    .state = DateFormat
                                                        .yMMMd()
                                                    .format(
                                                        listDateTime[index]);
                                                ref
                                                    .read(selectedDateTime
                                                        .notifier)
                                                    .state = DateTime
                                                        .now()
                                                    .add(Duration(
                                                        seconds: 24 * 60 * 60 -
                                                            DateTime.now()
                                                                    .hour *
                                                                3600 -
                                                            DateTime.now()
                                                                    .minute *
                                                                60 -
                                                            DateTime.now()
                                                                .second))
                                                    .add(Duration(days: index));
                                                // _create(uid);
                                                context.pushNamed(
                                                    DailyLetterCreateScreen
                                                        .routeName);

                                                _messgaeController.clear();
                                              },
                                            ),
                                            Container(
                                              height: 1,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[800]),
                                            ),
                                          ],
                                        );
                                },
                                error: (error, stackTrace) {
                                  // logger.d("error$error ");
                                  return null;
                                },
                                loading: () => const Loader(),
                              );
                            },
                          ),
                        ),
                        if (_bannerAd != null)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: _bannerAd!.size.width.toDouble(),
                              height: _bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd!),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
        error: (error, stackTrace) {
          return const Row(
            children: [
              Image(
                image: AssetImage('assets/human.jpg'),
                height: 50,
              ),
              Text("error, please close app and open app")
            ],
          );
        },
        loading: () => const Loader(),
      ),
    );
  }

  Future<void> _update(bool isImageEmpty) async {
    await showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
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
                  autovalidateMode: AutovalidateMode.always,
                  controller: _messgaeController,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
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
                  isImageEmpty
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.grey[900]),
                          ),
                          // child: const Text('Photo'),
                          child: const Icon(
                            Icons.photo_album_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 15,
                            );
                            // logger.d('${file?.path}');

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
                                  .putFile(File(file!.path));
                              //Success: get the download URL
                              imageUrl =
                                  await referenceImageToUpload.getDownloadURL();

                              ref
                                  .watch(dailyControllerProvider.notifier)
                                  .updateDailyImage(imageUrl);
                            } catch (error) {
                              //Some error occurred
                            }
                          },
                        )
                      : Container(),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFFD72499)),
                    ),
                    child: const Text('Edit'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showSnackBar(context, "message is edited");
                        final String message = _messgaeController.text;
                        ref
                            .watch(dailyControllerProvider.notifier)
                            .updateDailyMessage(message);

                        _messgaeController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
