import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
export '../../constants/app_colors.dart';

typedef ColorProvider = Color Function();

abstract class AbstractThemeColors {
  const AbstractThemeColors();

  Color get veryBrightGrey => AppColors.brightGrey;

  Color get drawerBg => const Color.fromARGB(255, 255, 255, 255);

  Color get scrollableItem => const Color.fromARGB(255, 57, 57, 57);

  Color get iconButton => const Color.fromARGB(255, 14, 14, 14);

  Color get iconButtonInactivate => const Color.fromARGB(255, 153, 153, 153);

  Color get inActivate => const Color.fromARGB(255, 79, 79, 79);

  Color get activate => const Color.fromARGB(255, 63, 72, 95);

  Color get badgeBg => AppColors.blueGreen;

  Color get textBadgeText => Colors.white;

  Color get badgeBorder => Colors.transparent;

  Color get divider => const Color.fromARGB(255, 80, 80, 80);

  Color get text => AppColors.darkGrey;

  Color get hintText => AppColors.middleGrey;

  Color get focusedBorder => AppColors.darkGrey;

  Color get confirmText => AppColors.blue;

  Color get drawerText => text;

  Color get snackbarBgColor => AppColors.mediumBlue;

  Color get blueButtonBackground => AppColors.darkBlue;

  Color get appBarBackground => const Color.fromARGB(255, 16, 16, 18);

  Color get buttonBackground => const Color.fromARGB(255, 48, 48, 48);

  Color get roundedLayoutBackground => const Color.fromARGB(255, 24, 24, 24);

  Color get unreadColor => const Color.fromARGB(255, 48, 48, 48);

  Color get lessImportant => AppColors.grey;

  Color get blueText => AppColors.blue;

  Color get dimmedText => const Color.fromARGB(255, 171, 171, 171);

  Color get plus => const Color.fromARGB(255, 230, 71, 83);

  Color get minus => const Color.fromARGB(255, 57, 127, 228);

  Color get seedColor => const Color(0xFF120338);

  Color get darkText => AppColors.white;

  Color get appBarBackGround => const Color.fromARGB(255, 16, 16, 18);
}
