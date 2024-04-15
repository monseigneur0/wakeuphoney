import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wakeuphoney/features/auth/auth_repository.dart';

import 'common/common.dart';
import 'router.dart';

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
