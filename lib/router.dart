import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/chatapp/screen/auth/login_screen.dart';
import 'package:wakeuphoney/features/alarm/alarm_screen.dart';
import 'package:wakeuphoney/features/couples/couples_list_screen.dart';
import 'package:wakeuphoney/providertutorial/providerscreen/changenotifierprovider.dart';
import 'package:wakeuphoney/providertutorial/providerscreen/futureprovider.dart';
import 'package:wakeuphoney/providertutorial/providerscreen/provider.dart';
import 'package:wakeuphoney/providertutorial/providerscreen/state_provider.dart';
import 'package:wakeuphoney/providertutorial/providerscreen/statenodifierprovider.dart';
import 'package:wakeuphoney/providertutorial/providerscreen/streamprovider.dart';

import 'chatapp/screen/home_screen.dart';
import 'features/dailymessages/daily_screen.dart';
import 'features/dailymessages/daily_screen2.dart';
import 'features/profile/couple_profile_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/login_screen.dart';
import 'practice_home_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/",
    redirect: (context, state) {
      final isLoggedIn = ref.watch(authRepositoryProvider).isLoggedIn;
      final loginName =
          ref.watch(authRepositoryProvider).currentUser?.displayName;
      print('islogged');
      print(isLoggedIn);
      print(loginName);
      if (!isLoggedIn) {
        if (state.matchedLocation != LoginHome.routeURL) {
          print(LoginHome.routeURL);
          return LoginHome.routeURL;
        }
      }
      if (isLoggedIn) {
        if (state.location == LoginHome.routeURL) {
          print("no enter login page");
          return PracticeHome.routeURL;
        }
      }
      return null;
    },
    routes: [
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
                        context.goNamed(DailyMessage2Screen.routeName),
                    icon: const Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),

                  IconButton(
                    onPressed: () => context.goNamed(PracticeHome.routeName),
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),

                  IconButton(
                    onPressed: () => context.goNamed(ProfileScreen.routeName),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),

                  // IconButton(
                  //   onPressed: () {
                  //     context.go("/home");
                  //   },
                  //   icon: const Icon(
                  //     Icons.home,
                  //     color: Colors.white,
                  //     size: 33,
                  //   ),
                  // ),
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
            name: LoginHome.routeName,
            path: LoginHome.routeURL,
            builder: (context, state) => const LoginHome(),
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
            name: ProviderPage.routeName,
            path: ProviderPage.routeURL,
            builder: (context, state) => const ProviderPage(),
          ),
          GoRoute(
            name: StateProviderPage.routeName,
            path: StateProviderPage.routeURL,
            builder: (context, state) => const StateProviderPage(),
          ),
          GoRoute(
            name: FutureProviderPage.routeName,
            path: FutureProviderPage.routeURL,
            builder: (context, state) => const FutureProviderPage(),
          ),
          GoRoute(
            name: StreamProviderPage.routeName,
            path: StreamProviderPage.routeURL,
            builder: (context, state) => const StreamProviderPage(),
          ),
          GoRoute(
            name: ChangeNotifierProviderPage.routeName,
            path: ChangeNotifierProviderPage.routeURL,
            builder: (context, state) => const ChangeNotifierProviderPage(),
          ),
          GoRoute(
            name: StateNotifierProviderPage.routeName,
            path: StateNotifierProviderPage.routeURL,
            builder: (context, state) => const StateNotifierProviderPage(),
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
            name: DailyMessage2Screen.routeName,
            path: DailyMessage2Screen.routeURL,
            builder: (context, state) => const DailyMessage2Screen(),
          ),
          GoRoute(
            name: ProfileScreen.routeName,
            path: ProfileScreen.routeURL,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            name: CoupleProfileScreen.routeName,
            path: CoupleProfileScreen.routeURL,
            builder: (context, state) => const CoupleProfileScreen(),
          ),
          GoRoute(
            name: MyChatApp.routeName,
            path: MyChatApp.routeURL,
            builder: (context, state) => const MyChatApp(),
          ),
          GoRoute(
            name: LoginScreen.routeName,
            path: LoginScreen.routeURL,
            builder: (context, state) => const LoginScreen(),
          ),
        ],
      )
    ],
  );
});
