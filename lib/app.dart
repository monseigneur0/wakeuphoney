import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth.dart';
import 'package:wakeuphoney/auth/login_repository.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/router.dart';

import 'common/fcm_manager.dart';
import 'common/theme/custom_theme.dart';

class App extends ConsumerStatefulWidget {
  ///light, dark 테마가 준비되었고, 시스템 테마를 따라가게 하려면 해당 필드를 제거 하시면 됩니다.
  static const defaultTheme = CustomTheme.dark;
  static bool isForeground = true;

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();
  static ValueKey<String> scaffoldKey = const ValueKey<String>('App scaffold');

  const App({super.key});

  @override
  ConsumerState<App> createState() => AppState();
}

class AppState extends ConsumerState<App> with WidgetsBindingObserver {
  final String _authStatus = 'Unknown';

  // final auth = LoginAuth();

  @override
  void initState() {
    super.initState();
    FcmManager.initialize(ref);
    WidgetsBinding.instance.addObserver(this);
    // initPlugin();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Future<void> initPlugin() async {
  //   final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  //   setState(() => _authStatus = '$status');
  //   // If the system can show an authorization request dialog
  //   if (status == TrackingStatus.notDetermined) {
  //     // Request system's tracking authorization dialog
  //     final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
  //     setState(() => _authStatus = '$status');
  //   }

  //   final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  // }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    final isLoggedIn = ref.watch(loginRepositoryProvider).isLoggedIn;
    Logger logger = Logger();
    // logger.d('isLoggedIn:  $isLoggedIn');

    ///앱의 최상단. app 이전과 main tabs 이후로 나뉜다.
    ///user는 main tabs에서 모든게 시작되기 때문에 main tabs 에서 stream builder 만든다.
    ///alarm을 initialize 하기위한 statefulwidget이 필요하다. 한번 위에서 감싸줄필요가 있다.

    final auth = ref.watch(authLoginProvider);

    return LoginAuthScope(
      notifier: auth,
      child: MaterialApp.router(
        scaffoldMessengerKey: App.scaffoldMessengerKey,
        routerConfig: ref.watch(routerProvider),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'WakeupBear',
        theme: context.themeType.themeData,
      ),
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
}