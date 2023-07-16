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
import 'package:wakeuphoney/features/dailymessages/daily_model.dart';

import '../../core/common/loader.dart';
import '../../core/providers/firebase_providers.dart';
import '../../core/utils.dart';
import 'couple_letter_screen.dart';
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
  final String iOSTestId = 'ca-app-pub-5897230132206634/3120978311';
  final String androidTestId = 'ca-app-pub-3940256099942544/6300978111';

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

    // BannerAd(
    //   size: AdSize.banner,
    //   adUnitId: Platform.isIOS ? iOSTestId : androidTestId,
    //   listener: BannerAdListener(
    //     onAdLoaded: (ad) {
    //       setState(() {
    //         _bannerAd = ad as BannerAd;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, err) {
    //       print('Failed to load a banner ad: ${err.message}');
    //       ad.dispose();
    //     },
    //   ),
    //   request: const AdRequest(),
    // ).load();
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(authProvider).currentUser!.uid;

    final List<DateTime> listDateTime =
        ref.watch(dateTimeNotTodayStateProvider);

    final listMessage =
        ref.watch(getDailyMessageListProvider).whenData((value) => value);

    List<int> list = [1, 2, 3, 4, 6, 5];
    list.sort(
      (a, b) => a.compareTo(b),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Letters"),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(CoupleLetterScreen.routeName);
              },
              icon: const Icon(
                Icons.connecting_airports_outlined,
                color: Color(0xFFD72499),
              ))
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[700]),
          ),
          Container(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text(
                "Default Message",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            height: 5,
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[900]),
          ),
          const SizedBox(
            height: 5,
          ),
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
            decoration: const BoxDecoration(color: Colors.black),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 220,
              child: ListView.builder(
                itemCount: 100,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return listMessage.when(
                    data: (value) {
                      var messageNow = value.singleWhere(
                        (element) =>
                            element.messagedate ==
                            DateFormat.yMMMd().format(listDateTime[index]),
                        orElse: () => DailyMessageModel(
                          message: "no message",
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
                      return messageNow.message != "no message"
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: GestureDetector(
                                      onTap: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        XFile? file =
                                            await imagePicker.pickImage(
                                                source: ImageSource.gallery);
                                        print('${file?.path}');

                                        String uniqueFileName = DateTime.now()
                                            .toString()
                                            .replaceAll(' ', '');

                                        //Get a reference to storage root
                                        Reference referenceRoot =
                                            FirebaseStorage.instance.ref();
                                        Reference referenceDirImages =
                                            referenceRoot.child('images');

                                        //Create a reference for the image to be stored
                                        Reference referenceImageToUpload =
                                            referenceDirImages
                                                .child(uniqueFileName);

                                        //Handle errors/success
                                        try {
                                          //Store the file
                                          await referenceImageToUpload
                                              .putFile(File(file!.path));
                                          //Success: get the download URL
                                          imageUrl =
                                              await referenceImageToUpload
                                                  .getDownloadURL();
                                          ref
                                                  .read(selectedDate.notifier)
                                                  .state =
                                              DateFormat.yMMMd()
                                                  .format(listDateTime[index]);
                                          ref
                                              .watch(dailyControllerProvider
                                                  .notifier)
                                              .updateDailyImage(imageUrl);
                                        } catch (error) {
                                          //Some error occurred
                                        }
                                      },
                                      child: messageNow.photo.isNotEmpty
                                          ? Image.network(messageNow.photo)
                                          : Container(),
                                    ),
                                  ),
                                  ListTile(
                                    tileColor: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    title: Text(
                                      messageNow.message,
                                      // "wow",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Text(
                                      DateFormat.MMMd()
                                          .format(listDateTime[index]),
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                    onTap: () {
                                      ref.read(selectedDate.notifier).state =
                                          DateFormat.yMMMd()
                                              .format(listDateTime[index]);
                                      bool isImageEmpty =
                                          messageNow.photo.isEmpty;
                                      _update(uid, isImageEmpty);
                                      _messgaeController.text =
                                          messageNow.message;
                                    },
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
                                  Container(
                                    height: 1,
                                    decoration:
                                        BoxDecoration(color: Colors.grey[800]),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      value
                                          .singleWhere(
                                            (element) =>
                                                element.messagedate ==
                                                DateFormat.yMMMd().format(
                                                    listDateTime[index]),
                                            orElse: () => DailyMessageModel(
                                              message: "no message",
                                              messagedate: "messagedate",
                                              messagedatetime: DateTime.now(),
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
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                    subtitle: Text(
                                      DateFormat.MMMd()
                                          .format(listDateTime[index]),
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                    onTap: () {
                                      ref.read(selectedDate.notifier).state =
                                          DateFormat.yMMMd()
                                              .format(listDateTime[index]);
                                      ref
                                              .read(selectedDateTime.notifier)
                                              .state =
                                          DateTime.now()
                                              .add(Duration(
                                                  seconds: 24 * 60 * 60 -
                                                      DateTime.now().hour *
                                                          3600 -
                                                      DateTime.now().minute *
                                                          60 -
                                                      DateTime.now().second))
                                              .add(Duration(days: index));
                                      // _create(uid);
                                      context.pushNamed(
                                          DailyLetterCreateScreen.routeName);

                                      _messgaeController.clear();
                                    },
                                  ),
                                  Container(
                                    height: 1,
                                    decoration:
                                        BoxDecoration(color: Colors.grey[800]),
                                  ),
                                ],
                              ),
                            );
                    },
                    error: (error, stackTrace) {
                      print("error$error ");
                      return null;
                    },
                    loading: () => const Loader(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.symmetric(),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       if (_bannerAd != null)
      //         Align(
      //           alignment: Alignment.bottomCenter,
      //           child: SizedBox(
      //             width: _bannerAd!.size.width.toDouble(),
      //             height: _bannerAd!.size.height.toDouble(),
      //             child: AdWidget(ad: _bannerAd!),
      //           ),
      //         ),
      //     ],
      //   ),
      // ),
    );
  }

  Future<void> _create(String uid) async {
    await showModalBottomSheet(
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
                  controller: _messgaeController,
                  decoration: InputDecoration(
                    labelText: 'message at ${ref.read(selectedDate)}',
                    border: const OutlineInputBorder(),
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
                    onTap: selectBannerImage,
                    child: bannerFile != null
                        ? SizedBox(
                            height: 30,
                            width: 30,
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
                            // color: Colors.white,
                          ),
                    // onPressed: () async {
                    // setState(() {});
                    // ImagePicker imagePicker = ImagePicker();
                    // XFile? file = await imagePicker.pickImage(
                    //     source: ImageSource.gallery);
                    // print('${file?.path}');

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
                        showSnackBar(context, "messgae is saved");
                        Navigator.of(context).pop();
                        final String message = _messgaeController.text;

                        //메세지 작성
                        ref
                            .watch(dailyControllerProvider.notifier)
                            .createDailyMessageImage(message, imageUrl);
                      }

                      _messgaeController.clear();
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

  Future<void> _update(String uid, bool isImageEmpty) async {
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
                                source: ImageSource.gallery);
                            print('${file?.path}');

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
                            .updateDailyMessage(message, uid);

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

class _FutureList extends StatelessWidget {
  _FutureList({
    required this.listDateTime,
    required this.ref,
    required this.listMessage,
    required TextEditingController messgaeController,
  });

  final List<DateTime> listDateTime;
  final WidgetRef ref;
  final AsyncValue<List<DailyMessageModel>> listMessage;
  final TextEditingController _messgaeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.62,
        child: ListView.builder(
          itemCount: 100,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return listMessage.when(
              data: (value) {
                return value
                            .singleWhere(
                              (element) =>
                                  element.messagedate ==
                                  DateFormat.yMMMd()
                                      .format(listDateTime[index]),
                              orElse: () => DailyMessageModel(
                                message: "no message",
                                messagedate: "messagedate",
                                messagedatetime: DateTime.now(),
                                time: DateTime.now(),
                                sender: "",
                                reciver: "",
                                photo: "",
                                audio: "",
                                video: "",
                              ),
                            )
                            .message !=
                        "no message"
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          tileColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          title: Text(
                            value
                                .singleWhere(
                                  (element) =>
                                      element.messagedate ==
                                      DateFormat.yMMMd()
                                          .format(listDateTime[index]),
                                  orElse: () => DailyMessageModel(
                                    message: "no message",
                                    messagedate: "messagedate",
                                    messagedatetime: DateTime.now(),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat.MMMd().format(listDateTime[index]),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            ref.read(selectedDate.notifier).state =
                                DateFormat.yMMMd().format(listDateTime[index]);
                            // _update(uid);
                            // _messgaeController.text = message.message;
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          title: Text(
                            value
                                .singleWhere(
                                  (element) =>
                                      element.messagedate ==
                                      DateFormat.yMMMd()
                                          .format(listDateTime[index]),
                                  orElse: () => DailyMessageModel(
                                    message: "no message",
                                    messagedate: "messagedate",
                                    messagedatetime: DateTime.now(),
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
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          subtitle: Text(
                            DateFormat.MMMd().format(listDateTime[index]),
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      );
              },
              error: (error, stackTrace) {
                print("error$error ");
                return null;
              },
              loading: () => const Loader(),
            );
          },
        ),
      ),
    );
  }
}