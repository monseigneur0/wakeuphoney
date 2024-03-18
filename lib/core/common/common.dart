import 'package:google_fonts/google_fonts.dart';

export 'dart:async';

export 'package:velocity_x/velocity_x.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'package:go_router/go_router.dart';
export 'package:logger/logger.dart';

export '../constants/constants.dart';
export '../constants/design_constants.dart';
export '../constants/firebase_constants.dart';
export '../../core/utils.dart';
export 'error_text.dart';
export 'loader.dart';
// import 'package:just_audio/just_audio.dart';
export 'package:uuid/uuid.dart';

const defaultFontStyle = GoogleFonts.ptSerif;

void voidFunction() {}

bool isNotBlank(String? s) => s != null && s.trim().isNotEmpty;
