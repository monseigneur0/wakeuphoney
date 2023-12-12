import 'package:flutter/material.dart';
import 'package:wakeuphoney/core/constants/design_constants.dart';

class AlarmTile extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final void Function()? onDismissed;

  const AlarmTile(
      {super.key,
      required this.title,
      required this.onPressed,
      this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Dismissible(
        key: key!,
        direction: onDismissed != null
            ? DismissDirection.endToStart
            : DismissDirection.none,
        background: Container(
          alignment: Alignment.centerRight,
          // color: Colors.red,
          decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.only(right: 30),
          child: const Icon(
            Icons.delete_forever,
            size: 30,
            color: Colors.white,
          ),
        ),
        onDismissed: (_) => onDismissed?.call(),
        child: RawMaterialButton(
          fillColor: AppColors.myAppBarBackgroundPink,
          onPressed: onPressed,
          child: Container(
            height: 80,
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 35,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
