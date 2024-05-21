import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';

class NormalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPreferred;
  const NormalButton({
    required this.text,
    required this.onPressed,
    this.isPreferred = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPreferred ? AppColors.primary600 : Colors.white,
      ),
      child: isPreferred ? text.text.lg.white.medium.make().p(10) : text.text.lg.color(AppColors.primary600).medium.make().p(10),
    );
  }
}
