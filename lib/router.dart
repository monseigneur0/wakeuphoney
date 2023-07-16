import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/alarm/alarm_screen.dart';
import 'package:wakeuphoney/features/couples/couples_list_screen.dart';

import 'features/alarm/alarm2_screen.dart';
import 'features/alarm/alarm_ring_screen.dart';
import 'features/dailymessages/daily_create_screen.dart';
import 'features/dailymessages/daily_letter2_screen.dart';
import 'features/dailymessages/daily_letter3_screen.dart';
import 'features/dailymessages/daily_letter4_screen.dart';
import 'features/dailymessages/daily_letter_screen.dart';
import 'features/dailymessages/daily_screen.dart';
import 'features/dailymessages/daily_screen2.dart';
import 'features/dailymessages/couple_letter_screen.dart';
import 'features/profile/couple_profile_screen.dart';
import 'features/profile/profile_controller.dart';
import 'features/match/match_screen.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/login_screen.dart';
import 'features/dailymessages/response_screen.dart';
import 'practice_home_screen.dart';

final routerProvider = Provider((ref) {
  final hasCoupleId = ref.watch(getUserProfileStreamProvider);
  final alarmSettings = ref.watch(alarmSettings1Provider);
  return GoRouter(
    initialLocation: "/dailyletter3",
    redirect: (context, state) {
      final isLoggedIn = ref.watch(authRepositoryProvider).isLoggedIn;
      final loginName =
          ref.watch(authRepositoryProvider).currentUser?.displayName;
      print('islogged   $isLoggedIn  $loginName');
      if (!isLoggedIn) {
        if (state.matchedLocation != LoginHome.routeURL) {
          print(LoginHome.routeURL);
          return LoginHome.routeURL;
        }
      }
      if (isLoggedIn) {
        if (state.location == LoginHome.routeURL) {
          print("no enter login page");
          return MatchScreen.routeURL;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        name: LoginHome.routeName,
        path: LoginHome.routeURL,
        builder: (context, state) => const LoginHome(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: Center(
              child: child,
            ),
            // bottomNavigationBar: BottomNavigationBar(
            //   items: const <BottomNavigationBarItem>[
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.home),
            //       label: 'Home',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.business),
            //       label: 'Business',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.school),
            //       label: 'School',
            //     ),
            //   ],
            //   currentIndex: ref.watch(navStateProvider),
            //   selectedItemColor: Colors.amber[800],
            //   onTap: (val) {
            //     switch (val) {
            //       case 0:
            //         if (ref.watch(navStateProvider.notifier).state == val) {}
            //         break;
            //       case 1:
            //         context.goNamed(AlarmHome.routeName);
            //     }
            //     ref.watch(navStateProvider.notifier).state = val;
            //     return;
            //   },
            // ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.goNamed(AlarmHome.routeName),
                    icon: const Icon(
                      Icons.add_alarm,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        context.goNamed(DailyLetter3Screen.routeName),
                    icon: const Icon(
                      Icons.local_post_office_outlined,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        context.goNamed(DailyLetter4Screen.routeName),
                    icon: const Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () => context.goNamed(PracticeHome.routeName),
                  //   icon: const Icon(
                  //     Icons.home,
                  //     color: Colors.white,
                  //     size: 33,
                  //   ),
                  // ),
                  IconButton(
                    onPressed: () => context.goNamed(MatchScreen.routeName),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        routes: [
          GoRoute(
            name: PracticeHome.routeName,
            path: PracticeHome.routeURL,
            builder: (context, state) => const PracticeHome(),
          ),
          GoRoute(
            name: AlarmHome.routeName,
            path: AlarmHome.routeURL,
            builder: (context, state) => const AlarmHome(),
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const AlarmHome(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            name: AlarmRingScreen.routeName,
            path: AlarmRingScreen.routeURL,
            builder: (context, state) =>
                AlarmRingScreen(alarmSettings: alarmSettings),
          ),
          GoRoute(
            name: AlarmHome2.routeName,
            path: AlarmHome2.routeURL,
            builder: (context, state) => const AlarmHome2(),
          ),
          GoRoute(
            name: CouplesListScreen.routeName,
            path: CouplesListScreen.routeURL,
            builder: (context, state) => const CouplesListScreen(),
          ),
          GoRoute(
            name: DailyMessageScreen.routeName,
            path: DailyMessageScreen.routeURL,
            builder: (context, state) => const DailyMessageScreen(),
          ),
          GoRoute(
            name: ResponseScreen.routeName,
            path: ResponseScreen.routeURL,
            builder: (context, state) => const ResponseScreen(),
          ),
          GoRoute(
            name: DailyLetterScreen.routeName,
            path: DailyLetterScreen.routeURL,
            builder: (context, state) => const DailyLetterScreen(),
          ),
          GoRoute(
            name: DailyLetter2Screen.routeName,
            path: DailyLetter2Screen.routeURL,
            builder: (context, state) => const DailyLetter2Screen(),
          ),
          GoRoute(
            name: DailyLetter3Screen.routeName,
            path: DailyLetter3Screen.routeURL,
            builder: (context, state) => const DailyLetter3Screen(),
          ),
          GoRoute(
            name: DailyLetter4Screen.routeName,
            path: DailyLetter4Screen.routeURL,
            builder: (context, state) => const DailyLetter4Screen(),
          ),
          GoRoute(
            name: DailyLetterCreateScreen.routeName,
            path: DailyLetterCreateScreen.routeURL,
            builder: (context, state) => const DailyLetterCreateScreen(),
          ),
          GoRoute(
            name: CoupleLetterScreen.routeName,
            path: CoupleLetterScreen.routeURL,
            builder: (context, state) => const CoupleLetterScreen(),
          ),
          GoRoute(
            name: DailyMessage2Screen.routeName,
            path: DailyMessage2Screen.routeURL,
            builder: (context, state) => const DailyMessage2Screen(),
          ),
          GoRoute(
            name: MatchScreen.routeName,
            path: MatchScreen.routeURL,
            builder: (context, state) => const MatchScreen(),
            redirect: (context, state) {
              final hasCoupleIdBool = hasCoupleId.when(
                data: (data) => data.couples.isNotEmpty,
                error: (error, stackTrace) {
                  print("error router  $error ");
                  return false;
                },
                loading: () => false,
              );
              print('hasCoupleId $hasCoupleId $hasCoupleIdBool');
              if (!hasCoupleIdBool) {
                if (state.matchedLocation != MatchScreen.routeURL) {
                  print(MatchScreen.routeURL);
                  return MatchScreen.routeURL;
                }
              }
              if (hasCoupleIdBool) {
                print("couple exist");
                return CoupleProfileScreen.routeURL;
              }
              return MatchScreen.routeURL;
            },
          ),
          GoRoute(
            name: CoupleProfileScreen.routeName,
            path: CoupleProfileScreen.routeURL,
            builder: (context, state) => const CoupleProfileScreen(),
          ),
        ],
      )
    ],
  );
});
