import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';

import '../../core/common/loader.dart';
import '../../core/constants/constants.dart';
import '../../core/constants/design_constants.dart';
import '../../core/providers/providers.dart';
import '../profile/profile_controller.dart';
import 'letter_date_screen.dart';
import 'letter_day_pick_screen.dart';

class LetterScreen extends ConsumerStatefulWidget {
  static String routeName = "letter_screen";
  static String routeURL = "/letter_screen";
  const LetterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LetterScreenState();
}

class _LetterScreenState extends ConsumerState<LetterScreen> {
  var logger = Logger();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _letterEditController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  File? letterEditImageFile;
  String editImageUrl = "";
  bool isLoading = false;
  void pickEditImage() async {
    final letterEditImagePicked = await pickImage();

    if (letterEditImagePicked != null) {
      setState(() {
        letterEditImageFile = File(letterEditImagePicked.files.first.path!);
      });
      String uniqueEditImageName = DateTime.now().toString();
      Reference refRoot = ref.watch(storageProvider).ref();
      Reference refDirEditImage = refRoot.child('images');
      Reference refEditImageToUpload =
          refDirEditImage.child(uniqueEditImageName);
      try {
        await refEditImageToUpload.putFile(File(letterEditImageFile!.path));
        editImageUrl = await refEditImageToUpload.getDownloadURL();
        ref
            .watch(dailyControllerProvider.notifier)
            .updateDailyImage(editImageUrl);
      } catch (e) {
        setState(() {
          isLoading = false;
          logger.e(e.toString());
        });
      }
    }
  }

  // final String iOSId2 = 'ca-app-pub-5897230132206634/5936284276';
  // final String androidId2 = 'ca-app-pub-5897230132206634/3350483532';
  // BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();

    // BannerAd(
    //   size: AdSize.banner,
    //   adUnitId: Platform.isIOS ? iOSId2 : androidId2,
    //   listener: BannerAdListener(
    //     onAdLoaded: (ad) {
    //       setState(() {
    //         _bannerAd = ad as BannerAd;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, err) {
    //       // logger.d('Failed to load a banner ad: ${err.message}');
    //       ad.dispose();
    //     },
    //   ),
    //   request: const AdRequest(),
    // ).load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //필요 데이터 프로필, 메세지, 이름, 날짜 등  개인정보와 메세지 정보
    final userInfo = ref.watch(getMyUserInfoProvider);

    final lettersList = ref.watch(getLettersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('우리 편지'),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(LetterDateScreen.routeName);
              },
              icon: const Icon(
                Icons.looks_two_outlined,
                color: Color(0xFFD72499),
              ))
        ],
      ),
      body: userInfo.when(
        data: (user) {
          return user.couples.isEmpty
              ? const Center(
                  child: Text(
                    "프로필 페이지에서 상대를 초대해주세요.",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      lettersList.when(
                        data: (data) {
                          return Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height -
                                    Constants.bottomNavBarLine,
                                child: ListView.builder(
                                  itemCount: data.length,
                                  controller: _scrollController,
                                  key: const PageStorageKey<String>("page"),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: user.photoURL,
                                                      fit: BoxFit.fill,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        height: 40,
                                                      ),
                                                      width: 40,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  Text(user.displayName),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    data[index].messagedate,
                                                  ),
                                                  data[index]
                                                          .messagedatetime
                                                          .isAfter(
                                                              DateTime.now())
                                                      ? PopupMenuButton(
                                                          itemBuilder:
                                                              ((context) {
                                                          return [
                                                            PopupMenuItem(
                                                              onTap: () {
                                                                bool
                                                                    isImageEmpty =
                                                                    data[index]
                                                                        .photo
                                                                        .isEmpty;

                                                                _update(
                                                                    isImageEmpty);
                                                                _letterEditController
                                                                        .text =
                                                                    data[index]
                                                                        .message;
                                                              },
                                                              child: const Text(
                                                                  "수정하기"),
                                                            ),
                                                            PopupMenuItem(
                                                              onTap: () {
                                                                ref
                                                                    .watch(selectedDate
                                                                        .notifier)
                                                                    .state = data[
                                                                        index]
                                                                    .messagedate;

                                                                ref
                                                                    .watch(dailyControllerProvider
                                                                        .notifier)
                                                                    .deleteDailyMessage();

                                                                showSnackBar(
                                                                    context,
                                                                    '삭제되었습니다.');
                                                              },
                                                              child: const Text(
                                                                  "삭제하기"),
                                                            ),
                                                          ];
                                                        }))
                                                      : IconButton(
                                                          onPressed: () {
                                                            showSnackBar(
                                                                context,
                                                                '과거는 그대로 간직해요');
                                                          },
                                                          icon: const Icon(
                                                              Icons.more_vert))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 57,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      60,
                                                  child: SelectableText(
                                                      data[index].message)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: InteractiveViewer(
                                            child: data[index].photo.isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl: data[index].photo,
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: 70,
                                                    ),
                                                    height: 300,
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 42.0),
                                          child:
                                              data[index]
                                                      .messagedatetime
                                                      .isAfter(DateTime.now())
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  showSnackBar(
                                                                      context,
                                                                      "사랑해");
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .favorite_outline)),
                                                            data[index]
                                                                    .photo
                                                                    .isEmpty
                                                                ? IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      pickEditImage();
                                                                      String
                                                                          uniqueEditImageName =
                                                                          DateTime.now()
                                                                              .toString();
                                                                      Reference refRoot = ref
                                                                          .watch(
                                                                              storageProvider)
                                                                          .ref();
                                                                      Reference
                                                                          refDirEditImage =
                                                                          refRoot
                                                                              .child('images');
                                                                      Reference
                                                                          refEditImageToUpload =
                                                                          refDirEditImage
                                                                              .child(uniqueEditImageName);
                                                                      try {
                                                                        await refEditImageToUpload
                                                                            .putFile(File(letterEditImageFile!.path));
                                                                        editImageUrl =
                                                                            await refEditImageToUpload.getDownloadURL();
                                                                        ref.watch(dailyControllerProvider.notifier).updateDailyImage(
                                                                            editImageUrl);
                                                                      } catch (e) {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              false;
                                                                          logger
                                                                              .e(e.toString());
                                                                        });
                                                                      }
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .image_outlined))
                                                                : Container(),
                                                            IconButton(
                                                                onPressed: () {
                                                                  bool
                                                                      isImageEmpty =
                                                                      data[index]
                                                                          .photo
                                                                          .isEmpty;
                                                                  ref
                                                                      .watch(selectedDate
                                                                          .notifier)
                                                                      .state = data[
                                                                          index]
                                                                      .messagedate;
                                                                  _update(
                                                                      isImageEmpty);
                                                                  _letterEditController
                                                                      .text = data[
                                                                          index]
                                                                      .message;
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .mode_edit_outlined)),

                                                            // IconButton(
                                                            //   onPressed: () {
                                                            //     showSnackBar(
                                                            //         context, "1분 녹음하기");
                                                            //   },
                                                            //   icon: const Icon(
                                                            //       CupertinoIcons.mic),
                                                            // ),
                                                          ],
                                                        ),
                                                        // IconButton(
                                                        //     onPressed: () {
                                                        //       showSnackBar(context, "삭제되었습니다.");
                                                        //     },
                                                        //     icon: const Icon(
                                                        //         Icons.delete_outline)),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: const Icon(
                                                                    Icons
                                                                        .favorite_outline)),
                                                            IconButton(
                                                                onPressed: () {
                                                                  showSnackBar(
                                                                      context,
                                                                      "답장은 당일만 할 수 있어요");
                                                                },
                                                                icon: const Icon(
                                                                    CupertinoIcons
                                                                        .chat_bubble)),
                                                            // IconButton(
                                                            //     onPressed: () {
                                                            //       showSnackBar(context, "듣기");
                                                            //     },
                                                            //     icon: const Icon(
                                                            //         CupertinoIcons.speaker_1)),
                                                          ],
                                                        ),
                                                        // IconButton(
                                                        //   onPressed: () {
                                                        //     showSnackBar(
                                                        //         context, "과거는 그대로 간직해요");
                                                        //   },
                                                        //   icon: const Icon(
                                                        //       CupertinoIcons.bookmark),
                                                        // ),
                                                      ],
                                                    ),
                                        ),
                                        // Container(
                                        //   height: 1,
                                        //   decoration:
                                        //       BoxDecoration(color: Colors.grey[700]),
                                        // ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                        error: (error, stackTrace) {
                          logger.d("error$error ");
                          return const Center(
                            child: Text(
                              "주고 받은 편지가 없어요",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          );
                        },
                        loading: () => const Loader(),
                      )
                    ],
                  ),
                );
        },
        error: (error, stackTrace) {
          logger.d("error$error ");
          return const Center(
            child: Text(
              "사용자를 찾을 수 없어요",
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          );
        },
        loading: () => const Loader(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => context.pushNamed(LetterDayPickScreen.routeName),
              backgroundColor: AppColors.myPink,
              child: const Icon(
                Icons.add,
                size: 29,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _update(bool isImageEmpty) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formkey,
                child: TextFormField(
                  minLines: 3,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty || value == '') {
                      return '내용을 적어주세요';
                    }
                    return null;
                  },
                  controller: _letterEditController,
                  autofocus: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        showSnackBar(context, "메세지가 수정되었습니다.");
                        ref
                            .watch(dailyControllerProvider.notifier)
                            .updateDailyMessage(_letterEditController.text);
                        _letterEditController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('수정'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}