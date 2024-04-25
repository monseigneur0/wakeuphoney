import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/app.dart';
import 'package:wakeuphoney/screen/main/main_tabscreen.dart';

import 'common/common.dart';
import 'screen/auth/login_tabscreen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/maintabs",
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
    ],
  );
});

final logOutRouterProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/logintabs",
    routes: [
      GoRoute(
        name: MainTabsScreen.routeName,
        path: MainTabsScreen.routeUrl,
        builder: (context, state) => const MainTabsScreen(),
      ),
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeUrl,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
});
