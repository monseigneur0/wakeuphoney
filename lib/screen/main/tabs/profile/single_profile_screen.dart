import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';

class SingleProfileScreen extends StatelessWidget {
  const SingleProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: '내 정보 관리'.text.make(),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Tap(
                onTap: () => Nav.push(const SingleProfileScreen()),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/samples/cherryblossom.png',
                    width: Constants.pngSize,
                    height: Constants.pngSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text('프로필'),
            ],
          ),
        ],
      ),
    );
  }
}
