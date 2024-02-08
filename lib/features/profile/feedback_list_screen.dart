import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/profile/profile_controller.dart';

class FeedbackListScreen extends ConsumerWidget {
  const FeedbackListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(getFeedbackProvider);
    return Scaffold(
      body: SafeArea(
        child: list.when(
          data: (data) {
            // return data.toString().text.make();
            return ListView(
              children: data
                  .map<Widget>(
                    (e) => ListTile(
                      title: (e as Map)['contents'].toString().text.make(),
                      leading: Image.asset(e['image'].toString()),
                      subtitle: e['time'].toString().text.make(),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Error: $error'),
        ),
      ),
    );
  }
}
