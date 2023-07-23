import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/auth/auth_controller.dart';
import 'package:wakeuphoney/practice_home_screen.dart';

import 'auth_repository.dart';

class LoginHome extends ConsumerStatefulWidget {
  static String routeName = "login";
  static String routeURL = "/login";
  const LoginHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginHomeState();
}

class _LoginHomeState extends ConsumerState<LoginHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wake up, honey!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  ref.watch(authRepositoryProvider).isLoggedIn
                      ? context.pushNamed(PracticeHome.routeName)
                      : context.pushNamed(LoginHome.routeName);
                },
                icon: const Icon(
                  Icons.connecting_airports_outlined,
                  color: Color(0xFFD72499),
                ))
          ],
          backgroundColor: Colors.grey[900],
          title: const Text('Wake up, honey!'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   width: 200.0,
              //   height: 48.0,
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       foregroundColor: Colors.black,
              //       side: const BorderSide(
              //         width: 3.0,
              //         color: Colors.blue,
              //       ),
              //       backgroundColor: Colors.white,
              //       minimumSize: const Size(double.infinity, 50),
              //     ),
              //     icon: const Image(
              //       image: AssetImage('assets/apple.png'),
              //       height: 30,
              //     ),
              //     label: const Text('Apple Sign In'),
              //     onPressed: () {
              //       ref.watch(authRepositoryProvider).signInWithApple(context);
              //       context.goNamed(PracticeHome.routeName);
              //     },
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade600,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(19),
                          bottomLeft: Radius.circular(19),
                          bottomRight: Radius.circular(19),
                        ),
                      ),
                      child: const Text(
                        "message",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  CustomPaint(painter: Triangle(Colors.indigo.shade600)),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/alarmbearno.png',
                  height: 250,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .watch(authControllerProvider.notifier)
                        .singInWithGoogle(context);
                  },
                  icon: Image.asset(
                    'assets/google.png',
                    width: 35,
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              // SizedBox(
              //   width: 200.0,
              //   height: 48.0,
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       foregroundColor: Colors.black,
              //       side: const BorderSide(
              //         width: 3.0,
              //         color: Colors.blue,
              //       ),
              //       backgroundColor: Colors.white,
              //       minimumSize: const Size(double.infinity, 50),
              //     ),
              //     icon: const Image(
              //       image: AssetImage('assets/google.png'),
              //       height: 30,
              //     ),
              //     label: const Text('Google Sign In'),
              //     onPressed: () {
              //       ref.watch(authRepositoryProvider).loginWithGoogle(context);
              //       context.goNamed(PracticeHome.routeName);
              //     },
              //   ),
              // ),

              // ElevatedButton(
              //   onPressed: () => context.goNamed(PracticeHome.routeName),
              //   style: const ButtonStyle(
              //     backgroundColor: MaterialStatePropertyAll(Colors.green),
              //   ),
              //   child: const Text('go home'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// Create a custom triangle
class Triangle extends CustomPainter {
  final Color backgroundColor;
  Triangle(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = backgroundColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 60);
    path.lineTo(5, 60);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
