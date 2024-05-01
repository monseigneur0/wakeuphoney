import 'package:flutter/material.dart';

class WakeWriteScreen extends StatefulWidget {
  static const routeUrl = '/wakewrite';
  const WakeWriteScreen({super.key});

  @override
  State<WakeWriteScreen> createState() => _WakeWriteScreenState();
}

class _WakeWriteScreenState extends State<WakeWriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('편지쓰기'),
      ),
      body: const Column(
        children: [
          // chooseTime,
        ],
      ),
    );
  }
}
