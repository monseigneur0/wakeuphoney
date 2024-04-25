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
      child: isPreferred
          ? text.text.size(16).white.bold.make().p(10)
          : text.text.size(16).color(AppColors.primary600).bold.make().p(10),
    );
  }
}
