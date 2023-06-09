import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';

final valueStateProvider = StateProvider<int>((ref) => 32);

class StateProviderPage extends ConsumerWidget {
  static String routeName = "stateprovider";
  static String routeURL = "/stateprovider";
  const StateProviderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<int>(valueStateProvider, (prev, curr) {
      if (curr == 40) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Value is 40')),
        );
      }
      print('stateProviderPage: $prev -> $curr');
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text('State Provider'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                  'The value is numberProvider ${ref.watch(numberStateProvider)}'),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () {
                    ref.read(numberStateProvider.notifier).state++;
                  },
                  child: const Text('Increment')),
              ElevatedButton(
                  onPressed: () {
                    ref.invalidate(numberStateProvider);
                  },
                  child: const Text('Invalidate')),
              Text('The value is  ${ref.watch(valueStateProvider)}'),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () {
                    ref.read(valueStateProvider.notifier).state++;
                  },
                  child: const Text('Increment')),
              ElevatedButton(
                  onPressed: () {
                    ref.invalidate(valueStateProvider);
                  },
                  child: const Text('Invalidate')),
            ],
          ),
        ));
  }
}
