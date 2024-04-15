import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/theme/custom_theme_app.dart';
import 'package:flutter/material.dart';

import 'common/theme/custom_theme.dart';
import 'features/auth/auth_repository.dart';
import 'router.dart';

class App extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  ///light, dark 테마가 준비되었고, 시스템 테마를 따라가게 하려면 해당 필드를 제거 하시면 됩니다.
  static const defaultTheme = CustomTheme.dark;
  static bool isForeground = true;

  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> with Nav, WidgetsBindingObserver {
  @override
  GlobalKey<NavigatorState> get navigatorKey => App.navigatorKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return CustomThemeApp(
      child: Builder(builder: (context) {
        return MaterialApp(
          navigatorKey: App.navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Image Finder',
          theme: App.defaultTheme.themeData,
          home: const ProviderScope(child: WakeUpHoney()),
        );
      }),
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
      case AppLifecycleState.hidden: //Flutter 3.13 이하 버전을 쓰신다면 해당 라인을 삭제해주세요.
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}

class WakeUpHoney extends ConsumerWidget {
  const WakeUpHoney({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    final isLoggedIn = ref.watch(authRepositoryProvider).isLoggedIn;

    String? determineFont(Locale locale) {
      switch (locale.languageCode) {
        case 'ko':
          return GoogleFonts.nanumGothic().fontFamily;
        case 'en':
          return GoogleFonts.notoSans().fontFamily;
        // Add cases for other languages as needed
        default:
          return GoogleFonts.raleway().fontFamily; // Use a default for unsupported languages
      }
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: isLoggedIn ? ref.watch(routerProvider) : ref.watch(logOutRouterProvider),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.myPink,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          color: AppColors.myAppBarBackgroundPink,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
