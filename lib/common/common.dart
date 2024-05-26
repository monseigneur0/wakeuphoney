import 'package:google_fonts/google_fonts.dart';

export 'dart:async';

export 'package:velocity_x/velocity_x.dart';

export 'package:go_router/go_router.dart';
export 'package:logger/logger.dart';

// export 'package:easy_localization/easy_localization.dart';
export 'package:flutter_svg/flutter_svg.dart';
// export 'package:nav/nav.dart';
export 'package:quiver/strings.dart';
export 'package:flutter_animate/flutter_animate.dart';

export '../common/dart/extension/animation_controller_extension.dart';

export '../common/dart/extension/context_extension.dart';
export '../common/dart/extension/num_extension.dart';
export '../common/dart/extension/num_duration_extension.dart';
export '../common/dart/extension/velocityx_extension.dart';
export '../common/dart/kotlin_style/kotlin_extension.dart';

export 'dart/extension/snackbar_context_extension.dart';
export 'theme/color/abs_theme_colors.dart';
export 'theme/shadows/abs_theme_shadows.dart';
export 'util/async/flutter_async.dart';
export 'widget/w_empty_expanded.dart';
export 'widget/w_height_and_width.dart';
export 'widget/w_line.dart';
export 'widget/w_tap.dart';

export 'constants/constants.dart';
export 'constants/app_colors.dart';
export 'constants/firebase_constants.dart';
export 'utils.dart';
export 'error_text.dart';
export 'loader.dart';
// import 'package:just_audio/just_audio.dart';
export 'package:uuid/uuid.dart';
export 'error/stream_error.dart';

const defaultFontStyle = GoogleFonts.ptSerif;

void voidFunction() {}

bool isNotBlank(String? s) => s != null && s.trim().isNotEmpty;
