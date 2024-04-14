import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/dart/extension/context_extension.dart';
import 'package:wakeuphoney/common/widget/w_arrow.dart';
import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/widget/w_empty_expanded.dart';

class LongButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const LongButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          title.text.make(),
          emptyExpanded,
          Arrow(
            color: context.appColors.lessImportant,
          )
        ],
      ),
    );
  }
}
