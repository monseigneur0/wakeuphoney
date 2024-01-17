import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'wakeup_me_screen.dart';
import 'wakeup_you_screen.dart';

class WakeUpScreen extends StatelessWidget {
  const WakeUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('깨워볼까요?!'),
      ),
      body: Column(children: [
        const Flexible(
          flex: 3,
          child: WakeUpMeScreen(),
        ),
        const Flexible(
          flex: 3,
          child: WakeUpYouScreen(),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.yellow,
            child: Center(child: "여긴 광고에요".text.make()),
          ),
        ),
      ]),
    );
  }
}
