import 'package:alarm/alarm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';

import '../auth/auth_repository.dart';
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
    final list = ref.watch(getWakesListProvider);
    final user = ref.watch(getMyUserInfoProvider);
    Logger logger = Logger();
    return Scaffold(
      appBar: AppBar(
        title: const Text('깨워볼까요?'),
      ),
      body: Column(
        children: [
          Expanded(
            child: list.when(
                data: (alarms) {
                  return user.when(
                      data: (user) {
                        return ListView.builder(
                          itemCount: alarms.length,
                          itemBuilder: (context, index) {
                            final alarm = alarms[index];
                            return Column(
                              children: [
                                user.uid == alarm.sender
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: CachedNetworkImage(
                                            width: 45, imageUrl: user.photoURL))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: CachedNetworkImage(
                                            width: 45,
                                            imageUrl: user.couplePhotoURL ??
                                                user.photoURL)),
                                ListTile(
                                  title: Text(
                                    DateFormat('hh:mm a')
                                        .format(alarm.requestTime),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(DateFormat('EEE, M/d/y')
                                      .format(alarm.requestTime)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      ref
                                          .read(wakeControllerProvider.notifier)
                                          .deleteWake(alarm.uid);
                                    },
                                  ),
                                  // isThreeLine: true,
                                ),
                                user.uid != alarm.sender && !alarm.isApproved
                                    ? GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(wakeControllerProvider
                                                  .notifier)
                                              .approveWake(alarm.uid);
                                        },
                                        child: const Text("승인 요청하시겠어요?"),
                                      )
                                    : alarm.isApproved
                                        ? const Text("승인됨")
                                        : GestureDetector(
                                            onTap: () {
                                              // ref
                                              //     .read(wakeControllerProvider
                                              //         .notifier)
                                              //     .approveWake(alarm.uid);
                                            },
                                            child: const Text("승인 대기중")),
                                const Divider(),
                              ],
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) {
                        logger.e(err);

                        return const Center(
                          child: Text(
                            "Error",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      });
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) {
                  logger.e(err);

                  return const Center(
                    child: Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }),
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
