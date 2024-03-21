import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/common/common.dart';

import '../../features/alarm/alarm_screen.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/auth/auth_repository.dart';
import '../../features/auth/login_screen.dart';
import '../../features/profile/feedback_screen.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    var logger = Logger();

    final userprofile = ref.watch(getMyUserDataProvider);
    return Drawer(
      backgroundColor: Colors.grey[600],
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/alarmbearno.png',
              width: 80,
            ),
            iconSize: 50,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            userprofile.when(
              data: (data) => data.displayName,
              error: (error, stackTrace) {
                logger.d("error$error  data.displayName drawer");
                return "Try again";
              },
              loading: () => "Loading",
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // Text(
          //   userprofile.when(
          //     data: (data) => data.uid,
          //     error: (error, stackTrace) {
          //       logger.d("error$error  data.displayName drawer");
          //       return "Try again";
          //     },
          //     loading: () => "Loading",
          //   ),
          //   textAlign: TextAlign.center,
          //   style: const TextStyle(fontWeight: FontWeight.bold),
          // ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              context.pushNamed(AlarmHome.routeName);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.alarm,
              color: Colors.white,
            ),
            title: Text(
              AppLocalizations.of(context)!.alarms,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            onTap: () {
              context.pushNamed(FeedbackScreen.routeName);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.feedback_outlined,
              color: Colors.white,
            ),
            title: Text(
              AppLocalizations.of(context)!.feedback,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Platform.isIOS
              ? ListTile(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text(AppLocalizations.of(context)!.sure),
                        content: Text(AppLocalizations.of(context)!.logout),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(AppLocalizations.of(context)!.no),
                          ),
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.goNamed(LoginHome.routeName);
                              ref.watch(authRepositoryProvider).logout();
                            },
                            isDestructiveAction: true,
                            child: Text(AppLocalizations.of(context)!.yes),
                          ),
                        ],
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              : ListTile(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.logout),
                            content: Text(AppLocalizations.of(context)!.sure),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
          // ListTile(
          //   onTap: () {
          //     context.pushNamed(PracticeHome.routeName);
          //   },
          //   contentPadding:
          //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //   leading: Icon(
          //     Icons.feedback_outlined,
          //     color: Colors.grey[600],
          //   ),
          //   title: Text(
          //     AppLocalizations.of(context)!.feedback,
          //     style: TextStyle(color: Colors.grey[600]),
          //   ),
          // ),
          const SizedBox(
            height: 50,
          ),
          Platform.isIOS
              ? ListTile(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text(AppLocalizations.of(context)!.delete),
                        content: Text(AppLocalizations.of(context)!.deletesure),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(AppLocalizations.of(context)!.no),
                          ),
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.goNamed(LoginHome.routeName);

                              ref.watch(authRepositoryProvider).deleteUser();
                            },
                            isDestructiveAction: true,
                            child: Text(AppLocalizations.of(context)!.yes),
                          ),
                        ],
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(
                    AppLocalizations.of(context)!.delete,
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              : ListTile(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.delete),
                            content: Text(AppLocalizations.of(context)!.deletesure),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(
                    AppLocalizations.of(context)!.delete,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
          // Platform.isIOS
          //     ? ListTile(
          //         onTap: () {
          //           showCupertinoDialog(
          //             context: context,
          //             builder: (context) => CupertinoAlertDialog(
          //               title: Text(AppLocalizations.of(context)!.breakup),
          //               content: Text(AppLocalizations.of(context)!.deletesure),
          //               actions: [
          //                 CupertinoDialogAction(
          //                   onPressed: () => Navigator.of(context).pop(),
          //                   child: Text(AppLocalizations.of(context)!.no),
          //                 ),
          //                 CupertinoDialogAction(
          //                   onPressed: () {
          //                     Navigator.of(context).pop();
          //                     ref
          //                         .watch(authControllerProvider.notifier)
          //                         .brokeup();
          //                   },
          //                   isDestructiveAction: true,
          //                   child: Text(AppLocalizations.of(context)!.yes),
          //                 ),
          //               ],
          //             ),
          //           );
          //         },
          //         contentPadding:
          //             const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //         leading: const Icon(Icons.exit_to_app),
          //         title: Text(
          //           AppLocalizations.of(context)!.breakup,
          //           style: const TextStyle(color: Colors.black),
          //         ),
          //       )
          //     : ListTile(
          //         onTap: () async {
          //           showDialog(
          //               barrierDismissible: false,
          //               context: context,
          //               builder: (context) {
          //                 return AlertDialog(
          //                   title: Text(AppLocalizations.of(context)!.breakup),
          //                   content:
          //                       Text(AppLocalizations.of(context)!.deletesure),
          //                   actions: [
          //                     IconButton(
          //                       onPressed: () {
          //                         Navigator.pop(context);
          //                       },
          //                       icon: const Icon(
          //                         Icons.cancel,
          //                         color: Colors.red,
          //                       ),
          //                     ),
          //                     IconButton(
          //                       onPressed: () {
          //                         ref
          //                             .watch(authControllerProvider.notifier)
          //                             .brokeup();
          //                         Navigator.of(context).pop();
          //                       },
          //                       icon: const Icon(
          //                         Icons.done,
          //                         color: Colors.green,
          //                       ),
          //                     ),
          //                   ],
          //                 );
          //               });
          //         },
          //         contentPadding:
          //             const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //         leading: const Icon(Icons.exit_to_app),
          //         title: Text(
          //           AppLocalizations.of(context)!.delete,
          //           style: const TextStyle(color: Colors.black),
          //         ),
          //       ),
        ],
      ),
    );
  }
}