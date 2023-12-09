import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:wakeuphoney/features/alarm/alarm_screen.dart';
import 'package:wakeuphoney/features/dailymessages/letter_screen.dart';
import 'package:wakeuphoney/features/main/main_screen.dart';
import 'package:wakeuphoney/features/profile/profile_edit_screen.dart';
import 'features/alarm/alarm_ring_screen.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/login_email_screen.dart';
import 'features/dailymessages/daily_create_screen.dart';
import 'features/dailymessages/daily_letter_screen.dart';
import 'features/dailymessages/couple_letter_screen.dart';
import 'features/dailymessages/letter_date_screen.dart';
import 'features/dailymessages/letter_day_pick_screen.dart';
import 'features/dailymessages/history_screen.dart';
import 'features/dailymessages/letter_create_screen.dart';
import 'features/dailymessages/letter_day_screen.dart';
import 'features/match/match3_screen.dart';
import 'features/match/match4_screen.dart';
import 'features/match/match_up.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/feedback_screen.dart';
import 'features/match/match_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/dailymessages/response_screen.dart';
import 'practice_home_screen.dart';

final routerProvider = Provider((ref) {
  final alarmSettings = ref.watch(alarmSettingsProvider);
  return GoRouter(
    initialLocation: "/main",
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
        name: LoginHome.routeName,
        path: LoginHome.routeURL,
        builder: (context, state) => const LoginHome(),
      ),
      GoRoute(
        name: AlarmRingScreen.routeName,
        path: AlarmRingScreen.routeURL,
        builder: (context, state) =>
            AlarmRingScreen(alarmSettings: alarmSettings),
      ),
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
        name: DailyLetterScreen.routeName,
        path: DailyLetterScreen.routeURL,
        builder: (context, state) => const DailyLetterScreen(),
      ),
      GoRoute(
        name: HistoryMessageScreen.routeName,
        path: HistoryMessageScreen.routeURL,
        builder: (context, state) => const HistoryMessageScreen(),
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
        name: Match3Screen.routeName,
        path: Match3Screen.routeURL,
        builder: (context, state) => const Match3Screen(),
      ),
      GoRoute(
        name: Match4Screen.routeName,
        path: Match4Screen.routeURL,
        builder: (context, state) => const Match4Screen(),
      ),
      GoRoute(
        name: Home.routeName,
        path: Home.routeURL,
        builder: (context, state) => const Home(),
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
      GoRoute(
        name: LetterScreen.routeName,
        path: LetterScreen.routeURL,
        builder: (context, state) => const LetterScreen(),
      ),
      GoRoute(
        name: LetterCreateScreen.routeName,
        path: LetterCreateScreen.routeURL,
        builder: (context, state) => const LetterCreateScreen(),
      ),
      GoRoute(
        name: LetterDayPickScreen.routeName,
        path: LetterDayPickScreen.routeURL,
        builder: (context, state) => const LetterDayPickScreen(),
      ),
      GoRoute(
        name: LetterDateScreen.routeName,
        path: LetterDateScreen.routeURL,
        builder: (context, state) => const LetterDateScreen(),
      ),
      GoRoute(
        name: LetterDayScreen.routeName,
        path: LetterDayScreen.routeURL,
        builder: (context, state) => const LetterDayScreen(),
      ),
      GoRoute(
        name: ProfileEditScreen.routeName,
        path: ProfileEditScreen.routeURL,
        builder: (context, state) => const ProfileEditScreen(),
      ),
    ],
  );
});
final logOutRouterProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/login",
    routes: [
      GoRoute(
        name: LoginHome.routeName,
        path: LoginHome.routeURL,
        builder: (context, state) => const LoginHome(),
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
