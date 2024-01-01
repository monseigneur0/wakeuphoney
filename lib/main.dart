import 'package:alarm/alarm.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/constants/design_constants.dart';
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

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  MobileAds.instance.initialize();

  await Alarm.init(showDebugLogs: true);

  runApp(const ProviderScope(
    child: WakeUpHoney(),
  ));
}

class WakeUpHoney extends ConsumerWidget {
  const WakeUpHoney({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    final isLoggedIn = ref.watch(authRepositoryProvider).isLoggedIn;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: isLoggedIn
          ? ref.watch(routerProvider)
          : ref.watch(logOutRouterProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      theme: ThemeData(
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
        useMaterial3: true,
      ),
    );
  }
}
