import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/screen/auth/login_controller.dart';

class UserLoggedInWidget extends ConsumerStatefulWidget {
  const UserLoggedInWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserLoggedInWidgetState();
}

class _UserLoggedInWidgetState extends ConsumerState<UserLoggedInWidget> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loginControllerProvider);
    Logger logger = Logger();
    logger.d("user: ${user.toMap().toString()}");
    return Container(
      child: user.displayName.text.make(),
    );
  }
}
