import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:wakeuphoney/features/oldalarm/alarm_new_ring_screen.dart';
import 'package:wakeuphoney/features/oldalarm/alarm_screen.dart';
import 'package:wakeuphoney/features/oldauth/login_onboard_screen.dart';
import 'package:wakeuphoney/features/oldbitcoin/bitcoin_screen.dart';
import 'package:wakeuphoney/core/image/image_screen.dart';
import 'package:wakeuphoney/features/oldmain/main_screen.dart';
import 'package:wakeuphoney/features/oldprofile/profile_edit_screen.dart';
import 'package:wakeuphoney/features/oldwakeup/wakeup_write_screen.dart';
import 'package:wakeuphoney/screen/main/main_screen.dart';

import 'app.dart';
import 'features/oldalarm/alarm_ring_screen.dart';
import 'features/oldauth/auth_repository.dart';
import 'features/oldauth/login_email_screen.dart';
import 'features/oldauth/login_screen.dart';
import 'features/oldchatgpt/cs_screen.dart';
import 'core/image/image_full_screen.dart';
import 'features/oldmatch/match_screen.dart';
import 'features/oldprofile/feedback_screen.dart';
import 'features/oldprofile/profile_screen.dart';
import 'features/oldvoice/voice_test_screen.dart';
import 'features/oldvoice/voice_text_screen.dart';
import 'features/oldwakeup/response_screen.dart';
import 'features/oldmanager/practice_home_screen.dart';

final routerProvider = Provider((ref) {
  final alarmSettings = ref.watch(alarmSettingsProvider);
  return GoRouter(
    initialLocation: "/maintabs",
    navigatorKey: App.navigatorKey,
    redirect: (context, state) {
      final isLoggedIn = ref.watch(authRepositoryProvider).isLoggedIn;
      var logger = Logger();
      // logger.d("isLoggedIn $isLoggedIn");
      if (!isLoggedIn) {
        if (state.matchedLocation != LoginHome.routeURL) {
          return LoginHome.routeURL;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        name: MainTabsScreen.routeName,
        path: MainTabsScreen.routeUrl,
        builder: (context, state) => const MainTabsScreen(),
      ),
      GoRoute(
        name: LoginHome.routeName,
        path: LoginHome.routeURL,
        builder: (context, state) => const LoginHome(),
      ),
      GoRoute(
        name: LoginOnboardScreen.routeName,
        path: LoginOnboardScreen.routeURL,
        builder: (context, state) => const LoginOnboardScreen(),
      ),
      GoRoute(
        name: AlarmRingScreen.routeName,
        path: AlarmRingScreen.routeURL,
        builder: (context, state) => AlarmRingScreen(alarmSettings: alarmSettings),
      ),
      GoRoute(
        name: PracticeHome.routeName,
        path: PracticeHome.routeURL,
        builder: (context, state) => const PracticeHome(),
      ),
      GoRoute(
        name: AlarmNewScreen.routeName,
        path: AlarmNewScreen.routeURL,
        builder: (context, state) => const AlarmNewScreen(),
      ),
      GoRoute(
        name: AlarmHome.routeName,
        path: AlarmHome.routeURL,
        builder: (context, state) => const AlarmHome(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AlarmHome(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        name: ResponseScreen.routeName,
        path: ResponseScreen.routeURL,
        builder: (context, state) => const ResponseScreen(),
      ),
      GoRoute(
        name: CoupleProfileScreen.routeName,
        path: CoupleProfileScreen.routeURL,
        builder: (context, state) => const CoupleProfileScreen(),
      ),
      GoRoute(
        name: FeedbackScreen.routeName,
        path: FeedbackScreen.routeURL,
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        name: MatchScreen.routeName,
        path: MatchScreen.routeURL,
        builder: (context, state) => const MatchScreen(),
      ),
      GoRoute(
        name: MainScreen.routeName,
        path: MainScreen.routeURL,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        name: ProfileEditScreen.routeName,
        path: ProfileEditScreen.routeURL,
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        name: CustomerServiceScreen.routeName,
        path: CustomerServiceScreen.routeURL,
        builder: (context, state) => const CustomerServiceScreen(),
      ),
      GoRoute(
        name: MyApp.routeName,
        path: MyApp.routeURL,
        builder: (context, state) => const MyApp(),
      ),
      GoRoute(
        name: MyApptest.routeName,
        path: MyApptest.routeURL,
        builder: (context, state) => const MyApptest(),
      ),
      GoRoute(
        name: WakeUpWriteScreen.routeName,
        path: WakeUpWriteScreen.routeURL,
        builder: (context, state) => const WakeUpWriteScreen(),
      ),
      GoRoute(
        name: BitcoinScreen.routeName,
        path: BitcoinScreen.routeURL,
        builder: (context, state) => const BitcoinScreen(),
      ),
      GoRoute(
        name: ImageScreen.routeName,
        path: ImageScreen.routeURL,
        builder: (context, state) => const ImageScreen(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ImageScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        name: ImageFullScreen.routeName,
        path: ImageFullScreen.routeURL,
        builder: (context, state) => ImageFullScreen(
          imageURL: state.uri.queryParameters['filter']!,
          herotag: state.uri.queryParameters['herotag']!,
        ),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: ImageFullScreen(
            imageURL: state.uri.queryParameters['filter']!,
            herotag: state.uri.queryParameters['herotag']!,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
    ],
  );
});
final logOutRouterProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/loginonboardscreen",
    routes: [
      GoRoute(
        name: LoginHome.routeName,
        path: LoginHome.routeURL,
        builder: (context, state) => const LoginHome(),
      ),
      GoRoute(
        name: LoginOnboardScreen.routeName,
        path: LoginOnboardScreen.routeURL,
        builder: (context, state) => const LoginOnboardScreen(),
      ),
      GoRoute(
        name: PracticeHome.routeName,
        path: PracticeHome.routeURL,
        builder: (context, state) => const PracticeHome(),
      ),
      GoRoute(
        name: MainScreen.routeName,
        path: MainScreen.routeURL,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        name: EmailLoginScreen.routeName,
        path: EmailLoginScreen.routeURL,
        builder: (context, state) => const EmailLoginScreen(),
      ),
    ],
  );
});
