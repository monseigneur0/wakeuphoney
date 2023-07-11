import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/common/error_text.dart';
import '../../core/common/loader.dart';
import '../../core/providers/firebase_providers.dart';
import '../../core/providers/providers.dart';
import '../../core/utils.dart';
import 'daily_controller.dart';

class ResponseScreen extends ConsumerStatefulWidget {
  static String routeName = "response";
  static String routeURL = "/response";
  const ResponseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends ConsumerState<ResponseScreen> {
  final TextEditingController _messgaeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(authProvider).currentUser!.uid;

    final dateList100 = ref.watch(dateStateProvider);
    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "No Response, No Wake Up",
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          ref.watch(getDailyMessageProvider(dateList100[0])).when(
                data: (message) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          message.message,
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                        ),
                        Text(
                          DateFormat.yMMMd().format(listDateTime[0]),
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[300]),
                        ),
                      ],
                    ),
                  );
                },
                error: (error, stackTrace) {
                  print("error");

                  return ErrorText(
                      error: DateFormat.yMMMd().format(listDateTime[0]));
                },
                loading: () => const Loader(),
              ),
          Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value == "") {
                  return 'Please enter some text';
                }
                return null;
              },
              autofocus: true,
              controller: _messgaeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText:
                      'message at ${DateFormat.yMMMd().format(listDateTime[0])}'),
            ),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                showSnackBar(context, "messgae is saved");
                final String message = _messgaeController.text;
                //메세지 작성
                ref
                    .watch(dailyControllerProvider.notifier)
                    .createResponseMessage(message, uid);
              }

              _messgaeController.clear();
            },
          ),
          const Text(
            "No Response, No Wake Up",
            style: TextStyle(color: Colors.white, fontSize: 40),
          )
        ],
      ),
    );
  }
}
