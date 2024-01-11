import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core/common/loader.dart';
import '../../core/utils.dart';
import '../profile/profile_controller.dart';
import 'letter_controller.dart';

class LetterFeed5Screen extends ConsumerStatefulWidget {
  const LetterFeed5Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterFeed5ScreenState();
}

class _LetterFeed5ScreenState extends ConsumerState<LetterFeed5Screen> {
  Logger logger = Logger();

  final _scrollController = ScrollController();

  final TextEditingController _letterEditController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(getMyUserInfoProvider);

    var lettersList = ref.watch(getLetters2ListProvider);

    return Scaffold(
      backgroundColor: Vx.gray100,
      // appBar: AppBar(
      //   title: const Text("Letter Feed 5"),
      //   actions: const [
      //     // IconButton(
      //     //   onPressed: () {
      //     //     context.pushNamed(LetterDayScreen.routeName);
      //     //   },
      //     //   icon: const Icon(Icons.add),
      //     // ),
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: () async {
          lettersList = ref.refresh(getLetters2ListProvider);
        },
        child: userInfo.when(data: (user) {
          return lettersList.when(
              data: (letters) {
                // logger.d(letters);
                if (letters.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noletter,
                      style: const TextStyle(fontSize: 30),
                    ),
                  );
                }
                return Skeletonizer(
                  enabled: letters.isEmpty,
                  child: ListView.builder(
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
                                  DateFormat("MM/dd")
                                      .format(letters[index].letterTime)
                                      .toString()
                                      .text
                                      .size(20)
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
                                              blurRadius: 20,
                                              offset: const Offset(8, 8))
                                        ]),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            user.uid == letters[index].sender
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: CachedNetworkImage(
                                                        width: 45,
                                                        imageUrl:
                                                            user.photoURL))
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
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
                                                              letters[index]
                                                                  .sender
                                                          ? user
                                                              .displayName.text
                                                              .size(16)
                                                              .bold
                                                              .make()
                                                          : user
                                                              .coupleDisplayName!
                                                              .text
                                                              .size(16)
                                                              .bold
                                                              .make(),
                                                      PopupMenuButton(
                                                        itemBuilder: (context) {
                                                          if (letters[index]
                                                              .letterTime
                                                              .isBefore(DateTime
                                                                  .now())) {
                                                            return [
                                                              PopupMenuItem(
                                                                onTap: () {
                                                                  showSnackBar(
                                                                      context,
                                                                      AppLocalizations.of(
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
                                                                        .text =
                                                                    letters[index]
                                                                        .letter;
                                                                _updateLetter(
                                                                    letters[index]
                                                                        .letterId);
                                                              },
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .edit),
                                                            ),
                                                            PopupMenuItem(
                                                              onTap: () {
                                                                ref
                                                                    .watch(letterControllerProvider
                                                                        .notifier)
                                                                    .letterDelete(
                                                                        letters[index]
                                                                            .letterId);
                                                                showSnackBar(
                                                                    context,
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
                                                      letters[index].letter),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        letters[index].letterPhoto.isEmpty
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
                                                  errorWidget: (context, url,
                                                          error) =>
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        user.uid ==
                                                                letters[index]
                                                                    .reciver
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
                                                                    letters[index]
                                                                        .reciver
                                                                ? user
                                                                    .displayName
                                                                    .text
                                                                    .size(16)
                                                                    .bold
                                                                    .make()
                                                                : user
                                                                    .coupleDisplayName!
                                                                    .text
                                                                    .size(16)
                                                                    .bold
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              90,
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      child: letters[index]
                                                              .answerPhoto
                                                              .isEmpty
                                                          ? Container()
                                                          : CachedNetworkImage(
                                                              fit: BoxFit.fill,
                                                              imageUrl: letters[
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
      ),
    );
  }

  Future<void> _updateLetter(String letterId) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
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
                      return AppLocalizations.of(context)!.putsometext;
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
                        showSnackBar(context,
                            AppLocalizations.of(context)!.letteredited);
                        ref
                            .watch(letterControllerProvider.notifier)
                            .letterEdit(letterId, _letterEditController.text);
                        _letterEditController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.edit),
                  ),
                ],
              ),
            ],
          ).p(20);
        });
  }
}
