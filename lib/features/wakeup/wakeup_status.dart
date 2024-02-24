import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class WakeUpStatus extends StatelessWidget {
  final String wakeUpStatusMessage;
  const WakeUpStatus(this.wakeUpStatusMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(4, 4))
          ]),
      child: Text(wakeUpStatusMessage).p(10),
    ).pSymmetric(h: 10, v: 10);
  }
}
