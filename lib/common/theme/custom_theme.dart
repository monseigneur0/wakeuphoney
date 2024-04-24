import 'package:wakeuphoney/common/theme/color/abs_theme_colors.dart';
import 'package:wakeuphoney/common/theme/color/dark_app_colors.dart';
import 'package:wakeuphoney/common/theme/color/light_app_colors.dart';
import 'package:wakeuphoney/common/theme/shadows/abs_theme_shadows.dart';
import 'package:wakeuphoney/common/theme/shadows/dart_app_shadows.dart';
import 'package:wakeuphoney/common/theme/shadows/light_app_shadows.dart';
import 'package:flutter/material.dart';

enum CustomTheme {
  dark(
    DarkAppColors(),
    DarkAppShadows(),
  ),
  light(
    LightAppColors(),
    LightAppShadows(),
  );

  const CustomTheme(this.appColors, this.appShadows);

  final AbstractThemeColors appColors;
  final AbsThemeShadows appShadows;

  ThemeData get themeData {
    switch (this) {
      case CustomTheme.dark:
        return darkTheme;
      case CustomTheme.light:
        return lightTheme;
    }
  }
}

MaterialColor primarySwatchColor = Colors.lightBlue;

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: primarySwatchColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
  // textTheme: CustomGoogleFonts.diphylleiaTextTheme(
  //   ThemeData(brightness: Brightness.light).textTheme,
  // ),
  colorScheme: ColorScheme.fromSeed(seedColor: CustomTheme.light.appColors.seedColor),

  appBarTheme: const AppBarTheme(
    centerTitle: false,
    color: AppColors.white,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: primarySwatchColor,

  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.dark,

  scaffoldBackgroundColor: AppColors.veryDarkGrey,
  // textTheme: GoogleFonts.nanumMyeongjoTextTheme(
  //   ThemeData(brightness: Brightness.dark).textTheme,
  // ),
  colorScheme: const ColorScheme.dark(background: AppColors.veryDarkGrey),
);
