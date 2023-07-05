import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/practice_home_screen.dart';

import 'auth_repository.dart';

class LoginHome extends ConsumerWidget {
  static String routeName = "login";
  static String routeURL = "/login";
  const LoginHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SNS LOGIN'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              SizedBox(
                width: 200.0,
                height: 48.0,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      width: 3.0,
                      color: Colors.blue,
                    ),
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const Image(
                    image: AssetImage('assets/apple.png'),
                    height: 30,
                  ),
                  label: const Text('Apple Sign In'),
                  onPressed: () {
                    ref.watch(authRepositoryProvider).signInWithApple(context);
                    context.goNamed(PracticeHome.routeName);
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 200.0,
                height: 48.0,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      width: 3.0,
                      color: Colors.blue,
                    ),
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const Image(
                    image: AssetImage('assets/google.png'),
                    height: 30,
                  ),
                  label: const Text('Google Sign In'),
                  onPressed: () {
                    ref.watch(authRepositoryProvider).loginWithGoogle(context);
                    context.goNamed(PracticeHome.routeName);
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 90,
              ),
              ElevatedButton(
                onPressed: () => context.goNamed(PracticeHome.routeName),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                ),
                child: const Text('go home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
