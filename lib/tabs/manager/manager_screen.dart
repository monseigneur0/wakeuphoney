import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/auth.dart';
import 'package:wakeuphoney/auth/login_controller.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/widget/w_main_button.dart';
import 'package:wakeuphoney/tabs/bitcoin/bitcoin_screen.dart';
import 'package:wakeuphoney/tabs/match/user_widget.dart';

class ManagerScreen extends ConsumerStatefulWidget {
  static const String routeName = 'manager';
  static const String routeUrl = '/manager';
  const ManagerScreen({super.key});

  @override
  ConsumerState<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends ConsumerState<ManagerScreen> {
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
      body: SingleChildScrollView(
        child: Column(
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
            ),
            MainButton(
              'update user info',
              onPressed: () {
                ref.read(loginControllerProvider.notifier).updateGPTcount();
              },
            ),
            MainButton(
              'BitcoinScreeno',
              onPressed: () {
                context.go(BitcoinScreen.routeUrl);
              },
            ),
            const UserLoggedInWidget(),
          ],
        ).pSymmetric(h: 10, v: 10),
      ),
    );
  }
}
