import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class ManageUserScreen extends ConsumerStatefulWidget {
  static const String routeName = 'manage_user';
  static const String routeUrl = '/manage_user';
  const ManageUserScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends ConsumerState<ManageUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage User'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Text('Manage User Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
