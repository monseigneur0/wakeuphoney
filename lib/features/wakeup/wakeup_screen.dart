import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/wakeup/wakeup_edit_screen.dart';

import '../wake/wake_edit_screen.dart';

class WakeUpScreen extends ConsumerStatefulWidget {
  const WakeUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeUpScreenState();
}

class _WakeUpScreenState extends ConsumerState<WakeUpScreen> {
  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.7,
          child: WakeEditScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('깨워볼까요?!'),
      ),
      body: Column(children: [
        Flexible(
          flex: 3,
          child: Container(
            color: Colors.blue,
            child: const Center(child: Text("상대가 깨워주지 않았어요?!")),
          ),
        ),
        Flexible(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              context.pushNamed(WakeUpEditScreen.routeName);
            },
            child: Container(
              color: Colors.green,
              child: const Center(child: Text("깨워볼까요?!")),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.yellow,
          ),
        ),
      ]),
    );
  }
}
