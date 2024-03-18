import 'package:alarm/alarm.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/common/common.dart';

import 'features/auth/auth_repository.dart';
import 'firebase_options.dart';
import 'router.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.logAppOpen();

  if (!kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  final status = await AppTrackingTransparency.requestTrackingAuthorization();

  MobileAds.instance.initialize();

  await Alarm.init(showDebugLogs: true);

  runApp(const ProviderScope(
    child: WakeUpHoney(),
  ));
}

class WakeUpHoney extends ConsumerWidget {
  const WakeUpHoney({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    final isLoggedIn = ref.watch(authRepositoryProvider).isLoggedIn;

    final currentLocale = WidgetsBinding.instance.window.locale;

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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
        Locale('zh'),
        Locale('es'),
        Locale('fr'),
        Locale('id'),
        Locale('ja'),
        Locale('my'),
        Locale('pt'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: determineFont(currentLocale),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.myPink,
        ),
        appBarTheme: const AppBarTheme(
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
