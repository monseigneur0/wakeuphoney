import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

import 'wake_controller.dart';
import 'wake_edit_screen.dart';

class WakeScreen extends ConsumerStatefulWidget {
  const WakeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WakeScreenState();
}

class _WakeScreenState extends ConsumerState<WakeScreen> {
  late List<AlarmSettings> alarms;

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
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
    final list = ref.watch(getWakesListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('깨워볼까요?'),
      ),
      body: Column(
        children: [
          Expanded(
            child: list.when(
              data: (alarms) {
                print(alarms.length);
                return ListView.builder(
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];
                    return ListTile(
                      title: Text(alarm.notificationTitle),
                      subtitle: Text(alarm.notificationBody),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {},
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  err.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          Center(
              child: GestureDetector(
            onTap: () => navigateToAlarmScreen(null),
            child: const Text('알람 추가',
                style: TextStyle(fontSize: 30, color: Colors.black)),
          )),
        ],
      ),
    );
  }
}
