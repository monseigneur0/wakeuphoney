import 'package:flutter/material.dart';

class FeedDetailScreen extends StatelessWidget {
  final String feedId;
  const FeedDetailScreen({required this.feedId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Detail Screen'),
      ),
      body: Center(
        child: Text('Feed Detail Screen $feedId'),
      ),
    );
  }
}
