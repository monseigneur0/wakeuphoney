import 'package:flutter/material.dart';

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
    return Dismissible(
      key: key!,
      direction: onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete_forever,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismissed?.call(),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(25),
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
    );
  }
}
