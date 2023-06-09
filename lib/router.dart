import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/alarm/alarm_screen.dart';

import 'features/users/google_repo.dart';
import 'features/users/login_screen.dart';
import 'practice_home_screen.dart';
import 'providerscreen/changenotifierprovider.dart';
import 'providerscreen/futureprovider.dart';
import 'providerscreen/provider.dart';
import 'providerscreen/state_provider.dart';
import 'providerscreen/statenodifierprovider.dart';
import 'providerscreen/streamprovider.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: "/login",
    redirect: (context, state) {
      final isLoggedIn = ref.read(googleSignInApiProbider).isLoggedIn;
      print('islogged');
      print(isLoggedIn);
      if (!isLoggedIn) {
        if (state.location != LoginHome.routeURL) {
          return LoginHome.routeURL;
        }
      }
      return null;
    },
    routes: [
      ShellRoute(
          builder: (context, state, child) {
            return child;
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
          ])
    ],
  );
});
