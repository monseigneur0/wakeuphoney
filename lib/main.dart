import 'package:alarm/alarm.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/app.dart';
import 'package:wakeuphoney/wakeuphoney.dart';

import 'common/data/preference/app_preferences.dart';
import 'common/data/preference/prefs.dart';
import 'common/theme/custom_theme.dart';
import 'common/theme/custom_theme_app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await EasyLocalization.ensureInitialized();
  await AppPreferences.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kDebugMode) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logAppOpen();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  final status = await AppTrackingTransparency.requestTrackingAuthorization();

  MobileAds.instance.initialize();

  await Alarm.init(showDebugLogs: true);

  runApp(EasyLocalization(
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
    fallbackLocale: const Locale('en'),
    path: 'assets/translations',
    useOnlyLangCode: true,
    child: CustomThemeApp(
      child: Builder(builder: (context) {
        return const ProviderScope(child: App());
      }),
    ),
  ));
}
