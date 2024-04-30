import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/screen/main/main_tabscreen.dart';

class ErrorPage extends StatelessWidget {
  final BuildContext context;
  final GoRouterState state;
  const ErrorPage(
    this.context,
    this.state, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Error: ${state.error}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go(MainTabsScreen.routeUrl);
              },
              child: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}
