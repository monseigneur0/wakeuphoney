import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/providerrepository/api_service.dart';

import '../providerModels/Suggestion.dart';

final suggetsionFutureProvider =
    FutureProvider.autoDispose<Suggestion>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getSuggestion();
});

class FutureProviderPage extends ConsumerWidget {
  static String routeName = "futureprovider";
  static String routeURL = "/futureprovider";
  const FutureProviderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionRef = ref.watch(suggetsionFutureProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future Provider'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(suggetsionFutureProvider.future),
        child: ListView(
          children: [
            suggestionRef.when(
              data: (data) {
                return Center(
                  child: Text(
                    data.activity,
                  ),
                );
              },
              error: (error, _) {
                return Text(error.toString());
              },
              loading: () {
                return const CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}
