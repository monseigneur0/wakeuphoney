import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wakeuphoney/common/common.dart';

extension AnimationControllerExtension on AnimationController {
  void animateToTheEnd() {
    animateTo(1.0, duration: 0.ms);
  }

  void animateToTheBeginning() {
    animateTo(0, duration: 0.ms);
  }
}
