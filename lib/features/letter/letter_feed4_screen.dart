import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/letter/letter_controller.dart';

import '../../core/common/loader.dart';
import '../dailymessages/letter_day_screen.dart';
import '../profile/profile_controller.dart';

class LetterFeed4Screen extends ConsumerStatefulWidget {
  const LetterFeed4Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterFeed4ScreenState();
}

class _LetterFeed4ScreenState extends ConsumerState<LetterFeed4Screen> {
  Logger logger = Logger();

  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(getMyUserInfoProvider);

    final lettersList = ref.watch(getLettersListProvider);

    return Scaffold(
      backgroundColor: Vx.gray100,
      // appBar: AppBar(
      //   title: const Text("Letter Feed 4"),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         context.pushNamed(LetterDayScreen.routeName);
      //       },
      //       icon: const Icon(Icons.add),
      //     ),
      //   ],
      // ),
      body: userInfo.when(data: (user) {
        return lettersList.when(
            data: (letters) {
              return ListView.builder(
                itemCount: letters.length,
                controller: _scrollController,
                key: const PageStorageKey("page"),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      10.heightBox,
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateFormat("MM월 dd일 ")
                                  .format(letters[index].letterTime)
                                  .toString()
                                  .text
                                  .size(20)
                                  .make()
                                  .pSymmetric(h: 10),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(8, 8))
                                    ]),
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
                                                //이미지 왜 이렇게 큼?!?!
                                                width: 60,
                                                imageUrl: user.photoURL)),
                                        10.widthBox,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
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
                                                    itemBuilder: (context) {
                                                      return [
                                                        PopupMenuItem(
                                                          onTap: () {},
                                                          child:
                                                              const Text("수정"),
                                                        ),
                                                        PopupMenuItem(
                                                          onTap: () {},
                                                          child:
                                                              const Text("삭제"),
                                                        ),
                                                      ];
                                                    },
                                                  ).box.height(32).make(),
                                                ],
                                              ),
                                            ),
                                            letters[index]
                                                .letter
                                                .toString()
                                                .text
                                                .size(14)
                                                .make()
                                                .box
                                                .width(MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    140)
                                                .make(),
                                          ],
                                        )
                                      ],
                                    ),
                                    10.heightBox,
                                    letters[index].letterPhoto.isEmpty
                                        ? Container()
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.grey,
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: CachedNetworkImage(
                                              imageUrl: letters[index]
                                                  .letterPhoto
                                                  .toString(),
                                              placeholder: (context, url) =>
                                                  Container(
                                                height: 70,
                                              ),
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  90,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                    letters[index].answer.isEmpty
                                        ? Container()
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                90,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      child: CachedNetworkImage(
                                                          width: 50,
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
                                                        letters[index]
                                                            .answer
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
                                                5.heightBox,
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90,
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: letters[index]
                                                          .answerPhoto
                                                          .isEmpty
                                                      ? Container()
                                                      : CachedNetworkImage(
                                                          fit: BoxFit.fill,
                                                          imageUrl:
                                                              letters[index]
                                                                  .answerPhoto
                                                                  .toString()),
                                                ),
                                              ],
                                            ).p(15),
                                          ).pSymmetric(v: 20),
                                  ],
                                ).p(15),
                              ).pOnly(left: 15),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ).p(10);
                },
              );
            },
            loading: () => const Loader(),
            error: (error, stack) {
              logger.e(error.toString());
              return const Center(
                child: Text("사용자를 찾을 수 없어요 \n 다시 접속해주세요."),
              );
            });
      }, loading: () {
        return const Loader();
      }, error: (error, stack) {
        logger.e(error.toString());
        return const Center(
          child: Text("사용자를 찾을 수 없어요 \n 다시 접속해주세요."),
        );
      }),
    );
  }
}
