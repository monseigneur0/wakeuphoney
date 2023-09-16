import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'insta_home.dart';
import 'insta_search.dart';

class Instabody extends ConsumerWidget {
  final int index;

  const Instabody({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (index == 0) {
      return const HomeScreen();
    }
    return const SearchScreen();
  }
}
