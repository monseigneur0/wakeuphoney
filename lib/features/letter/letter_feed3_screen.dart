import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/common/loader.dart';
import '../dailymessages/daily_controller.dart';
import '../profile/profile_controller.dart';

class LetterFeed3Screen extends ConsumerStatefulWidget {
  static String routeName = "letterfeed3screen";
  static String routeURL = "/letterfeed3screen";
  const LetterFeed3Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterFeed3ScreenState();
}

class _LetterFeed3ScreenState extends ConsumerState<LetterFeed3Screen> {
  Logger logger = Logger();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _containerKey = GlobalKey();
  Size? _getSize() {
    if (_containerKey.currentContext == null) return null;
    final RenderBox renderBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return size;
  }

  Size? cardSize;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        cardSize = _getSize();
      });
      logger.d(cardSize);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(getMyUserInfoProvider);

    final letterList = ref.watch(getLettersListProvider);
    final answerList = ref.watch(getAnswersListProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("우리의 편지3"),
      ),
      body: userInfo.when(
          data: (user) {
            return letterList.when(
                data: (letter) {
                  return ListView.builder(
                    controller: _scrollController,
                    key: const PageStorageKey<String>("page"),

                    itemCount: letter
                        .where((element) => element.isLetter == true)
                        .length,
                    // separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return Container(
                        // color: index % 2 == 0 ? Colors.green : Colors.blue,
                        child: Column(
                          children: [
                            20.heightBox,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TimeBar(
                                //   cardSize: cardSize,
                                // ),
                                Column(
                                  key: index == 0 ? _containerKey : null,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    letter[index]
                                        .messagedate
                                        .text
                                        .size(20)
                                        .make(),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(8,
                                                8), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: CachedNetworkImage(
                                                    width: 60,
                                                    imageUrl: user.photoURL
                                                        .toString()),
                                              ),
                                              10.widthBox,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            160,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        user.displayName.text
                                                            .size(20)
                                                            .make(),
                                                        PopupMenuButton(
                                                          itemBuilder:
                                                              (context) {
                                                            return [
                                                              const PopupMenuItem(
                                                                child:
                                                                    Text("삭제"),
                                                              ),
                                                              const PopupMenuItem(
                                                                child:
                                                                    Text("수정"),
                                                              ),
                                                            ];
                                                          },
                                                        ).box.height(32).make(),
                                                      ],
                                                    ),
                                                  ),
                                                  letter[index]
                                                      .message
                                                      .text
                                                      .size(20)
                                                      .make()
                                                      .box
                                                      .width(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              160)
                                                      .make(),
                                                ],
                                              ),
                                            ],
                                          ),
                                          10.heightBox,
                                          letter[index].photo.isEmpty
                                              ? Container()
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.grey,
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: CachedNetworkImage(
                                                    imageUrl: letter[index]
                                                        .photo
                                                        .toString(),
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: 70,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            90,
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                          letter.where((element) {
                                            return (element.messagedate ==
                                                    letter[index].messagedate &&
                                                element.isLetter == false);
                                          }).isEmpty
                                              ? Container()
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.grey.shade200,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: const Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child: CachedNetworkImage(
                                                                width: 40,
                                                                imageUrl: user
                                                                    .couplePhotoURL
                                                                    .toString()),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              user.coupleDisplayName!
                                                                  .text
                                                                  .size(16)
                                                                  .make(),
                                                              letter
                                                                  .where(
                                                                      (element) {
                                                                    return (element.messagedate ==
                                                                            letter[index]
                                                                                .messagedate &&
                                                                        element.isLetter ==
                                                                            false);
                                                                  })
                                                                  .first
                                                                  .message
                                                                  .text
                                                                  .make()
                                                                  .box
                                                                  .width(MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      190)
                                                                  .make(),
                                                            ],
                                                          ).pSymmetric(h: 10),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            90,
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: letter
                                                                .where(
                                                                    (element) {
                                                                  return (element
                                                                              .messagedate ==
                                                                          letter[index]
                                                                              .messagedate &&
                                                                      element.isLetter ==
                                                                          false);
                                                                })
                                                                .first
                                                                .photo
                                                                .isEmpty
                                                            ? Container()
                                                            : CachedNetworkImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                imageUrl: letter
                                                                    .where(
                                                                        (element) {
                                                                      return (element.messagedate ==
                                                                              letter[index]
                                                                                  .messagedate &&
                                                                          element.isLetter ==
                                                                              false);
                                                                    })
                                                                    .first
                                                                    .photo
                                                                    .toString()),
                                                      ),
                                                    ],
                                                  ).p(20),
                                                ).pSymmetric(v: 20),
                                          answerList.when(
                                              data: (answer) {
                                                if (!answer
                                                    .singleWhere((element) =>
                                                        element.messagedate ==
                                                        letter[index]
                                                            .messagedate)
                                                    .isLetter!) {
                                                  return Container();
                                                }
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.grey.shade200,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: const Offset(0,
                                                            1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child: CachedNetworkImage(
                                                                width: 40,
                                                                imageUrl: user
                                                                    .couplePhotoURL
                                                                    .toString()),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              user.coupleDisplayName!
                                                                  .text
                                                                  .size(16)
                                                                  .make(),
                                                              answer
                                                                  .where((element) =>
                                                                      element
                                                                          .messagedate ==
                                                                      letter[index]
                                                                          .messagedate)
                                                                  .first
                                                                  .message
                                                                  .text
                                                                  .make()
                                                                  .box
                                                                  .width(MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      190)
                                                                  .make(),
                                                            ],
                                                          ).pSymmetric(h: 10),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            90,
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: CachedNetworkImage(
                                                            fit: BoxFit.fill,
                                                            imageUrl: answer
                                                                    .singleWhere((element) =>
                                                                        element
                                                                            .messagedate ==
                                                                        letter[index]
                                                                            .messagedate)
                                                                    .photo
                                                                    .isEmpty
                                                                ? ""
                                                                : answer
                                                                    .singleWhere((element) =>
                                                                        element
                                                                            .messagedate ==
                                                                        letter[index]
                                                                            .messagedate)
                                                                    .photo
                                                                    .toString()),
                                                      ),
                                                    ],
                                                  ).p(20),
                                                ).pSymmetric(v: 20);
                                              },
                                              error: (error, stackTrace) {
                                                logger.e(error.toString());
                                                return const Center(
                                                  child: Text(
                                                      "사용자를 찾을 수 없어요 \n 다시 접속해주세요."),
                                                );
                                              },
                                              loading: () => const Loader())
                                        ],
                                      ).p(20),
                                    ).pOnly(right: 10),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ).pOnly(left: 20),
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  logger.e(error.toString());
                  return const Center(
                    child: Text("사용자를 찾을 수 없어요 \n 다시 접속해주세요."),
                  );
                },
                loading: () => const Loader());
          },
          error: (error, stackTrace) {
            logger.e(error.toString());
            return const Center(
              child: Text("사용자를 찾을 수 없어요 \n 다시 접속해주세요."),
            );
          },
          loading: () => const Loader()),
    );
  }
}

class TimeBar extends StatelessWidget {
  final Size? cardSize;
  const TimeBar({
    super.key,
    this.cardSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 10,
          height: 30,
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.black),
            ),
          ),
        ).pSymmetric(h: 15),
        Transform.translate(
          offset: const Offset(0, -10),
          child: Container(
            width: 2,
            height: cardSize?.height.toDouble() ??
                (MediaQuery.of(context).size.width * 1.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
