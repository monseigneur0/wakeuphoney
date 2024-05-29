import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';

class SingleProfileScreen extends StatelessWidget {
  static const routeUrl = '/singleprofile';
  const SingleProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'my info'.tr().text.make(),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Tap(
                onTap: () {},
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/samples/cherryblossom.png',
                    width: Constants.pngSize,
                    height: Constants.pngSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text('Profile'.tr()),
            ],
          ),
        ],
      ),
    );
  }
}
