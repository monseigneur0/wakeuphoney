import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../core/constants/design_constants.dart';
import 'wakeup_controller.dart';
import 'wakeup_edit_screen.dart';

class WakeUpYouScreen extends ConsumerStatefulWidget {
  const WakeUpYouScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WakeUpYouScreenState();
}

class _WakeUpYouScreenState extends ConsumerState<WakeUpYouScreen> {
  @override
  Widget build(BuildContext context) {
    final wakeUpYou = ref.watch(getTomorrowWakeUpYouProvider);
    Logger logger = Logger();

    return Container(
        child: wakeUpYou.when(
            data: (data) {
              if (data.letter.isEmpty || data.letter == "") {
                return GestureDetector(
                    onTap: () {
                      context.pushNamed(WakeUpEditScreen.routeName);
                    },
                    child: Container(
                      color: Colors.green,
                      child: const Center(child: Text("깨워볼까요?!")),
                    ));
              }
              return Container(
                  color: AppColors.myPink,
                  child: Column(children: [
                    Text(data.wakeUpUid),
                    Text(data.wakeTime.toString()),
                    const Text("이때 깨울거야 각오해"),
                  ]));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) {
              logger.e(err);

              return const Center(
                child: Text(
                  "Error\n please restart your app",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }));
  }
}
