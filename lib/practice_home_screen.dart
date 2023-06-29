import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/chatapp/screen/auth/login_screen.dart';

import 'chatapp/screen/home_screen.dart';
import 'features/couples/couples_list_screen.dart';
import 'features/dailymessages/daily_screen.dart';
import 'features/messages/messages_screen.dart';
import 'features/movie/movie_screen.dart';
import 'features/product/product.dart';
import 'features/profile/couple_profile_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/users/google_repo.dart';
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
        backgroundColor: Colors.black87,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(ref.watch(googleSignInApiProbider).user?.displayName ??
                "no user"),
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                onPressed: () => context.pushNamed(MyChatApp.routeName),
                child: const Text('MyChatApp'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                onPressed: () => context.pushNamed(LoginScreen.routeName),
                child: const Text('chatlogin'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                onPressed: () => context.pushNamed(AlarmHome.routeName),
                child: const Text('AlarmHome'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                onPressed: () {
                  context.go(LoginHome.routeURL);
                },
                child: const Text('Login Home'),
              ),
              ElevatedButton(
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text("Plx dont go"),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("No"),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            ref
                                .watch(googleSignInApiProbider)
                                .logout()
                                .then((value) =>
                                    context.goNamed(AlarmHome.routeName))
                                .then((value) => Navigator.of(context).pop());
                          },
                          isDestructiveAction: true,
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
                child: const Text('logout check'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(MessagesScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple)),
                child: const Text('MessagesScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(DailyMessageScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple)),
                child: const Text('DailyMessageScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(CouplesListScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepOrange)),
                child: const Text('CouplesListScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(ProfileScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                child: const Text('ProfileScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(CoupleProfileScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                child: const Text('CoupleProfileScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(MovieScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                child: const Text('MovieScreen'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(ProductScreen.routeName);
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                child: const Text('ProductScreen'),
              ),
              const Text('numberProvider'),
              Text(number.toString()),
              const Text('numberStateProvider'),
              Text(numberState.toString()),
              const Text('valueStateProvider'),
              Text(valueState.toString()),
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
        ],
      ),
    );
  }
}
