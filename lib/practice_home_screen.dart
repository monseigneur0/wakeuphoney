import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/users/google_repo.dart';

import 'main.dart';
import 'providerscreen/state_provider.dart';
import 'package:go_router/go_router.dart';

import 'features/alarm/alarm_screen.dart';
import 'features/users/login_screen.dart';
import 'providerscreen/changenotifierprovider.dart';
import 'providerscreen/futureprovider.dart';
import 'providerscreen/provider.dart';
import 'providerscreen/statenodifierprovider.dart';
import 'providerscreen/streamprovider.dart';

class PracticeHome extends ConsumerWidget {
  static String routeName = "practice";
  static String routeURL = "/";
  const PracticeHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number = ref.watch(numberProvider);
    final numberState = ref.watch(numberStateProvider);
    final valueState = ref.watch(valueStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Explorer1'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text(
            'hhh',
            style: TextStyle(color: Colors.grey, fontSize: 30),
          )),
          const Text('numberProvider'),
          Text(number.toString()),
          const Text('numberStateProvider'),
          Text(numberState.toString()),
          const Text('valueStateProvider'),
          Text(valueState.toString()),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.amber)),
            onPressed: () => context.pushNamed(AlarmHome.routeName),
            child: const Text('AlarmHome'),
          ),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.pink)),
            onPressed: () => context.go(LoginHome.routeURL),
            child: const Text('Login Home'),
          ),
          ElevatedButton(
            onPressed: () => GoogleSignInApi.logout(),
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black)),
            child: const Text('logout'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProviderPage(),
                ),
              );
            },
            child: const Text('Provider'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StateProviderPage(),
                ),
              );
            },
            child: const Text('StateProviderPage'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FutureProviderPage(),
                ),
              );
            },
            child: const Text('FutureProvider'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StreamProviderPage(),
                ),
              );
            },
            child: const Text('StreamProvider'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeNotifierProviderPage(),
                ),
              );
            },
            child: const Text('ChangeNotifierProvider'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StateNotifierProviderPage(),
                ),
              );
            },
            child: const Text('StateNotifierProvider'),
          ),
        ],
      ),
    );
  }

  void increment(WidgetRef ref) {}
}
