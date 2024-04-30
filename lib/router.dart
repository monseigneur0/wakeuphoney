import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/app.dart';
import 'package:wakeuphoney/screen/auth/login_onboard_screen.dart';
import 'package:wakeuphoney/screen/auth/login_tabscreen.dart';
import 'package:wakeuphoney/screen/error/error_page.dart';
import 'package:wakeuphoney/screen/main/main_tabscreen.dart';

import 'common/common.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/maintabs",
    errorBuilder: (context, state) {
      return ErrorPage(context, state);
    },
    navigatorKey: App.navigatorKey,
    redirect: (context, state) {
      return null;
      // if (!isLoggedIn) {
      //   if (state.matchedLocation != LoginHome.routeURL) {
      //     return LoginHome.routeURL;
      //   }
      // }
      // return null;
    },
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
    ],
  );
});

final logOutRouterProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/loginonboardnewscreen",
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
        name: LoginOnBoardScreen.routeName,
        path: LoginOnBoardScreen.routeUrl,
        builder: (context, state) => const LoginOnBoardScreen(),
      ),
    ],
  );
});
