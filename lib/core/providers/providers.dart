import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final numberProvider = Provider<int>((ref) {
  return 22;
});
final numberStateProvider = StateProvider<int>((ref) {
  return 42;
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

final selectedDate = StateProvider(
  (ref) => DateFormat.yMMMd().format(
    DateTime.now(),
  ),
);

final selectedDateTime = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);