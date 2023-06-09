import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wakeuphoney/practice_home_screen.dart';

import 'google_repo.dart';

class LoginHome extends StatelessWidget {
  static String routeName = "login";
  static String routeURL = "/login";
  const LoginHome({super.key});

  @override
  Widget build(BuildContext context) {
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
                width: 180.0,
                height: 48.0,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      width: 5.0,
                      color: Colors.blue,
                    ),
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const Image(
                    image: AssetImage('assets/google.png'),
                    height: 30,
                  ),
                  label: const Text('Google 로그인'),
                  onPressed: () {
                    GoogleSignInApi().loginWithGoogle();
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () => context.goNamed(PracticeHome.routeName),
                  child: const Text('go home'))
            ],
          ),
        ),
      ),
    );
  }
}
