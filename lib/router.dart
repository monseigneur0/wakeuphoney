import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/app.dart';
import 'package:wakeuphoney/auth.dart';
import 'package:wakeuphoney/auth/login_onboard_screen.dart';
import 'package:wakeuphoney/common/image/image_screen.dart';
import 'package:wakeuphoney/common/providers/providers.dart';

import 'package:wakeuphoney/common/route/fade_transition.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/auth/login_tabscreen.dart';
import 'package:wakeuphoney/common/error/error_page.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_function.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_reply_screen.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_ring_sample.dart';
import 'package:wakeuphoney/tabs/bitcoin/bitcoin_screen.dart';
import 'package:wakeuphoney/tabs/main_tabscreen.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_tabscreen.dart';
import 'package:wakeuphoney/tabs/feed/feed_detail_scree.dart';
import 'package:wakeuphoney/tabs/feed/feed_tabscreen.dart';
import 'package:wakeuphoney/tabs/manager/manage_user_screen.dart';
import 'package:wakeuphoney/tabs/manager/manager_screen.dart';
import 'package:wakeuphoney/tabs/match/match_tabscreen.dart';
import 'package:wakeuphoney/tabs/profile/myprofile_tabscreen.dart';
import 'package:wakeuphoney/tabs/tab_item.dart';
import 'package:wakeuphoney/tabs/wake/wake_tabscreen.dart';
import 'package:wakeuphoney/tabs/wake/wake_write_screen.dart';

import 'common/common.dart';

final auth = LoginAuth();

final routerProvider = Provider((ref) {
  final alarmSettings = ref.watch(alarmSettingsProvider);
  return GoRouter(
    initialLocation: "/main",
    errorBuilder: (context, state) {
      return ErrorPage(context, state);
    },
    // navigatorKey: App.navigatorKey,
    redirect: ref.watch(loginControllerProvider.notifier).guard,
    refreshListenable: auth,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: MainTabsScreen.routeName,
        path: MainTabsScreen.routeUrl,
        builder: (context, state) => const MainTabsScreen(),
      ),
      GoRoute(
        name: LoginNewScreen.routeName,
        path: LoginNewScreen.routeUrl,
        builder: (context, state) => const LoginNewScreen(),
      ),
      GoRoute(
        name: LoginOnBoardScreen.routeName,
        path: LoginOnBoardScreen.routeUrl,
        builder: (context, state) => const LoginOnBoardScreen(),
      ),
      GoRoute(
        name: AlarmTabScreen.routeName,
        path: AlarmTabScreen.routeUrl,
        builder: (context, state) => const AlarmTabScreen(),
      ),
      GoRoute(
        name: WakeTabScreen.routeName,
        path: WakeTabScreen.routeUrl,
        builder: (context, state) => const WakeTabScreen(),
      ),
      GoRoute(
        name: FeedTabScreen.routeName,
        path: FeedTabScreen.routeUrl,
        builder: (context, state) => const FeedTabScreen(),
      ),
      GoRoute(
        name: WakeWriteScreen.routeName,
        path: WakeWriteScreen.routeUrl,
        builder: (context, state) => const WakeWriteScreen(),
      ),
      GoRoute(
        name: ImageScreen.routeName,
        path: ImageScreen.routeUrl,
        builder: (context, state) => const ImageScreen(),
      ),
      GoRoute(
        name: ManagerScreen.routeName,
        path: ManagerScreen.routeUrl,
        builder: (context, state) => const ManagerScreen(),
      ),
      GoRoute(
        name: ManageUserScreen.routeName,
        path: ManageUserScreen.routeUrl,
        builder: (context, state) => const ManageUserScreen(),
      ),
      GoRoute(
        name: BitcoinScreen.routeName,
        path: BitcoinScreen.routeUrl,
        builder: (context, state) => const BitcoinScreen(),
      ),
      GoRoute(
        name: AlarmRingSampleScreen.routeName,
        path: AlarmRingSampleScreen.routeUrl,
        builder: (context, state) => AlarmRingSampleScreen(
          alarmSettings: alarmSettings,
        ),
      ),
      GoRoute(
        name: AlarmFunction.routeName,
        path: AlarmFunction.routeUrl,
        builder: (context, state) => const AlarmFunction(),
      ),
      GoRoute(
        name: MyProfileTabScreen.routeName,
        path: MyProfileTabScreen.routeUrl,
        builder: (context, state) => const MyProfileTabScreen(),
      ),
      GoRoute(
        name: AlarmReplyScreen.routeName,
        path: AlarmReplyScreen.routeUrl,
        builder: (context, state) => const AlarmReplyScreen(),
      ),
      GoRoute(
        name: MatchTabScreen.routeName,
        path: MatchTabScreen.routeUrl,
        builder: (context, state) => const MatchTabScreen(),
      ),
      GoRoute(
        path: '/',
        redirect: (_, __) => '/main',
      ),
      GoRoute(
        path: '/logintabs',
        pageBuilder: (BuildContext context, GoRouterState state) => FadeTransitionPage(
          key: state.pageKey,
          child: const LoginNewScreen(),
        ),
      ),
      // GoRoute(
      //   path: '/main',
      //   redirect: (_, __) => '/main/home',
      // ),
      GoRoute(
        path: '/feed/:feedId',
        redirect: (BuildContext context, GoRouterState state) => '/main/home/${state.pathParameters['feedId']}',
      ),
      GoRoute(
        path: '/main/:kind(home|wake|feed|match|profile)', //home wake feed match profile
        pageBuilder: (BuildContext context, GoRouterState state) => FadeTransitionPage(
          key: App.scaffoldKey,
          child: MainTabsScreen(
            firstTab: TabItem.find(state.pathParameters['kind']),
          ),
        ),
        routes: <GoRoute>[
          GoRoute(
            path: ':feedId',
            builder: (BuildContext context, GoRouterState state) {
              final String bookId = state.pathParameters['feedId']!;
              return FeedDetailScreen(feedId: bookId);
            },
          ),
        ],
      ),
    ],
  );
});
