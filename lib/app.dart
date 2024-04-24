import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/oldrouter.dart';

import 'common/fcm_manager.dart';
import 'common/theme/custom_theme.dart';
import 'features/oldauth/auth_repository.dart';

class App extends ConsumerStatefulWidget {
  ///light, dark 테마가 준비되었고, 시스템 테마를 따라가게 하려면 해당 필드를 제거 하시면 됩니다.
  static const defaultTheme = CustomTheme.dark;
  static bool isForeground = true;
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  const App({super.key});

  @override
  ConsumerState<App> createState() => AppState();
}

class AppState extends ConsumerState<App> with WidgetsBindingObserver, Nav {
  final ValueKey<String> _scaffoldKey = const ValueKey<String>('App scaffold');
  String _authStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    FcmManager.requestPermission();
    FcmManager.initialize();
    WidgetsBinding.instance.addObserver(this);
    initPlugin();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> initPlugin() async {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Request system's tracking authorization dialog
      final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    final isLoggedIn = ref.watch(authRepositoryProvider).isLoggedIn;

    return MaterialApp.router(
      scaffoldMessengerKey: App.scaffoldMessengerKey,
      routerConfig: isLoggedIn ? ref.watch(routerProvider) : ref.watch(logOutRouterProvider),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'WakeupBear',
      theme: context.themeType.themeData,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        App.isForeground = true;
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        App.isForeground = false;
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => App.navigatorKey;

  // late final GoRouter _router = GoRouter(
  //   navigatorKey: App.navigatorKey,
  //   routes: <GoRoute>[
  //     GoRoute(
  //       path: '/',
  //       redirect: (_, __) => '/main',
  //     ),
  //     GoRoute(
  //       path: '/signin',
  //       pageBuilder: (BuildContext context, GoRouterState state) => FadeTransitionPage(
  //         key: state.pageKey,
  //         child: Container(
  //           color: Colors.green,
  //           child: Center(
  //             child: RoundButton(
  //               text: '로그인',
  //               onTap: () {
  //                 _auth.signIn('hong', '1234');
  //               },
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //     GoRoute(
  //       path: '/main',
  //       redirect: (_, __) => '/main/home',
  //     ),
  //     GoRoute(
  //       path: '/productPost/:postId',
  //       redirect: (BuildContext context, GoRouterState state) => '/main/home/${state.pathParameters['postId']}',
  //     ),
  //     GoRoute(
  //       path: '/main/:kind(home|localLife|nearMy|chat|my)',
  //       pageBuilder: (BuildContext context, GoRouterState state) => FadeTransitionPage(
  //         key: _scaffoldKey,
  //         child: MainScreen(
  //           firstTab: TabItem.find(state.pathParameters['kind']),
  //         ),
  //       ),
  //       routes: <GoRoute>[
  //         GoRoute(
  //           path: ':postId',
  //           builder: (BuildContext context, GoRouterState state) {
  //             final String postId = state.pathParameters['postId']!;
  //             if (state.extra != null) {
  //               final post = state.extra as SimpleProductPost;
  //               return PostDetailScreenWithRiverpod(
  //                 int.parse(postId),
  //                 simpleProductPost: post,
  //               );
  //             } else {
  //               return PostDetailScreenWithRiverpod(int.parse(postId));
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   ],
  //   redirect: _auth.guard,
  //   refreshListenable: _auth,
  //   debugLogDiagnostics: true,
  // );
}
