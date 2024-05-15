import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/app.dart';
import 'package:wakeuphoney/auth.dart';

import 'package:wakeuphoney/common/route/fade_transition.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/auth/login_tabscreen.dart';
import 'package:wakeuphoney/common/error/error_page.dart';
import 'package:wakeuphoney/main/main_tabscreen.dart';
import 'package:wakeuphoney/tabs/alarm/alarm_tabscreen.dart';
import 'package:wakeuphoney/tabs/feed/feed_detail_scree.dart';
import 'package:wakeuphoney/tabs/feed/feed_tabscreen.dart';
import 'package:wakeuphoney/tabs/tab_item.dart';
import 'package:wakeuphoney/tabs/wake/wake_tabscreen.dart';
import 'package:wakeuphoney/tabs/wake/wake_write_screen.dart';

import 'common/common.dart';

final auth = LoginAuth();

final routerProvider = Provider((ref) {
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
        path: LoginNewScreen.routeUrl, //logintabs
        builder: (context, state) => const LoginNewScreen(),
      ),
      GoRoute(
        name: AlarmTabScreen.routeName,
        path: AlarmTabScreen.routeUrl, //logintabs
        builder: (context, state) => const AlarmTabScreen(),
      ),
      GoRoute(
        name: WakeTabScreen.routeName,
        path: WakeTabScreen.routeUrl, //logintabs
        builder: (context, state) => const WakeTabScreen(),
      ),
      GoRoute(
        name: FeedTabScreen.routeName,
        path: FeedTabScreen.routeUrl, //logintabs
        builder: (context, state) => const FeedTabScreen(),
      ),
      GoRoute(
        name: WakeWriteScreen.routeName,
        path: WakeWriteScreen.routeUrl, //logintabs
        builder: (context, state) => const WakeWriteScreen(),
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
      GoRoute(
        path: '/main',
        redirect: (_, __) => '/main/home',
      ),
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
