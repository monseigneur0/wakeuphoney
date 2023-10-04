import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

//survive
final numberProvider = Provider<int>((ref) {
  return 1;
});
final numberStateProvider = StateProvider<int>((ref) {
  return 1;
});
final navStateProvider = StateProvider<int>((ref) {
  return 0;
});

final dateStateProvider = StateProvider<List<String>>(
  (ref) => List<String>.generate(
    100,
    (index) => DateFormat.yMMMd().format(
      DateTime.now().add(
        Duration(days: index),
      ),
    ),
  ),
);

final dateTimeStateProvider =
    StateProvider<List<DateTime>>((ref) => List<DateTime>.generate(
          100,
          (index) => DateTime.now().add(Duration(days: index)),
        ));
final dateTimeNotTodayStateProvider =
    StateProvider<List<DateTime>>((ref) => List<DateTime>.generate(
          100,
          (index) => DateTime.now()
              .add(Duration(
                  seconds: 24 * 60 * 60 -
                      DateTime.now().hour * 3600 -
                      DateTime.now().minute * 60 -
                      DateTime.now().second))
              .add(Duration(days: index)),
        ));

final selectedDate = StateProvider(
  (ref) => DateFormat.yMMMd().format(
    DateTime.now(),
  ),
);

final selectedDateTime = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final leftSecondsMatch = StateProvider<int>((ref) => 0);
final onceClickedMatch = StateProvider<bool>((ref) => false);
final leftCodeTime = StateProvider<String>((ref) {
  const tenMinutes = 3600;

  int totalSeconds = tenMinutes;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds < 1) {
      totalSeconds = ref.watch(leftSecondsMatch.notifier).state--;
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    // logger.d("duration $duration");
    return duration.toString().split(".").first.substring(2, 7);
  }

  return format(totalSeconds);
});
