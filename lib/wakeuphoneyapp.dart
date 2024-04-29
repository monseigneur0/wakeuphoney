import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wakeuphoney/features/oldauth/auth_repository.dart';

import 'common/common.dart';
import 'oldrouter.dart';

//이전
class WakeUpHoneyApp extends ConsumerWidget {
  const WakeUpHoneyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();

    final isLoggedIn = ref.watch(authRepositoryProvider).isLoggedIn;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: isLoggedIn ? ref.watch(routerProvider) : ref.watch(logOutRouterProvider),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: context.appColors.seedColor.getMaterialColorValues[600]!,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          color: context.appColors.seedColor.getMaterialColorValues[200],
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

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
