import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/providers.dart';
import 'package:wakeuphoney/auth/login_controller.dart';

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
    final userModel = ref.watch(userModelProvider);
    final userfuture = ref.watch(getUserFutureProvider);
    if (userModel == null) {
      return Container();
    }
    return Column(
      children: [
        if (kDebugMode)
          Container(
            child: user.displayName.text.make(),
          ),
        if (kDebugMode)
          Container(
            child: userModel.displayName.text.make(),
          ),
        Column(
          children: [
            if (kDebugMode)
              Container(
                child: userfuture.when(
                  data: (user) {
                    return user.toMap().toString().text.make();
                  },
                  loading: () {
                    return const CircularProgressIndicator();
                  },
                  error: (error, stackTrace) {
                    return error.toString().text.make();
                  },
                ),
              ),
          ],
        ),
        Container(),
      ],
    );
  }
}
