import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/core/utils.dart';

import '../../core/common/loader.dart';
import '../profile/profile_controller.dart';
import 'wake_controller.dart';

class WakeYouFeedScreen extends ConsumerStatefulWidget {
  const WakeYouFeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WakeYouFeedScreenState();
}

class _WakeYouFeedScreenState extends ConsumerState<WakeYouFeedScreen> {
  Logger logger = Logger();

  final _scrollController = ScrollController();

  final TextEditingController _letterEditController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(getMyUserInfoProvider);
    // final wakesList = ref.watch(getWakeUpwakesListProvider);
    final wakesList = ref.watch(getWakesListProvider);

    return Scaffold(
      body: userInfo.when(data: (user) {
        return wakesList.when(
            data: (wakes) {
              if (wakes.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.noletter,
                    // "아직 서로 깨워주지 않으셨네요.",
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }
              return Skeletonizer(
                enabled: wakes.isEmpty,
                child: ListView.builder(
                  itemCount: wakes.length,
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
                                DateFormat("MM/dd")
                                    .format(wakes[index].alarmTime)
                                    .toString()
                                    .text
                                    .make()
                                    .pSymmetric(h: 14),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(8, 8))
                                      ]),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          user.uid == wakes[index].senderUid
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: CachedNetworkImage(
                                                      width: 45,
                                                      imageUrl: user.photoURL))
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: CachedNetworkImage(
                                                      width: 45,
                                                      imageUrl:
                                                          user.couplePhotoURL ??
                                                              user.photoURL)),
                                          10.widthBox,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    120,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    user.uid ==
                                                            wakes[index]
                                                                .senderUid
                                                        ? user.displayName.text
                                                            .size(14)
                                                            .bold
                                                            .make()
                                                        : user
                                                            .coupleDisplayName!
                                                            .text
                                                            .size(14)
                                                            .bold
                                                            .make(),
                                                    Expanded(
                                                      child: Container(),
                                                    ),
                                                    DateFormat("hh:mm")
                                                        .format(wakes[index]
                                                            .alarmTime)
                                                        .toString()
                                                        .text
                                                        .size(10)
                                                        .make()
                                                        .pSymmetric(h: 14),
                                                    PopupMenuButton(
                                                      itemBuilder: (context) {
                                                        if (wakes[index]
                                                            .alarmTime
                                                            .isBefore(DateTime
                                                                .now())) {
                                                          return [
                                                            PopupMenuItem(
                                                              onTap: () {
                                                                showToast(AppLocalizations.of(
                                                                        context)!
                                                                    .nodeletepast);
                                                              },
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .delete),
                                                            ),
                                                          ];
                                                        }
                                                        return [
                                                          PopupMenuItem(
                                                            onTap: () {
                                                              _letterEditController
                                                                  .text = wakes[
                                                                      index]
                                                                  .wakeMessage;
                                                              // _updateLetter(
                                                              //     wakes[index]
                                                              //         .wakeUpUid);
                                                            },
                                                            child: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .edit),
                                                          ),
                                                          PopupMenuItem(
                                                            onTap: () {
                                                              ref
                                                                  .watch(wakeControllerProvider
                                                                      .notifier)
                                                                  .wakeDelete(wakes[
                                                                          index]
                                                                      .wakeUid);
                                                              showToast(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .deleted);
                                                            },
                                                            child: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .delete),
                                                          ),
                                                        ];
                                                      },
                                                    ).box.height(32).make(),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    140,
                                                child: SelectableText(
                                                    scrollPhysics:
                                                        const NeverScrollableScrollPhysics(),
                                                    wakes[index].wakeMessage),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      wakes[index].wakePhoto.isEmpty
                                          ? Container()
                                          : Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.grey,
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              child: CachedNetworkImage(
                                                imageUrl: wakes[index]
                                                    .wakePhoto
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
                                      wakes[index].answerMessage.isEmpty
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      user.uid ==
                                                              wakes[index]
                                                                  .reciverUid
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                              child: CachedNetworkImage(
                                                                  width: 40,
                                                                  imageUrl: user
                                                                      .photoURL))
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                              child: CachedNetworkImage(
                                                                  width: 40,
                                                                  imageUrl: user
                                                                          .couplePhotoURL ??
                                                                      user.photoURL)),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          user.uid ==
                                                                  wakes[index]
                                                                      .reciverUid
                                                              ? user.displayName
                                                                  .text
                                                                  .size(14)
                                                                  .bold
                                                                  .make()
                                                              : user
                                                                  .coupleDisplayName!
                                                                  .text
                                                                  .size(14)
                                                                  .bold
                                                                  .make(),
                                                          wakes[index]
                                                              .answerMessage
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            90,
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: wakes[index]
                                                            .answerPhoto
                                                            .isEmpty
                                                        ? Container()
                                                        : CachedNetworkImage(
                                                            fit: BoxFit.fill,
                                                            imageUrl: wakes[
                                                                    index]
                                                                .answerPhoto
                                                                .toString()),
                                                  ),
                                                ],
                                              ).p(15),
                                            ).pSymmetric(v: 20),
                                    ],
                                  ).p(10),
                                ).pOnly(left: 10),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).p(10);
                  },
                ),
              );
            },
            loading: () => const Loader(),
            error: (error, stack) {
              logger.e(error.toString());
              return Center(
                child: Text(AppLocalizations.of(context)!.erroruser),
              );
            });
      }, loading: () {
        return const Loader();
      }, error: (error, stack) {
        logger.e(error.toString());
        return Center(
          child: Text(AppLocalizations.of(context)!.erroruser),
        );
      }),
    );
  }
}
