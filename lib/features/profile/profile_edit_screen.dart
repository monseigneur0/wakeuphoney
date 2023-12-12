import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:wakeuphoney/features/image/image_screen.dart';

import '../../core/common/loader.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_repository.dart';
import '../auth/login_screen.dart';
import 'profile_controller.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  String imageUrl = "";
  bool isLoading = false;
  File? profileImageFile;
  void selectProfileImage() async {
    final profileImagePicked = await selectGalleryImage();
    if (profileImagePicked != null) {
      setState(() {
        profileImageFile = File(profileImagePicked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(getMyUserInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 편집'),
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
                        "이름",
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
                        Text(user.displayName,
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 40,
                        ),
                        Text("생일", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 40,
                        ),
                        Text("성별", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 40,
                        ),
                        Text("위치", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      "입력하신 위치는 날씨 정보 제공을 위해 사용됩니다.",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "내 계정 정보",
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
                        "상대 계정 정보",
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
                        Text(user.coupleDisplayName ?? "없어요",
                            style: TextStyle(
                              color: Colors.grey[700],
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () => launchUrlString("https://sweetgom.com/5"),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text("앱 소개", style: TextStyle(fontSize: 18)),
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 40,
                            ),
                            Text("앱 버전 정보", style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("1.0.17", style: TextStyle(fontSize: 18)),
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
                    onTap: () => launchUrlString('https://sweetgom.com/4'),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text("개인정보처리방침", style: TextStyle(fontSize: 18)),
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
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text("로그아웃", style: TextStyle(fontSize: 20)),
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
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text("상대와 연결 끊기", style: TextStyle(fontSize: 20)),
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
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Text("회원 탈퇴", style: TextStyle(fontSize: 20)),
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
            return const Center(
              child: Text("다시 접속해주세요"),
            );
          },
          loading: () => const Loader()),
    );
  }
}
