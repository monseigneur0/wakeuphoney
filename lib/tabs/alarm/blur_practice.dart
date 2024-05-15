import 'dart:ui';

import 'package:flutter/material.dart';

class BlurPractice extends StatefulWidget {
  const BlurPractice({super.key});

  @override
  State<BlurPractice> createState() => _BlurPracticeState();
}

class _BlurPracticeState extends State<BlurPractice> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Text('01' * 10000),
        Center(
          child: ClipRect(
            // <-- clips to the 200x200 [Container] below
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                alignment: Alignment.center,
                width: 200.0,
                height: 200.0,
                child: const Text('Hello World'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
