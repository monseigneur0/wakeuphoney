import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providerrepository/stream_service.dart';

final streamValueProvider = StreamProvider.autoDispose((ref) {
  final streamService = ref.watch(steamServiceProvider);
  return streamService.getStream();
});

class StreamProviderPage extends ConsumerWidget {
  static String routeName = "streamprovider";
  static String routeURL = "/streamprovider";
  const StreamProviderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamValue = ref.watch(streamValueProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "stream provider",
      )),
      body: Center(
        child: streamValue.when(data: (int data) {
          return Text(
            data.toString(),
            style: const TextStyle(fontSize: 50),
          );
        }, error: (Object error, StackTrace stacktrace) {
          return Text(error.toString());
        }, loading: () {
          return const CircularProgressIndicator();
        }),
      ),
    );
  }
}
