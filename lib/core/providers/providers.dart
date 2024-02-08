import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/features/auth/user_model.dart';

final numberProvider = Provider<int>((ref) {
  return 1;
});
final numberStateProvider = StateProvider<int>((ref) {
  return 1;
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

final userModelofMeStateProvider = StateProvider<UserModel?>((ref) => null);
