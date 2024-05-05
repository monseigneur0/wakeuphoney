import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedTabScreen extends StatefulHookConsumerWidget {
  static const routeName = 'feed';
  static const routeUrl = '/feed';
  const FeedTabScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedTabScreenState();
}

class _FeedTabScreenState extends ConsumerState<FeedTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
