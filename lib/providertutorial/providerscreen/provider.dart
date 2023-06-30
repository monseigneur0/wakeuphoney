import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers/providers.dart';

final valueProvider = Provider<int>((ref) => 12);

class ProviderPage extends ConsumerWidget {
  static String routeName = "provider";
  static String routeURL = "/provider";
  const ProviderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Provider'),
        ),
        body: Column(
          children: [
            Text('The value is numberProvider ${ref.watch(numberProvider)}'),
            Text('The value is valueProvider ${ref.watch(valueProvider)}'),
          ],
        )

        // Consumer(
        //   builder: (BuildContext context, WidgetRef ref, Widget? child) {
        //     return Center(
        //       child: Text('The value is  ${ref.watch(valueProvider)}'),
        //     );
        //   },
        // ),
        );
  }
}
