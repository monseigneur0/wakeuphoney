import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';

class ManagerScreen extends StatelessWidget {
  static const String routeName = 'manager';
  static const String routeUrl = '/manager';
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultStyle = Theme.of(context).textTheme.bodyMedium!;

    // Access properties of the defaultStyle object
    final fontFamily = defaultStyle.fontFamily;
    final fontSize = defaultStyle.fontSize;
    final fontWeight = defaultStyle.fontWeight;
    final color = defaultStyle.color;
    Logger logger = Logger();
    logger.d('fontFamily: $fontFamily');
    logger.d('fontSize: $fontSize');
    logger.d('fontWeight: $fontWeight');
    logger.d('color: $color');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Manager Screen'),
          ),
          'Check Font Family'.text.size(16).make(),
          'Check Font Family'.text.size(16).fontFamily('Pretendard').make(),
          const Text(
            'Check Font Family',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Check Font Family-',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Check Font Family',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w100,
            ),
          ),
          const Text(
            'Check Font Family',
            style: TextStyle(
              fontSize: 16,
              // fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: Text(
              'Check Font Family',
              style: defaultStyle,
            ),
          ),
          Container(
            height: 100,
            width: 100,
            color: const Color(0xff1c1b1e),
          )
        ],
      ),
    );
  }
}
